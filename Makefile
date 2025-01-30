# vars
PROJECT="orion"

# targets
cluster:
	@kind create cluster --name $(PROJECT) --config juno/kind.yaml || echo "Cluster already exists..."

down:
	@kind delete cluster --name $(PROJECT)

ingress:
	@echo "Installing NGINX Ingress..."
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml > /dev/null 2>&1
	@sleep 30
	@kubectl wait --namespace ingress-nginx \
		--for=condition=ready pod \
		--selector=app.kubernetes.io/component=controller \
		--timeout=90s > /dev/null 2>&1

orion: cluster ingress
	@echo "Installing Orion..."
	@helm upgrade -i -f .values.yaml $(PROJECT) ./
