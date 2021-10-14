# Update

## Flow

* Ensure that the cluster env variables in the scripts are set as per the environment in all the scripts.
* Run the release-upload-mirror.sh with OCP Version as argument.
Example:
```
./release-upload-mirror.sh 4.6.3
```
* Run the release-upload-mirror.sh with OCP Version as argument
```
./create-image-signature-config.sh 4.6.3
```
## Verify update
```
./oc-cluster-update.sh <enter-SHA-digest>
```

Run the following commands to verify the update:
```
oc get pods -n openshift-kube-apiserver
oc get pods -n openshift-etcd
oc get clusteroperator
oc get clusterversion
```
