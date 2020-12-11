# ocp4_cert_checker

#### oc debug --image registry.redhat.io/rhel8/support-tools  node/master-0.ocp4.example.com -- bash -c 'cat /host/bin/openssl' > /tmp/openssl
#### oc -n openshift-monitoring create secret generic openssl-bin --from-file=openssl=/tmp/openssl
#### oc create -f cert_checker.yaml
