#!/bin/bash

#Calculation retention rate for audit, log and infra
audit_log_retention_rate=`oc get clusterlogging -n openshift-logging -o=jsonpath='{.spec.logStore.retentionPolicy.audit.maxAge}' | sed 's/[^0-9]*//g'`
infra_log_retention_rate=`oc get clusterlogging instance -n openshift-logging -o=jsonpath='{.spec.logStore.retentionPolicy.infra.maxAge}' | sed 's/[^0-9]*//g'`
app_log_retention_rate=`oc get clusterlogging instance -n openshift-logging -o=jsonpath='{.spec.logStore.retentionPolicy.application.maxAge}' | sed 's/[^0-9]*//g'`

#Get the first running elastic search pod
es_pod=`oc -n openshift-logging get po -lcomponent=elasticsearch | grep Running | awk '{print $1}' | head -n 1`

#Calculate size for primary.store.size audit, log and infra, indices
infra_size=`oc -n openshift-logging rsh -c elasticsearch $es_pod es_util --query=_cat/indices/infra?bytes=gb | awk '{s+=$(NF)} END{print s}'`
audit_size=`oc -n openshift-logging rsh -c elasticsearch $es_pod es_util --query=_cat/indices/audit?bytes=gb | awk '{s+=$(NF)} END{print s}'`
app_size=`oc -n openshift-logging rsh -c elasticsearch $es_pod es_util --query=_cat/indices/app?bytes=gb | awk '{s+=$(NF)} END{print s}'`

echo "****************Infra Log Consumption**************"
echo "Total Infra log consumption: ${infra_size} GB"
echo "Per Day Infra log consumption: $(( infra_size/infra_log_retention_rate )) GB"

echo "****************Audit Log Consumption**************"
echo "Total Audit log consumption: ${audit_size} GB"
echo "Per Day Audit log consumption: $(( audit_size/audit_log_retention_rate )) GB"

echo "****************App Log Consumption****************"
echo "Total App log consumption: ${app_size} GB"
echo "Per Day App log consumption: $(( app_size/app_log_retention_rate )) GB"

echo "***************************************************"
