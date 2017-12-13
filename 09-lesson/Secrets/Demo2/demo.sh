# Create base64 encoded username
echo admin | base64 # YWRtaW4=

# Create base64 encoded password
echo S0meP@ssw0rd | base64 # UzBtZVBAc3N3MHJE

# Create a generic secret from YAML file
kubectl create -f my-secret.yaml

# Create the Pod
kubectl create -f secret-env-pod.yaml

# Access the Secret in the Pod
kubectl exec -it secret-env-pod /bin/sh
env 

# Clean up 
kubectl delete -f my-secret.yaml -f secret-env-pod.yaml

# https://www.json2yaml.com/
