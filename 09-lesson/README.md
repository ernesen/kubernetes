# Using ConfigMaps & Secrets in Kubernetes

## Ojectives
- What are ConfigMaps
- When to use ConfigMaps
- Use cases for ConfigMaps
- Overview of Secrets
- Using Secrets
- Key Takeaways
---

## Configuring Containerized Applications
- Applications expect configuration from
	- Configuration files
	- Command line arguments
	- Environment variables
- Configuration is always decoupled from applications
	- INI
	- XML
	- JSON
	- Custom Format
- Container Images shouldn't hold application configuration
	- Essential for keeping containerized applications portable
## What are ConfigMaps?
- Kubernetes objects for injecting containers with configuration data
- ConfigMaps keep containers agnostic of Kubernetes
- They can be used to store fine-grained or coarse-grained configuration
	- Individual properties
	- Entire configuration file
	- JSON files
- ConfigMaps hold configuration in Key-Value pairs accessible to Pods
- Similar to /etc directory and files in Linux OS
## Accessing ConfigMaps from Pods
- Configuration data can be consumed in pods in a variety of ways
- ConfigMap can be used to:
	**1. Populate the value of environment variables**
	**2. Set command-line arguments in a container**
	**3. Populate configuration files in a volume**
- Users and system components may store configuration data in a ConfigMap
## Demo
### Using ConfigMaps
Working from these set of comands:
```bash
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
```
Creating a ConfigMap from console
```console
$ kubectl create -f configmap.yaml
configmap "log-config" created
$ kubectl get configmap
NAME         DATA      AGE
log-config   2         3m
$ kubectl describe configmap log-config
Name:         log-config
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
log.level:
----
INFO
log.location:
----
LOCAL
Events:  <none>
```
Creating the Pod for the command line.
```console
$ kubectl create -f pod-cmd.yaml --validate=false
pod "test-pod-cmd" created
$ kubectl get pod -a
NAME           READY     STATUS      RESTARTS   AGE
test-pod-cmd   0/1       Completed   0          1m
```
Creating the Pod with environment variables.
```console
$ kubectl exec -it test-pod-env /bin/sh
/ # env
KUBERNETES_SERVICE_PORT=443
KUBERNETES_PORT=tcp://10.96.0.1:443
LOG_LEVEL=INFO
HOSTNAME=test-pod-env
SHLVL=1
HOME=/root
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
LOG_LOCATION=LOCAL
PWD=/
KUBERNETES_SERVICE_HOST=10.96.0.1
/ # exit
```
Creating Pods with volume files
```console
$ kubectl create -f pod-vol.yaml
pod "test-pod-vol" created
$ kubectl get pod test-pod-vol
NAME           READY     STATUS    RESTARTS   AGE
test-pod-vol   1/1       Running   0          51s
```
Access the log files log.level and log.location
```console
$ kubectl exec -it test-pod-vol /bin/sh
/etc/config # ls
log.level     log.location
/etc/config # cat log.level
INFO/etc/config # cat log.location
LOCAL/etc/config # exit
$ kubectl get po
NAME           READY     STATUS    RESTARTS   AGE
test-pod-env   1/1       Running   0          22m
test-pod-vol   1/1       Running   0          8m
```
Second demo with Redis file...
```console
$ kubectl create configmap example-redis-config --from-file=redis-config
configmap "example-redis-config" created
λ kubectl get configmap example-redis-config -o yaml
apiVersion: v1
data:
  redis-config: "maxmemory 5mb\r\nmaxmemory-policy allkeys-lru\r\n"
kind: ConfigMap
metadata:
  creationTimestamp: 2017-12-13T09:16:08Z
  name: example-redis-config
  namespace: default
  resourceVersion: "363254"
  selfLink: /api/v1/namespaces/default/configmaps/example-redis-config
  uid: 414ede6c-dfe6-11e7-bb6c-08002720cfab
$ kubectl create -f redis.yaml
pod "redis" created  
$ kubectl logs redis
                _._
           _.-``__ ''-._
      _.-``    `.  `_.  ''-._           Redis 2.8.19 (00000000/0) 64 bit
  .-`` .-```.  ```\/    _.,_ ''-._
 (    '      ,       .-`  | `,    )     Running in stand alone mode
 |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6379
 |    `-._   `._    /     _.-'    |     PID: 7
  `-._    `-._  `-./  _.-'    _.-'
 |`-._`-._    `-.__.-'    _.-'_.-'|
 |    `-._`-._        _.-'_.-'    |           http://redis.io
  `-._    `-._`-.__.-'_.-'    _.-'
 |`-._`-._    `-.__.-'    _.-'_.-'|
 |    `-._`-._        _.-'_.-'    |
  `-._    `-._`-.__.-'_.-'    _.-'
      `-._    `-.__.-'    _.-'
          `-._        _.-'
              `-.__.-'

