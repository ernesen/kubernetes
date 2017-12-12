# Create the deployment
kubectl create -f j-hello.yaml -f j-hello-svc.yaml --validate=false

# List the deployment
kubectl get deployments --watch

# Access the pod
export NODE_PORT=30001 
curl 192.168.99.100:$NODE_PORT 

# Scale the deployment 
kubectl scale deployment j-hello --replicas 10

# Check the status of deployment
kubectl rollout status deploy/j-hello

# Upgrade to version 2
kubectl set image deployment j-hello j-hello=janakiramm/j-hello:2

# Pause the deployment
kubectl rollout pause deploy/j-hello

# Check the current version of deployment
while true; do curl 192.168.99.100:$NODE_PORT; printf '%s\r\n'; sleep 1; done

# Check the current version of deployment and resume from the pause
kubectl rollout resume deployment/j-hello

# Clean up
kubectl delete deployment j-hello
kubectl delete service j-hello



