SCRIPTS_DIR=$(dirname $0)
CONFS_DIR=${SCRIPTS_DIR}/../confs
P2_CONFS_DIR=${SCRIPTS_DIR}/../../P2/confs
k3d cluster create --config ${CONFS_DIR}/k3d-config.yaml &&
	kubectl apply -f ${P2_CONFS_DIR}/deployments.yaml &&
	kubectl apply -f ${P2_CONFS_DIR}/services.yaml &&
	kubectl apply -f ${P2_CONFS_DIR}/ingress.yaml
