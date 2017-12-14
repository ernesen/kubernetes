# Deploy RC
kubectl create -f nginx-rs.yaml
kubectl get pods -o wide
kubectl scale --replicas=10 rs/nginx
kubectl delete rs nginx

# Deploy DS
kubectl create -f nginx-ds.yaml
kubectl get pods -o wide
kubectl scale --replicas=10 ds/nginx
kubectl delete ds nginx

# Install Sematext agent as DS
kubectl create -f sema.yaml
kubectl get pods -o wide
kubectl get pods ds sematext-agent

# Test the agent
kubectl create -f nginx-rs.yaml
kubectl scale --recplicas=10 rs/nginx

# Clean up

