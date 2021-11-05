# Steps to change Local Mirror Image Registry

## Assumptions
1. Disconnected setup
2. Mirror registry is already setup

## Add ca cert of the private internal registry to trusted certs
1. Pause the Worker and Master MCPs to increase the pace of customization
```
oc patch --type=merge --patch='{"spec":{"paused":true}}' machineconfigpool/master
oc patch --type=merge --patch='{"spec":{"paused":true}}' machineconfigpool/worker
```

2. Edit the configmap  belonging to the registry to the list of trusted CA's in OpenShift
```
oc edit custom-ca registry-cas -n openshift-config 
<Enter the details of the config map>
```

3. Patch the updated registry config map to cluster instance of proxy (If already not done):
```
oc patch proxy --patch '{"spec":{"additionalTrustedCA":{"name":"registry-cas"}}}' --type=merge
```
Note: Make sure to modify the registry config map details

## Add the pull secret of the new registry to OpenShift
1. Store the pull secret in a text file
```
oc get secret/pull-secret -n openshift-config --template='{{index .data ".dockerconfigjson" | base64decode}}' > pull-secret-updated.txt
```
2. Add the pull secret of the new private internal registry to the secret
```
oc registry login --registry="utilityvm-uat.example.com:5000" --auth-basic="username:password" --to=pull-secret-updated.txt
```
Note: Make sure to modify the registry and authentication details

3. Update the local secret instance
```
oc set data secret/pull-secret -n openshift-config --from-file=.dockerconfigjson=pull-secret-updated.txt
```

## Modify the ImageContentSourcePolicies
1. Modify the ImageContentSourcePolicies to point to the new mirror registry
```
oc edit imagecontentsourcepolicy image-policy-0
oc edit imagecontentsourcepolicy image-policy-1
```

