# Minikube + Terraform + ArgoCD GitOps

## Prerequisites
The following tools should be installed.

- Minikube
- Terraform
- Helm
- kubectl
- Docker
- Make

## Install & Run

```sh
make up
```

**`make up` will:**
- Start Minikube
- Run Terraform to create the namespaces, and install Argocd
- Install ArgoCD with Helm
- Deploy the sample Nginx app via ArgoCD for 3 environments: Dev, Staging, Prod.

## Access ArgoCD UI
`minikube service argocd -n argocd` 
**username**: `admin`
**password**: ` kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`


## GitOps via ArgoCD

- This setup uses a docker image of the html app. To promoto to staging/prod. you'd typically update the image tag in the values.yaml file and commit the changes. 
    - `argocd/staging/values.yaml`
    - `argocd/prod/values.yaml`
- Then sync the application via ArgoCD UI or CLI. Argocd can also automatically sync.
- **Rollback**: Roolbacks can easily be effected from the ArgoCD UI or via GitHub Actions workslow.

## App: Nginx "hello it's me"

- Simple Nginx container serving `hello it's me` by running for example:
    ```
    minikube service nginx-app-dev -n external-dev
    ```
- See `Dockerfile` and `index.html`
- Deployments manifest in `argocd/environment/deployment.yaml`


## Monitoring Metrics

| Metric             | Threshold | Why Important                                       |
|--------------------|-----------|-----------------------------------------------------|
| Pod Ready          | < 1 pod   | Nginx app must be running                           |
| Pod Restarts       | > 3/day   | Indicates crashing or instability                   |
| HTTP 200 Rate      | < 95%     | Ensures clients receive responses                   |
| HTTP 500 Rate      | > 5%      | Ensure errors afe found early before it escalates   |
| Deployment Sync    | Any drift | ArgoCD drift alerts for config/manifest changes     |
| Resource Usage     | >80% CPU  | Prevent cluster resource exhaustion                 |
| Latency            |           | High latency means slow upstreams, overloaded workers, or network issues.                 |
| Total requests                    Helps you measure load and detect traffic anomalies
| 

**Alerting**: Use Prometheus and Alertmanager
Thresholds can be defined in Prometheus rules, e.g. Pod restarts >3 in 24h, CPU >80%.