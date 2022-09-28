d="$(date +%H%M%S)"
for i in `oc get pods -n openshift-ingress -oname`
do
  oc exec -n openshift-ingress -it $i -- sh -c 'echo "show sess" | socat /var/lib/haproxy/run/haproxy.sock stdio' >> active-connections-$d.txt
done
cat active-connections-$d.txt | grep srv=p | awk '{print $6}' | uniq -c
if [ -f active-connections-$d.txt ] ; then
    rm active-connections-$d.txt
fi
