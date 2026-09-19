SCRIPTS_DIR=$(dirname $0)
CONFS_DIR=${SCRIPTS_DIR}/../confs
k3d cluster create --config ${CONFS_DIR}/k3d-config.yaml
