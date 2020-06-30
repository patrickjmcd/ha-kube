#!/bin/bash
# rsync -aP secrets/ nas:/volume1/kube-secrets/secrets/
kubectl create ns drone
# kubectl create ns openfaas-fn
kubectl create ns monitoring
kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.14/deploy/manifests/00-crds.yaml
kubectl apply -f storage/ -f secrets/
helmfile apply

# kubectl apply -f openfaas/
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.1/aio/deploy/alternative.yaml  
kubectl apply -f dashboard/
kubectl apply -f cronjobs/

kubectl wait pods -l app.kubernetes.io/instance=cert-manager -n kube-system --for=condition=Ready --timeout=-1s
kubectl apply -f cert-manager/
kubectl wait pods -l app=nginx-ingress -n kube-system --for=condition=Ready --timeout=-1s
kubectl apply -f unifi/