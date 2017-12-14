# Deploy MySQL
kubectl create -f mysql.yaml

# Check the deployment
kubectl get po
kubectl get svc

# Check the databases in MySQL
export NODEPORT=31949

mysql -u root -ppassword -h 192.168.99.100 -P $NODEPORT -e "show databases"

# Run the DB Init Job
kubectl create -f db-init-job.yaml

# Check the Pods
kubectl get po -a

# Access the logs
kubectl logs db-init*

# Check the databases in MySQL
mysql -u root -p password -h localhost -P $NODEPORT -e "show databases" 

kubectl describe job db-init