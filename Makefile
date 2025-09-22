up:
	minikube start
	terraform -chdir=terraform init
	terraform -chdir=terraform apply -auto-approve
	kubectl -n argocd apply -f argocd/dev/deployment.yaml
	kubectl -n argocd apply -f argocd/staging/deployment.yaml
	kubectl -n argocd apply -f argocd/prod/deployment.yaml
