OCP_RELEASE=$1
LOCAL_REGISTRY=localhost:5000
LOCAL_REPOSITORY=ocp-release/openshift4
PRODUCT_REPO='openshift-release-dev'
LOCAL_SECRET_JSON=/root/pull.json
REMOVABLE_MEDIA_PATH=<tmp-folder>
ARCHITECTURE=x86_64
RELEASE_NAME="ocp-release" 

echo "Sourcing ImageContentSourcePolicy for this release"
oc adm -a ${LOCAL_SECRET_JSON} release mirror --from=quay.io/${PRODUCT_REPO}/${RELEASE_NAME}:${OCP_RELEASE}-${ARCHITECTURE} --to=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY} --to-release-image=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY}:${OCP_RELEASE}-${ARCHITECTURE} --run-dry

echo "Downloading oc client for OCP ${OCP_RELEASE}"
wget "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/$OCP_RELEASE/openshift-client-linux.tar.gz" -O "$REMOVABLE_MEDIA_PATH/oc-${OCP_RELEASE}.tar.gz"

echo "Downloading openshift-install client for OCP ${OCP_RELEASE}"
wget "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/$OCP_RELEASE/openshift-install-linux.tar.gz" -O "$REMOVABLE_MEDIA_PATH/openshift-install-${OCP_RELEASE}.tar.gz"

echo "Push the release images to the local registry for OCP ${OCP_RELEASE}"
oc adm -a ${LOCAL_SECRET_JSON} release mirror --from=quay.io/${PRODUCT_REPO}/${RELEASE_NAME}:${OCP_RELEASE}-${ARCHITECTURE} --to=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY} --to-release-image=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY}:${OCP_RELEASE}-${ARCHITECTURE} --apply-release-image-signature
