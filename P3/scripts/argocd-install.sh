set -eux
cd /tmp
ARGOCD_VERSION="${ARGOCD_VERSION:-$(curl -sL https://api.github.com/repos/argoproj/argo-cd/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')}"
ARGOCD="${ARGOCD:-argocd}"
curl -LO "https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-amd64"
expected="$(curl -sL "https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/cli_checksums.txt" | grep argocd-linux-amd64 | awk '{print $1}')"
echo "${expected}  argocd-linux-amd64" | sha256sum -c -
sudo install -m 0755 argocd-linux-amd64 "/usr/local/bin/${ARGOCD}"
