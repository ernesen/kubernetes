# cordoning Node
kubectl get nodes
kubectl get pods -o wide

kubectl scale --replicas=5 rs/myemp
kubectl get pods -o wide

kubectl cordon 192.168.27.102
kubectl scale --replicas=10 rs/myemp
kubectl get pods -o wide

kubectl undordon 192.168.27.101
kubectl scale --replicas=20 rs/myemp
kubectl get pods -o wide
kubectl scale --replicas=5 rs/myemp

# Draining Node and move to another Node 
kubectl get pods -o wide
kubectl drain 192.168.27.102 --force
kubectl get pods -o wide

kubectl uncordon 192.168.27.101
kubectl scale --replicas=10 rs/myemp
kubectl get pods -o wide

# Watching Pod Status
kubectl get pods --watch-only
kubectl scale --replicas=20 rs/myemp
kubectl scale --replicas=5 rs/myemp

# Port Forwarding 
kubectl get svc myemp
kubectl port-forward myemp 3000:3000

# Copying Files from Host
kubectl exec -it myemp /bin/sh
cd public
ls
kubectl cp ./test.html myemp:/usr/src/app/public/test.html
ls 
kubectl cp myemp:/usr/src/app/public/test.html ./test.html 

# Explain Objects
kubectl explain
kubectl explain po
kubectl explain scv

# Formart Output
kubectl get pod myemp -o=yaml
kubectl get pod myemp -o=json

# List Containers in a Pod
kubectl get pods myemp -o jsonpath={.spec.containers[*].name}

# Sort by Name
kubectl get services --sort-by=.metadata.name

# List Pods along with the Node
kubectl get pod -o wide | awk -F" " '{ print $1  " " $7 }' | column -t

# Edit Objects
kubectl edit pod/myemp
KUBE_EDITOR="sublime" kubectl edit pod/myemp

# Proxy
kubectl proxy
kubectl proxy --port=8000
open http://localhost:8000/ui
curl http://localhost:8000/api
curl -s http://localhost:8000/api/v1/nodes | jq '.items[] .metadata.labels'

# List exposed APIs
kubectl api-versions

# Create Pod and Service through API
kubectl get pods
curl -s http://localhost:8000/api/v1/namespaces/default/pods -XPOST -H 'Content-Type: application/json' -d@nginx-pod.json | jq '.status'
curl -s http://localhost:8000/api/v1/namespaces/default/pods -XPOST -H "Content-Type: application/json" -d@db-pod.json | jq ".status"
kubectl get pods
curl -s http://localhost:8000/api/v1/namespaces/default/services -XPOST -H 'Content-Type: application/json' -d@nginx-svc.json | jq '.spec.clusterIP'
curl -s http://localhost:8000/api/v1/namespaces/default/services -XPOST -H "Content-Type: application/json" -d@db-svc.json | jq ".spec.clusterIP"
kubectl get svc
curl http://localhost:8000/api/v1/namespaces/default/services/nginx-service -XDELETE
kubectl get svc
kubectl get pods
curl http://localhost:8000/api/v1/namespaces/default/pods/nginx -XDELETE
kubectl get pods  

curl nginx.default.svc.cluster.local:8080



docker run -it ibmcom/secure-gateway-client --net="host" ixLpPDsMNEB_prod_ng -t eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb25maWd1cmF0aW9uX2lkIjoiaXhMcFBEc01ORUJfcHJvZF9uZyIsInJlZ2lvbiI6InVzLXNvdXRoIiwiaWF0IjoxNTEyMzk1NTE3LCJleHAiOjE1MjAxNzE1MTd9.hX5eXCdBM18VjWPIdtHwDaNQvUmJ48Q70Q-lXa5bs5o

docker run -it ibmcom/secure-gateway-client --net="host" p9MTlTSy1vN_prod_ng -t eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb25maWd1cmF0aW9uX2lkIjoicDlNVGxUU3kxdk5fcHJvZF9uZyIsInJlZ2lvbiI6InVzLXNvdXRoIiwiaWF0IjoxNTEyMzk2OTE1LCJleHAiOjE1MjAxNzI5MTV9.niKk7iJYnUZfSavVZerY0qzhVQm89HJPK2zl9RVmc-s