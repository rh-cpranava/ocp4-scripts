oc get clusterversion >> verification_${date +"%m-%d-%y-%T"}
oc get clusteroperators >> verification_${date +"%m-%d-%y-%T"}
oc get nodes -o wide >> verification_${date +"%m-%d-%y-%T"}
oc get pods -A | grep -v "Running\|Completed\|Terminated|\Succeeded" >> verification_${date +"%m-%d-%y-%T"}
oc get mcp -o yaml | grep -i pause >> verification_${date +"%m-%d-%y-%T"}
