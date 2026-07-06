#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHART_DIR="$SCRIPT_DIR/.."
PROJECT="orion"
CLUSTER_NAME="$PROJECT"
KIND_NODE="$CLUSTER_NAME-control-plane"
SCENARIO="${SMOKE_SCENARIO:-dns}"
INGRESS_PROVIDER="${INGRESS_PROVIDER:-nginx}"
VALUES_FILE="$SCRIPT_DIR/test-values-${SCENARIO}.yaml"

if [ ! -f "$VALUES_FILE" ]; then
  echo "[FATAL] Values file not found: $VALUES_FILE"
  exit 1
fi

echo "[SCENARIO] $SCENARIO"

# ---- Provision cluster ----
echo "[CLUSTER] Deleting existing Kind cluster..."
kind delete cluster --name "$CLUSTER_NAME" 2>/dev/null || true

echo "[CLUSTER] Creating Kind cluster..."
kind create cluster \
  --image kindest/node:v1.30.0 \
  --name "$CLUSTER_NAME" \
  --config "$CHART_DIR/juno/kind.yaml"

# ---- Install ArgoCD (required by Genesis for argoproj.io CRDs) ----
echo "[ARGOCD] Installing ArgoCD..."
kubectl create namespace argocd 2>/dev/null || true
kubectl create -n argocd -f "https://raw.githubusercontent.com/argoproj/argo-cd/v2.10.16/manifests/install.yaml"
kubectl rollout status deployment/argocd-server \
  --namespace argocd \
  --timeout=120s

# ---- Install Genesis from GitHub (host set to avoid ingress conflict with hubble) ----
echo "[GENESIS] Installing Genesis from GitHub..."
helm install genesis \
  "https://github.com/juno-fx/Genesis-Deployment/archive/refs/heads/main.tar.gz" \
  --set "env.BASIC_AUTH_EMAIL=admin@juno-innovations.com" \
  --set "env.BASIC_AUTH_PASSWORD=juno" \
  --set "host=genesis.internal" \
  --set "titan.owner=admin" \
  --set "titan.email=admin@juno-innovations.com" \
  --set "titan.uid=1000"
kubectl wait --namespace argocd \
  --for=condition=ready pod \
  --selector=app=genesis \
  --timeout=180s

# ---- Create juno-auth-secret (required by Hubble) ----
kubectl create secret generic juno-auth-secret \
  --from-literal=token=smoke-test-token \
  -n argocd \
  --dry-run=client -o yaml | kubectl apply -f -

# ---- Install ingress provider ----
echo "[CLUSTER] Installing ingress provider: $INGRESS_PROVIDER..."
case "$INGRESS_PROVIDER" in
  nginx)
    NGINX_URL="https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml"
    kubectl apply -f "$NGINX_URL"
    kubectl rollout status deployment/ingress-nginx-controller \
      --namespace ingress-nginx \
      --timeout=90s
    ;;
  traefik)
    helm repo add traefik https://traefik.github.io/charts 2>/dev/null || true
    helm upgrade -i traefik traefik/traefik \
      --namespace traefik --create-namespace \
      --set "deployment.kind=DaemonSet" \
      --set "ports.web.hostPort=80" \
      --set "ports.websecure.hostPort=443" \
      --set "service.spec.type=NodePort"
    kubectl rollout status daemonset/traefik --namespace traefik --timeout=90s
    ;;
  cilium)
    helm repo add cilium https://helm.cilium.io/ 2>/dev/null || true
    helm upgrade -i --namespace kube-system cilium cilium/cilium \
      --set kubeProxyReplacement=true \
      --set ingressController.enabled=true \
      --set ingressController.loadbalancerMode=shared \
      --set ingressController.hostNetwork.enabled=true \
      --set ingressController.hostNetwork.sharedListenerPort=80 \
      --set 'envoy.securityContext.capabilities.envoy={NET_BIND_SERVICE,NET_ADMIN,SYS_ADMIN}' \
      --set envoy.securityContext.capabilities.keepCapNetBindService=true
    kubectl rollout status daemonset/cilium --namespace kube-system --timeout=120s
    kubectl rollout status daemonset/cilium-envoy --namespace kube-system --timeout=120s
    ;;
  *)
    echo "[FATAL] Unknown ingress provider: $INGRESS_PROVIDER"
    exit 1
    ;;
esac

# ---- Wait for coredns to be ready (prevents transient DNS errors) ----
echo "[DNS] Waiting for coredns to be ready..."
kubectl rollout status deployment/coredns --namespace kube-system --timeout=60s

# ---- Deploy Orion ----
echo "[DEPLOY] Installing Orion chart..."
helm upgrade -i "$PROJECT" "$CHART_DIR" -f "$VALUES_FILE" \
  --set "ingressClassName=${INGRESS_PROVIDER}"

# ---- Wait for hubble pod ----
echo "[WAIT] Waiting for hubble pod to be ready..."
kubectl wait --namespace default \
  --for=condition=ready pod \
  --selector=app=hubble \
  --timeout=180s

# ---- Test via Docker container on kind network ----
HOST_FLAG=()
[ "$SCENARIO" = "dns" ] && HOST_FLAG=(-H "Host: orion.local")

echo "[TEST] Running smoke test via container on kind network..."

PASS=false
for i in 1 2 3 4 5; do
  HTTP_CODE=$(docker run --rm --network=kind curlimages/curl:latest \
    -sSfL -o /dev/null -w "%{http_code}" \
    "${HOST_FLAG[@]}" "http://${KIND_NODE}/login" 2>/dev/null) || true

  if [ "$HTTP_CODE" = "200" ]; then
    PASS=true
    break
  fi
  echo "[RETRY] Attempt $i: (HTTP $HTTP_CODE) 'Juno Innovations' not found, waiting 3s..."
  sleep 3
done

# ---- Assert ----
if [ "$PASS" = true ]; then
  echo "[PASS] ${SCENARIO}: Login page returned HTTP 200"
else
  echo "[FAIL] ${SCENARIO}: Login page not reachable (final HTTP ${HTTP_CODE:-N/A})"
fi

# ---- Collect diagnostics on failure ----
if [ "$PASS" = false ]; then
  echo "--- Hubble pod describe ---"
  kubectl describe pod -n default -l app=hubble 2>/dev/null || true
  echo "--- Hubble pod logs ---"
  kubectl logs -n default -l app=hubble --tail=20 2>/dev/null || true
fi

# ---- Teardown ----
echo "[TEARDOWN] Deleting Kind cluster..."
kind delete cluster --name "$CLUSTER_NAME"

if [ "$PASS" = true ]; then
  exit 0
else
  exit 1
fi
