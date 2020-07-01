#!/bin/bash
# echo "Copying Secrets"
# rsync -aP secrets/ nas:/volume1/kube-secrets/secrets/

echo "!!! setting up namespaces"
kubectl create ns drone
kubectl create ns monitoring

echo "!!! installing certmanager CRDs"
kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.14/deploy/manifests/00-crds.yaml

echo "!!! setting up Storage & Secrets"
kubectl apply -f storage/ -f secrets/
helmfile apply

echo "!!! setting up Kubernetes Dashboard"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.1/aio/deploy/alternative.yaml  
kubectl apply -f dashboard/dashboard.admin-user.yml
rm -rf dashboard/dashboard.ingress.yml
TKN=$(kubectl -n kubernetes-dashboard get secret -o jsonpath="{.data.token}" $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}') | base64 --decode)
sed "s/<token>/${TKN}/" dashboard/dashboard.ingress.template > dashboard/dashboard.ingress.yml
kubectl apply -f dashboard/dashboard.ingress.yml

echo "!!! setting up cronjobs"
kubectl apply -f cronjobs/

echo "!!! waiting for certmanager to be ready before applying cert issues"
kubectl wait pods -l app.kubernetes.io/instance=cert-manager -n kube-system --for=condition=Ready --timeout=-1s
kubectl apply -f cert-manager/

echo "!!! waiting for nginx-ingress to grab the first IP from metallb before setting up Unifi ingest"
kubectl wait pods -l app=nginx-ingress -n kube-system --for=condition=Ready --timeout=-1s
kubectl apply -f unifi/

echo "!!! setting up ARM-specific temperature monitoring"
kubectl apply -f prometheus/

echo "!!! setting up post-install stuff"
kubectl apply -f postinstall/