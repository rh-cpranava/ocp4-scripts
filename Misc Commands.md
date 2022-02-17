Misc Commands

* Get list of all images being used in cluster
```
oc get pod -A -o jsonpath={.items[*].spec.containers[*].image} | tr -s '[[:space:]]' '\n' | sort | uniq -c
```
* Get list of etcd objects
```
etcdctl get / --prefix --keys-only --command-timeout=1m | sed '/^$/d'| cut -d/ -f3 | sort | uniq | sort -rn
```
