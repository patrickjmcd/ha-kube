scp -r patrickjmcd@192.168.1.252:/volume1/kube-secrets/secrets .
kubectl create ns drone
kubectl create ns openfaas-fn
kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.14/deploy/manifests/00-crds.yaml
kubectl apply -f storage/ cert-manager/ secrets/
helmfile apply
kubectl apply -f openfaas/