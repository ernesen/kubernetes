# Create the ConfigMap from the configuration file
kubectl create configmap example-redis-config --from-file=redis-config 

# Show the configMap in YAML format
kubectl get configmap example-redis-config -o yaml 

# Create the Redis Pod
kubectl create -f redis.yaml 

# Check the Pod; Wait for the Pod to be created
kubectl get pods

# get log file from redis container
kubectl logs redis

# Check the configuration
kubectl exec -it redis redis-cli

# Exectute the following commands in the Redis shell at 127.0.0.1;6379>
CONFIG GET maxmemory
CONFIG GET maxmemory-policy

# Clean up
kubectl delete configmap example-redis-config
kubectl delete pod redis