[7] 13 Dec 09:19:53.815 # Server started, Redis version 2.8.19
[7] 13 Dec 09:19:53.815 # WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.
[7] 13 Dec 09:19:53.815 * The server is now ready to accept connections on port 6379
$ kubectl exec -it redis redis-cli
127.0.0.1:6379> CONFIG GET maxmemory
1) "maxmemory"
2) "5242880"
127.0.0.1:6379> CONFIG GET maxmemory-policy
1) "maxmemory-policy"
2) "allkeys-lru"
127.0.0.1:6379> exit
```
Time to do some clean up so that we can move to the section of the demo...
```console
$ kubectl delete configmap example-redis-config
configmap "example-redis-config" deleted
$ kubectl delete pod redis
pod "redis" deleted
```
## Using Secrets
- Secret is an object that contains a small amount of sensitive data such as a password, a token, or a key
- Secrets reduce the risk of exposing sensitive data to unwanted entities
- Like ConfigMaps, Secrets are Kubernetes API objects created outside of Pods
- Secrets belong to a specific Kubernetes Namespace
- The size of each Secret cannot exceed 1MB
- Secrets are registered with Kubernetes Master
- Secrets can be mounted as Volumes or exposed as environment variables
- Secret is only sent to the Node hosting the Pod that requires access
- Each Secret is stored in a tempfs volumes that restrict access to the rest of the applications in the Node
- Communication between the Kubernetes API Server and Node is secured through SSL/TLS
## Demo
### Using Secrets
```bash
# Create a generic secret from files
$ kubectl create secret generic dbsecret --from-file=./username.txt --from-file=./password.txt

# Check the creation of Secret
$ kubectl get secret

# Check the creation of Secret in YAML
$ kubectl get secret -o yaml 

# Decode the secret
$ echo UzBtZVBAc3N3MHJE | base64 -D 

# Create the Pod
$ kubectl create -f secret-pod.yaml

# Access the Secret in the Pod
$ kubectl exec -it secret-pod /bin/sh
$ cd /etc/foo

# Clean up 
$ kubectl delete secret dbsecret
$ kubectl delete -f secret-pod.yaml
```
Create a generic secret from files
```console
$ kubectl create secret generic dbsecret --from-file=./username.txt --from-file=./password.txt
secret "dbsecret" created
$ kubectl get secret
NAME                  TYPE                                  DATA      AGE
dbsecret              Opaque                                2         54s
default-token-zk79b   kubernetes.io/service-account-token   3         10d
$ kubectl get secret -o yaml
apiVersion: v1
items:
- apiVersion: v1
  data:
    password.txt: UzBtZVBAc3N3MHJE
    username.txt: YWRtaW4=
  kind: Secret
  metadata:
    creationTimestamp: 2017-12-13T09:50:23Z
    name: dbsecret
    namespace: default
    resourceVersion: "365541"
    selfLink: /api/v1/namespaces/default/secrets/dbsecret
    uid: 09f10d08-dfeb-11e7-bb6c-08002720cfab
  type: Opaque
