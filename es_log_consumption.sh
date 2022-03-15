#!/bin/bash

#Calculate Retention Rate
audit_log_retention_rate=`oc get clusterlogging instance -n openshift-logging -o=jsonpath='{.spec.logStore.retentionPolicy.audit.maxAge}' | sed 's/[^0-9]*//g'`
infra_log_retention_rate=`oc get clusterlogging instance -n openshift-logging -o=jsonpath='{.spec.logStore.retentionPolicy.infra.maxAge}' | sed 's/[^0-9]*//g'`
app_log_retention_rate=`oc get clusterlogging instance -n openshift-logging -o=jsonpath='{.spec.logStore.retentionPolicy.application.maxAge}' | sed 's/[^0-9]*//g'`

#Select Elastic Search Pod
es_pod=`oc -n openshift-logging get po -lcomponent=elasticsearch | grep Running | awk '{print $1}' | head -n 1`

#Calculate Infra Log Consumption
infra_size_bytes=`oc -n openshift-logging rsh -c elasticsearch $es_pod es_util --query=infra/_stats/store | jq '._all.primaries.store.size_in_bytes'`
infra_size=$(bc <<< "scale=3;$infra_size_bytes/1000000000")
infra_size_daily=$(bc <<< "scale=3;$infra_size/7")

#Calculate Audit Log Consumption
audit_size_bytes=`oc -n openshift-logging rsh -c elasticsearch $es_pod es_util --query=audit/_stats/store | jq '._all.primaries.store.size_in_bytes'`
audit_size=$(bc <<< "scale=3;$audit_size_bytes/1000000000")
audit_size_daily=$(bc <<< "scale=3;$audit_size/7")

#Calculate App Log Consumption
app_size_bytes=`oc -n openshift-logging rsh -c elasticsearch $es_pod es_util --query=app/_stats/store | jq '._all.primaries.store.size_in_bytes'`
app_size=$(bc <<< "scale=3;$app_size_bytes/1000000000")
app_size_daily=$(bc <<< "scale=3;$app_size/7")

echo "****************Infra Log Consumption**************"
echo "Total Infra log consumption: ${infra_size} GB"
echo "Per Day Infra log consumption: ${infra_size_daily} GB"

echo "****************Audit Log Consumption**************"
echo "Total Audit log consumption: ${audit_size} GB"
echo "Per Day Audit log consumption: ${audit_size_daily} GB"

echo "****************App Log Consumption****************"
echo "Total App log consumption: ${app_size} GB"
echo "Per Day App log consumption: ${app_size_daily} GB"
echo "***************************************************"
