cd /tmp
STABLE_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${STABLE_VERSION}/bin/linux/amd64/kubectl"
expected=$(curl -L -s https://dl.k8s.io/${STABLE_VERSION}/bin/linux/amd64/kubectl.sha256)
echo "${expected}  kubectl" | sha256sum -c - &&
	sudo install -m 0755 kubectl /usr/local/bin/ &&
	kubectl version --client