- apiVersion: v1
  data:
    ca.crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM1ekNDQWMrZ0F3SUJBZ0lCQVRBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwdGFXNXAKYTNWaVpVTkJNQjRYRFRFM01USXdNakUwTVRNeE5Gb1hEVEkzTVRFek1ERTBNVE14TkZvd0ZURVRNQkVHQTFVRQpBeE1LYldsdWFXdDFZbVZEUVRDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBS1VxCjhsWVdIN1p3dDhyZ1pPNHQweTRZUmdHOUhtL3BNMXUrREx1UkZ2TE1GSVFUVWtXbzkyZnFjTXl1QjF0Z0U1Sk4KYzlNemo4MjRzRVkxTWE4QzRxMytxMHFrVTVsb20yZXJoY2lhWHIxTE5HbTRVcWtPcXE3WlhINytaY2NYemVONApJcUFzYmJSaVZKM0sxbWpUNmdya2xiV09qTDlveWtJZGowZW04b1hGekxxcW51UkI5aERsbjFNcEVHdk9SbXN6CnFXWmk1eDdzZHBYaEJHYUNEZTRLS0hzQTQ1ejUrVGszQnFneXdIVjJoVzV5ZHRiTHBaa0NxQ1N4S3NLRktjcHkKbVFVT0RRUEUzTmwwVnUxZWM0WEQ2aDZSR0xaY3lxaGdqc3lsZG5GdWJMaEU4aEF3SGFuNFNiZ1VLckc5QVAyUQpqRkEvUjZEOXhHVW1RSHJvQ3FVQ0F3RUFBYU5DTUVBd0RnWURWUjBQQVFIL0JBUURBZ0trTUIwR0ExVWRKUVFXCk1CUUdDQ3NHQVFVRkJ3TUNCZ2dyQmdFRkJRY0RBVEFQQmdOVkhSTUJBZjhFQlRBREFRSC9NQTBHQ1NxR1NJYjMKRFFFQkN3VUFBNElCQVFBOFllbi9MdEN6ZUw1ckthdFNBWnpISkNMczNCUUtOb0NlKzBwK040akIzeWhWeVJGYgpMR0NabUdDaTNldTBTRGt0dllnRnlIc0E2cVVtcndyWUxtVlJIMmpaSmJhS1RMVmw3Mkl1Z3F3eXJybmhBc3ZlClc4OEswejBCVU1QRHlFYzV1S0kyNHJ3ckVlU0pMMjBzRGM3MVltcWg1OUJkZ0x5ajUrakcrUzI3TXNWRFluZEsKdHpIS2pPZS95ZTgvUWZBck5LSGlBenozaVFSNjh6b3JPc3R4dzhHS0VzaWltbHUrM3JzdG9KTnFCYU5HUVhaVApZQ1Q5WHcyQXRFUlhRWnFMTkl3a1gvODdaemdpY0VYK3JITEhpSTlCbi9wYmgrb2szRkhLNGhmSXhqeDVLMnZaCnZRMHB2RTNQWWZFV0ZqY1d4T1ZmNDhld0FJSHQvUExDb2R5OAotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
    namespace: ZGVmYXVsdA==
    token: ZXlKaGJHY2lPaUpTVXpJMU5pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SnBjM01pT2lKcmRXSmxjbTVsZEdWekwzTmxjblpwWTJWaFkyTnZkVzUwSWl3aWEzVmlaWEp1WlhSbGN5NXBieTl6WlhKMmFXTmxZV05qYjNWdWRDOXVZVzFsYzNCaFkyVWlPaUprWldaaGRXeDBJaXdpYTNWaVpYSnVaWFJsY3k1cGJ5OXpaWEoyYVdObFlXTmpiM1Z1ZEM5elpXTnlaWFF1Ym1GdFpTSTZJbVJsWm1GMWJIUXRkRzlyWlc0dGVtczNPV0lpTENKcmRXSmxjbTVsZEdWekxtbHZMM05sY25acFkyVmhZMk52ZFc1MEwzTmxjblpwWTJVdFlXTmpiM1Z1ZEM1dVlXMWxJam9pWkdWbVlYVnNkQ0lzSW10MVltVnlibVYwWlhNdWFXOHZjMlZ5ZG1salpXRmpZMjkxYm5RdmMyVnlkbWxqWlMxaFkyTnZkVzUwTG5WcFpDSTZJbVk0T0dWa04yRTRMV1EzTm1FdE1URmxOeTFpWkRrNUxUQTRNREF5TnpJd1kyWmhZaUlzSW5OMVlpSTZJbk41YzNSbGJUcHpaWEoyYVdObFlXTmpiM1Z1ZERwa1pXWmhkV3gwT21SbFptRjFiSFFpZlEuY2o2b1BkeGhZRERfam9NT1F3WnF0aW1JRHgxYmRSa0YzTk5DUktZOTBWeGZONFpaSEFrcVFZNms1Tk5FUWd4ZzFDcFFRcVV6aTFsQk1RVkhFRm0zT0pyRGd2Z3Bhc1lqZl9EemZqUS1FNDhJTFhFY3pBdmY2eFlyb3VPbE1NckxQWDdjUTJ2cjRoSlUyU3gzcjAyMlZUSHlUdlFwdXFBem1UaXVIZ0l2UDVlSmpuNEcwSDRKN1NXNzNNc0hWRVZzT2JFSXpyeDdGU1R5b19hTkxhZHFiWEg1SHZKQ3UxQmc5MDF3Znd3RHU2cDJrVlpCSUNPdzZtNlhHajlPRTB2OFNXNEpjei1zOVc1SEZ5dUVaZEVBMnNlMVZvV0hNaUx5SzZjbWFQREJiMnp3VTI2QXl4cUpTYzRWTDN0MWhzb0tYVm1RS0pHSmk5WDgtTG9IZlQzbnJ3
  kind: Secret
  metadata:
    annotations:
      kubernetes.io/service-account.name: default
      kubernetes.io/service-account.uid: f88ed7a8-d76a-11e7-bd99-08002720cfab
    creationTimestamp: 2017-12-02T14:13:29Z
    name: default-token-zk79b
    namespace: default
    resourceVersion: "39"
    selfLink: /api/v1/namespaces/default/secrets/default-token-zk79b
    uid: f88fe3cb-d76a-11e7-bd99-08002720cfab
  type: kubernetes.io/service-account-token
