set -eux
SCRIPTS_DIR="$(dirname $0)"
CONFS_DIR="${SCRIPTS_DIR}/../confs"

if ! which k3d; then sh "${SCRIPTS_DIR}/k3d-install.sh"; fi
if ! which helm; then sudo snap install helm --classic; fi
if ! which kubectl; then sh "${SCRIPTS_DIR}/kubectl-install.sh"; fi

k3d cluster create --config "${CONFS_DIR}/k3d-config.yaml"

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  --version 10.1.3 \
  --set server.service.type=NodePort \
  --set "server.service.nodePorts.http=30080" \
  --set configs.params."server\.insecure"=true

ARGOCD_VERSION="$(helm show chart argo/argo-cd --version 10.1.3 | grep '^appVersion:' | awk '{print $2}')"
ARGOCD="argocd-${ARGOCD_VERSION}"
if ! which "${ARGOCD}"; then
	ARGOCD_VERSION="${ARGOCD_VERSION}" ARGOCD="${ARGOCD}" sh "${SCRIPTS_DIR}/argocd-install.sh"
fi

kubectl wait --for=condition=available deployment \
  -l app.kubernetes.io/name=argocd-server \
  -n argocd \
  --timeout=300s

SECRET="$(kubectl get secret argocd-initial-admin-secret \
  -n argocd \
  -o jsonpath="{.data.password}" | base64 -d)"

until "${ARGOCD}" login localhost:30080 \
  --username admin \
  --password "${SECRET}" \
  --insecure \
  --grpc-web; do
	echo "Argo CD is unavailable for now, trying again in 3s..."
	sleep 3
done

kubectl apply -f "${CONFS_DIR}/dev-repository.yaml"
kubectl apply -f "${CONFS_DIR}/dev-app.yaml"

echo "Secret password: ${SECRET}"
