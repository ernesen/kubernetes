# Deploy Nginx container
kubectl run my-web --image=nginx --port=80

# Expose Nginx container
kubectl expose deployment my-web --target-port=80 --type=NodePort

# Get the node IP for minikube
minikube ip 

# Check the NodePort 
kubectl describe svc my-web

# Access Ngnix
PORT=$(kubectl get svc my-web -o go-template='{{(index .spec.ports 0).nodePort}}')
