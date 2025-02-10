# vars
PROJECT="orion"

# targets
cluster:
	@kind create cluster --image kindest/node:v1.30.0 --name $(PROJECT) --config juno/kind.yaml || echo "Cluster already exists..."

down:
	@kind delete cluster --name $(PROJECT)

ingress:
	@echo "Installing NGINX Ingress..."
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
	@sleep 30
	@kubectl wait --namespace ingress-nginx \
		--for=condition=ready pod \
		--selector=app.kubernetes.io/component=controller \
		--timeout=90s

orion: cluster ingress
	@echo "Installing Orion..."
	@helm upgrade -i -f .values.yaml $(PROJECT) ./
	@echo "Waiting for Orion to settle..."
	@sleep 10
	@kubectl wait --namespace default \
		--for=condition=ready pod \
		--selector=app=hubble \
		--timeout=180s
	@echo "Orion ready..."
	@kubectl get pods
