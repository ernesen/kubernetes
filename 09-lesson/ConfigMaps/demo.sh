
# Deploy the ConfigMap
kubectl create -f configmap.yaml

# Create the Pod with Env Var
kubectl create -f pod-cmd.yaml --validate=false

# check the logs
kubectl logs test-pod-cmd

# Create the Pod with  Env Var
kubectl create -f pod-env.yaml

# Check the env vars
kubectl exec -it test-pod-env /bin/sh

# Create thePod with Env Var
kubectl create -f pod-vol.yaml

# Check logs
kubectl logs test-pod-vol

# Access the shell
kubectl exec -it test-pod-vol /bin/sh

# Check the files
cd /etc/config 
cat log.level
cat log.location

# Exit & clean up
exit 

# additional content

kubectl get configmap

kubectl get configmap -o yaml

kubectl get pod --show-all

kubectl get pod -a

env
