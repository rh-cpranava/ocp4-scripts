#!/bin/bash

##
## ip-check.sh OpenShift script to check IP pool on VM is not exceeding value 
##
##
ipam_margin_for_alert=20


function get_octets(){
    pod_cidr=`oc get clusternetwork default -o=jsonpath='{.clusterNetworks[0].CIDR}'`
    end=$(ipcalc --ipv4 -b $pod_cidr | cut -d . -f 2)
    begin=$(ipcalc --ipv4 -n $pod_cidr | cut -d . -f 2)
    seq -s \| $begin $end
}

echo "------------------------- Host Subnet Value -------------------------"

host_subnet_length=`oc get clusternetwork default -o=jsonpath='{.clusterNetworks[0].hostSubnetLength}'`
ip_per_node=$((2**host_subnet_length))
echo $ip_per_node

### Check total number of IPs per node
echo "------------------------- All nodes' IP count -------------------------"
for node in `oc get nodes | grep 'worker' | awk '{print $1}'`; do
    echo "Node: $node"
    
    # Get IPs from /var/lib/cni/networks/openshift-sdn/
    var_lib_ip_count=`oc debug -q node/$node -- chroot /host sh -c "ls /var/lib/cni/networks/openshift-sdn/ | wc -l"`
    (($var_lib_ip_count)) ||  var_lib_ip_count=0
    echo "Total IPs in /var/lib: $var_lib_ip_count"
    
    # Get Pod IPs from API
    api_ip_count=`oc get pods -owide -A | egrep $(get_octets) | grep $node | wc -l`
    (($api_ip_count)) ||  api_ip_count=0
    echo "Total IPs according to API: $api_ip_count"
    
    # Fetch Max Value between /var/lib and api
    if [ $var_lib_ip_count -gt 0 ] || [ $api_ip_count -gt 0 ]
    then 
       max_value=$( [ $var_lib_ip_count -gt $api_ip_count ] && echo "$var_lib_ip_count" || echo "$api_ip_count" )
    else 
       max_value=0
    fi
    
    # Check for node IPAM allocation
    if [ $max_value -gt 0 ]
    then
       (( `expr $ip_per_node - $ipam_margin_for_alert` <= $max_value )) && echo "Node $node IPAM almost full" || echo "Node $node has enough space"
    fi
    
    echo ""
done
