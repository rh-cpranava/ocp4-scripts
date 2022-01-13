filename=verification_$(date +"%m-%d-%y-%T")

echo "oc get clusterversion"  >> $filename

oc get clusterversion >> $filename

echo "***********************************" >> $filename

echo "oc get clusteroperators"  >> $filename

oc get clusteroperators >> $filename

echo "***********************************" >> $filename

echo "oc get clusterversion"  >> $filename

oc get clusterversion >> $filename

echo "***********************************" >> $filename

echo "oc get nodes -o wide"  >> $filename

oc get nodes -o wide >> $filename

echo "***********************************" >> $filename

echo 'oc get pods -A | grep -v "Running\|Completed\|Terminated|\Succeeded"'  >> $filename

oc get pods -A | grep -v "Running\|Completed\|Terminated|\Succeeded" >> $filename

echo "***********************************" >> $filename

echo "oc get mcp -o yaml | grep -i pause"  >> $filename

oc get mcp -o yaml | grep -i pause >> $filename

echo "***********************************" >> $filename

echo "oc get pod -o wide -n openshift-kube-apiserver"   >> $filename

oc get pod -o wide -n openshift-kube-apiserver  >> $filename

echo "***********************************" >> $filename

echo "oc get pod -o wide -n openshift-etcd"  >> $filename

oc get pod -o wide -n openshift-etcd  >> $filename

echo "***********************************" >> $filename
