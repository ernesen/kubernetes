
kubectl create -f pod-vol-local.yaml

kubectl describe pod nginx

vagrant status

kubectl config get-contexts

minikube ssh

kubectl exec -it nginx /bin/sh

kubectl config use-context minikube

# On the Master Node of the Kubernetes Cluster
cat /etc/exports
/opt/data 10.245.1.2/24(rw,sync,no_root_squash,no_all_squash)

kubectl get pv 
kubectl get pvc 

kubectl create -f my-pv.yaml

kubectl describe pod my-pod

kubectl exec -it my-pod /bin/sh




