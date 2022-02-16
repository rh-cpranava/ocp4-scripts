Misc Commands

* Get list of all images being used in cluster
```
oc get pod -A -o jsonpath={.items[*].spec.containers[*].image} | tr -s '[[:space:]]' '\n' | sort | uniq -c
```