- apiVersion: v1
  data:
    password: UzBtZVBAc3N3MHJE
    username: YWRtaW4=
  kind: Secret
  metadata:
    creationTimestamp: 2017-12-06T05:00:56Z
    name: mysecret
    namespace: default
    resourceVersion: "122577"
    selfLink: /api/v1/namespaces/default/secrets/mysecret
    uid: 718c98c9-da42-11e7-afa1-08002720cfab
  type: Opaque
kind: List
metadata:
  resourceVersion: ""
  selfLink: ""
```
Let's look on how Kubernetes encode the login and password, taking the data from `kubectl get secret -o yaml`
data:
  password.txt: UzBtZVBAc3N3MHJE
  username.txt: YWRtaW4=

Like you may see these are the exact values shown from file password.txt and username.txt
```console
$ echo UzBtZVBAc3N3MHJE | base64 -D 
S0meP@ssw0rD
$ echo YWRtaW4= | base64 -D 
admin
```
Next step is to test the creation of the pod with its secret file...
```console
$ kubectl create -f secret-pod.yaml
pod "secret-pod" created
$ kubectl get po secret-pod
NAME         READY     STATUS    RESTARTS   AGE
secret-pod   1/1       Running   0          54s
$ kubectl exec -it secret-pod /bin/sh
# cd /etc/foo
# ls
password.txt  username.txt
# cat password.txt
S0meP@ssw0rD#
# cat username.txt
admin# exit
```
Let's clean up secret and pod.
```console
$ kubectl delete secret dbsecret
secret "dbsecret" deleted
$ kubectl delete -f secret-pod.yaml
pod "secret-pod" deleted
```
Demo II
```console
$ kubectl create -f my-secret.yaml
secret "mysecret" created
$ kubectl create -f secret-env-pod.yaml
pod "secret-env-pod" created
$ kubectl exec -it secret-env-pod /bin/sh
# env
KUBERNETES_SERVICE_PORT=443
KUBERNETES_PORT=tcp://10.96.0.1:443
HOSTNAME=secret-env-pod
REDIS_DOWNLOAD_SHA=769b5d69ec237c3e0481a262ff5306ce30db9b5c8ceb14d1023491ca7be5f6fa
HOME=/root
SECRET_PASSWORD=S0meP@ssw0rD
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_PROTO=tcp
SECRET_USERNAME=admin
REDIS_DOWNLOAD_URL=http://download.redis.io/releases/redis-4.0.6.tar.gz
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
REDIS_VERSION=4.0.6
GOSU_VERSION=1.10
KUBERNETES_SERVICE_HOST=10.96.0.1
PWD=/data
# exit
```
## Key Things to Remember
- Secrets feature is not entirely foolproof
- API Server stores Secrets in plain text
- During replication accross etcd clusters, Secrets are sent in plain text
- Secret definitions may still get exposed to outside world

Reference:
- [Kubernetes Webinar Series - Using ConfigMaps and Secrets](https://www.youtube.com/watch?v=GoITFljdJdo&index=9&list=PLF3s2WICJlqOiymMaTLjwwHz-MSVbtJPQ)
