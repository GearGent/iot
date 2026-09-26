# P1 — K3s cluster with Vagrant

Spins up a small [K3s](https://k3s.io) cluster of two Ubuntu 24.04 VMs (libvirt provider) using Vagrant.

| VM           | Role               | IP             | Resources       |
|--------------|--------------------|----------------|-----------------|
| `geargencS`  | K3s server         | 192.168.56.110 | 2 CPU, 2048 MB  |
| `geargencSW` | K3s agent (worker) | 192.168.56.111 | 1 CPU, 1024 MB  |

## How it works

- On the first `vagrant up`, a random token is generated in `.k3s_token` (git-ignored) and shared by both VMs.
- The server is provisioned first (`VAGRANT_NO_PARALLEL`), then the worker joins the cluster through `https://192.168.56.110:6443` using that token.
- Flannel runs on the private network interface (`eth1`).
- `vagrant destroy` deletes the `.k3s_token` file.

## Usage

```sh
vagrant up                      # create and provision both VMs
vagrant ssh geargencS -c "kubectl get nodes -o wide"
vagrant destroy -f              # remove the VMs and the token
```

## Requirements

- Vagrant with the `vagrant-libvirt` plugin
- libvirt / QEMU
