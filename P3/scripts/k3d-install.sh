set -eux
K3D_VERSION=${K3D_VERSION:-v5.9.0}
cd /tmp
base="https://github.com/k3d-io/k3d/releases/download/${K3D_VERSION}"
curl -sSfLO "${base}/k3d-linux-amd64"
curl -sSfLO "${base}/checksums.txt"
expected=$(grep 'k3d-linux-amd64$' checksums.txt | awk '{print $1}')
echo "${expected}  k3d-linux-amd64" | sha256sum -c -
sudo install -m 0755 k3d-linux-amd64 /usr/local/bin/k3d
