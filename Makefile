# vars
PROJECT="orion"

# targets
cluster:
	@kind create cluster --name $(PROJECT) --config juno/kind.yaml || echo "Cluster already exists..."

down:
	@kind delete cluster --name $(PROJECT)

# testing
test: down cluster dependencies

# dependencies
dependencies: ingress argo orion argo-credentials

ingress:
	@echo "Installing NGINX Ingress..."
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml > /dev/null 2>&1
	@sleep 30
	@kubectl wait --namespace ingress-nginx \
		--for=condition=ready pod \
		--selector=app.kubernetes.io/component=controller \
		--timeout=90s > /dev/null 2>&1

argo:
	@echo "Installing ArgoCD..."
	@kubectl create namespace argocd || echo " - Namespace argocd already exists"
	@kubectl -n argocd apply -f  https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml > /dev/null 2>&1
	@kubectl wait --namespace argocd \
		--for=condition=ready pod \
		--selector=app.kubernetes.io/name=argocd-server \
		--timeout=90s
	@kubectl -n argocd apply -f juno/argo-service.yaml

orion:
	@echo "Installing Orion..."
	@helm install -f values.yaml $(PROJECT) ./ --wait

argo-credentials:
	@echo "ArgoCD Credentials..."
	@echo "Username:"
	@echo "admin"
	@echo "Password: "
	@kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
	@echo
	@echo "ArgoCD URL:"
	@echo "http://localhost:30900/"
