#!/bin/bash
# WARNING: NEED TO USE '/tmp' PATH FOR SPLITTING THE CERTIFICATES
cd /tmp

# GET THE CERTIFICATE BUNDLE AND PRINT THE DATE
oc -n openshift-kube-apiserver-operator get cm kube-apiserver-to-kubelet-client-ca -o jsonpath='{.data.ca-bundle\.crt}' > ca-bundle.crt
csplit -f kube-apiserver-to-kubelet-client-ca- ca-bundle.crt '/-----BEGIN CERTIFICATE-----/' '{*}' 2>&1 > /dev/null
for cert in `ls kube-apiserver-to-kubelet-client-ca-{01..99} 2> /dev/null` ; do
CERTDATE=$(openssl x509 -dates -noout -in $cert | grep notAfter)
CERTDATE=${CERTDATE/notAfter=/}
CERTDATE=$(TZ=Asia/Shanghai date --date="$CERTDATE")
CERTROT=$(TZ=Asia/Shanghai date --date="$CERTDATE 73 days ago")
echo "$CERTROT|$CERTDATE"
done

# CLEAN UP THE EXTRACTED CERTIFICATES
for cert in `ls kube-apiserver-to-kubelet-client-ca-{00..99} 2> /dev/null` ; do
rm -rf $cert
done
