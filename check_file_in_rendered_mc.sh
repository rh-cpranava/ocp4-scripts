#!/bin/bash
#Asumption:
# RHEL 7 or RHEL8 OS
# Assumed that the file is URL encoded and NOT base64 encoded

file_to_check="/etc/kubernetes/kubelet.conf"

function url_decode(){
  if grep -q -i "release 8" /etc/redhat-release
  then
    python -c "import sys, urllib.parse as ul; print(ul.unquote(sys.argv[1] if len(sys.argv) > 1 else sys.stdin.read()[0:-1]))"
  elif grep -q -i "release 7" /etc/redhat-release
  then
    python2 -c "import urllib, sys; print urllib.unquote(sys.argv[1] if len(sys.argv) > 1 else sys.stdin.read()[0:-1])"
  else
    echo "Script incompatible"
    exit 1
  fi
}

for i in `oc get mc --no-headers | awk '{print $1}' | grep rendered-worker`
do
 oc get mc $i -o json | jq .spec.config.storage.files | jq ".[] | select(.path==\"$file_to_check\") | .contents.source" | url_decode > $i.conf 
done 
