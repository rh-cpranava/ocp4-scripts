LOCAL_REGISTRY=localhost:5000
LOCAL_REPOSITORY=ocp-release/openshift4
SHA256=$1

echo "Perform cluster upgrade"
oc adm upgrade --allow-explicit-upgrade --to-image ${LOCAL_REGISTRY}/${LOCAL_REPOSITORY}@${SHA256}
