# Pruning for OpenShift 4/RHEL 7 mirror registry

1. Download the opm cli package from OpenShift mirror site (https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest-4.7/opm-linux.tar.gz)
```
tar xvf opm-linux.tar.gz
```

2. Install grpcurl from the official GitHub repository (https://github.com/fullstorydev/grpcurl/releases)
```
tar xvf grpcurl_1.8.5_linux_x86_64.tar.gz
```

3. Run a podman container
```
podman run --privileged -d quay.io/podman/stable --name podman-container
```

4. Transfer the opm package to the container and provide the appropriate privileges
```
podman cp opm podman-container:/tmp
podman exec podman-container /bin/bash -c 'mv /tmp/opm /usr/bin'
podman exec podman-container /bin/bash -c 'chmod +x /usr/bin'
```

5. Ensure that the package is running and the version is the latest one
```
#podman exec -it podman-container bash
(inside-podman-container)# opm --version
```

6. Log into mirror registry with access to the OPM image inside the podman-container
```
(inside-podman-container)# podman login <registry-url-of-podman>
```

7. 


