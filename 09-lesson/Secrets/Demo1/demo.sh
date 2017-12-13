# Create a generic secret from files
kubectl create secret generic dbsecret --from-file=./username.txt --from-file=./password.txt

# Check the creation of Secret
kubectl get secret

# Check the creation of Secret in YAML
kubectl get secret -o yaml 

# Decode the secret
echo UzBtZVBAc3N3MHJE | base64 -D 

# Create the Pod
kubectl create -f secret-pod.yaml

# Access the Secret in the Pod
kubectl exec -it secret-pod /bin/sh
cd /etc/foo

# Clean up 
kubectl delete secret dbsecret
kubectl delete -f secret-pod.yaml
