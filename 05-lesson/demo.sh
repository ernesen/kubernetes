# location of demo 
# D:\MyLearningProjects\kubernetes\Demos\janakirammsv\Demos\05-lesson

# Create the deployment
kubectl create -f j-hello.yaml -f j-hello-svc.yaml --validate=false

# List the deployment
kubectl get deployments

# Describe the deployment
kubectl describe deployments

# List the pods
kubectl get pods

# List the pods with labels
kubectl get pods --show-labels

# List the Replica Sets
kubectl get rs --show-labels

# Access the pod
export NODE_PORT=30001 # set NODE_PORT=30001 curl 192.168.99.100:$NODE_PORT # 
curl 192.168.99.100:$NODE_PORT #http://192.168.99.100:30001/

# Scale the deployment 
kubectl scale deployment j-hello --replicas 10

# Check the status of deployment
kubectl rollout status deploy/j-hello

# Pause the deployment
kubectl rollout pause deploy/j-hello

# Check the current version of deployment
while true; do curl 192.168.99.100:$NODE_PORT; printf '%s\r\n'; sleep 1; done

# Check the current version of deployment and resume from the pause
kubectl rollout resume deployment/j-hello

# Upgrade to version 2
kubectl set image deployment j-hello j-hello=janakiramm/j-hello:2

watch kubectl get pods

# Check the history
kubectl rollout history deployment j-hello

# Undo the previous upgrade
kubectl rollout undo deploy/j-hello

# Clean up
kubectl delete deployment j-hello
kubectl delete service j-hello

:'
kubectl set image deployment j-hello j-hello=janakiramm/j-hello:2

kubectl rollout pause deploy/j-hello

kubectl rollout resume deploy/j-hello
'


