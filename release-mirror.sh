LOCAL_REGISTRY=localhost:5000
LOCAL_REPOSITORY=ocp-release/openshift4
PRODUCT_REPO='openshift-release-dev'
LOCAL_SECRET_JSON=/root/pull.json
REMOVABLE_MEDIA_PATH=<tmp-folder>

echo "Sourcing ImageContentSourcePolicy for this release"

oc adm release mirror -a ${LOCAL_SECRET_JSON} --to-dir=${REMOVABLE_MEDIA_PATH}/mirror quay.io/${PRODUCT_REPO}/${RELEASE_NAME}:${OCP_RELEASE}-${ARCHITECTURE} --dry-run

echo "Mirroring content for OCP ${OCP_RELEASE}"

oc adm release mirror -a ${LOCAL_SECRET_JSON} --to-dir=${REMOVABLE_MEDIA_PATH}/mirror quay.io/${PRODUCT_REPO}/${RELEASE_NAME}:${OCP_RELEASE}-${ARCHITECTURE}

echo "Downloading oc client for OCP ${OCP_RELEASE}"

wget "https://mirror.openshift.com/pub/openshift-v4/clients/oc/$OCP_RELEASE/linux/oc.tar.gz" -O "/root/mirror/openshift-client-linux-${OCP_RELEASE}.tar.gz"

echo "Downloading oc client for OCP ${OCP_RELEASE}"

wget "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/$OCP_RELEASE/openshift-client-linux.tar.gz" -O "/root/mirror/openshift-client-linux-${OCP_RELEASE}.tar.gz"

echo "Downloading openshift-install client for OCP ${OCP_RELEASE}"

wget "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/$OCP_RELEASE/openshift-install-linux.tar.gz" -O "/root/mirror/openshift-client-linux-${OCP_RELEASE}.tar.gz"
