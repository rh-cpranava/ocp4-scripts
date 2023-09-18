#!/bin/bash

current_user="$(oc whoami)"

seeding_user="${1:-$current_user}"

pod_names="$(oc get pod -n openshift-logging -l component=kibana -o name | cut -d'/' -f2)"
pod_name="$(echo $pod_names | cut -d' ' -f1)"
echo "Seeding index patterns for $seeding_user using kibana pod $pod_name..."

user_name="$(oc whoami --as=$seeding_user)"
user_token="$(oc whoami -t --as=$seeding_user)"

private_tenant="__user__"
admin_tenant="admin"

app_pattern="app*"
infra_pattern="infra*"
audit_pattern="audit*"

create_index_pattern() {
	pattern="$1"
	tenant="$2"

	echo "-- Creating $pattern index pattern"
	oc exec -n openshift-logging -c kibana ${pod_name} -- curl -s -o /dev/null -XPOST "http://localhost:5601/api/saved_objects/index-pattern/$pattern" -H 'kbn-xsrf: true' -H "x-forwarded-user: $user_name" -H "securitytenant: $tenant" -H "Authorization: Bearer $user_token" -H 'Content-Type: application/json' -d '{"attributes": {"title": "'$pattern'", "timeFieldName": "@timestamp"}}'
	echo "-- Done"
}

set_default_pattern() {
	pattern="$1"
	tenant="$2"

	echo "-- Setting default index pattern as $pattern"
	oc exec -n openshift-logging -c kibana ${pod_name} -- curl -s -o /dev/null -XPOST "http://localhost:5601/api/saved_objects/config/$kibana_version" -H 'kbn-xsrf: true' -H "x-forwarded-user: $user_name" -H "securitytenant: $tenant" -H "Authorization: Bearer $user_token" -H 'Content-Type: application/json' -d '{"attributes": {"defaultIndex" : "'$pattern'"}}'
	oc exec -n openshift-logging -c kibana ${pod_name} -- curl -s -o /dev/null -XPOST "http://localhost:5601/api/kibana/settings" -H 'kbn-xsrf: true' -H "x-forwarded-user: $user_name" -H "Authorization: Bearer $user_token" -H 'Content-Type: application/json' -d '{"changes": {"defaultIndex" : "'$pattern'"}}'
	echo "-- Done"
}

get_kibana_version() {
	oc exec -n openshift-logging -c kibana ${pod_name} -- bin/kibana --version
}

kibana_version="$(get_kibana_version)"

echo "Performing operations for private tenant"
create_index_pattern "$app_pattern" "$private_tenant"
set_default_pattern "$app_pattern" "$private_tenant"

oc auth can-i get pods/logs -n default --as=$seeding_user 1>&2 > /dev/null
if [[ $? -eq 0 ]]; then
	create_index_pattern "$infra_pattern" "$private_tenant"
	create_index_pattern "$audit_pattern" "$private_tenant"

	echo "Performing operations for admin tenant"
	create_index_pattern "$app_pattern" "$admin_tenant"
	create_index_pattern "$infra_pattern" "$admin_tenant"
	create_index_pattern "$audit_pattern" "$admin_tenant"

	set_default_pattern "$app_pattern" "$admin_tenant"
fi

echo "Done!"
