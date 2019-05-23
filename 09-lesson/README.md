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
cd ConfigMaps
# Deploy the ConfigMap
kubectl create -f configmap.yaml

# Create the Pod with Env Var
kubectl create -f pod-cmd.yaml

# check the logs
kubectl logs test-pod-cmd

# Create the Pod with  Env Var
kubectl create -f pod-env.yaml

# Check the env vars
kubectl exec -it test-pod-env /bin/sh

# Create the Pod with Env Var
kubectl create -f pod-vol.yaml

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
1:C 21 May 2019 05:50:53.730 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
1:C 21 May 2019 05:50:53.730 # Redis version=5.0.5, bits=64, commit=00000000, modified=0, pid=1, just started
1:C 21 May 2019 05:50:53.730 # Configuration loaded
1:M 21 May 2019 05:50:53.765 * Running mode=standalone, port=6379.
1:M 21 May 2019 05:50:53.765 # WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.
1:M 21 May 2019 05:50:53.765 # Server initialized
1:M 21 May 2019 05:50:53.765 * Ready to accept connections
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
$ kubectl delete configmap example-redis-config log-config
configmap "example-redis-config" deleted
configmap "log-config" deleted
$ kubectl delete pod redis test-pod-cmd test-pod-env test-pod-vol
pod "redis" deleted
pod "test-pod-cmd" deleted
pod "test-pod-env" deleted
pod "test-pod-vol" deleted
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
$ kubectl get secret dbsecret -o yaml

# Decode the secret
$ echo UzBtZVBAc3N3MHJE | base64 -D

# Create the Pod
$ kubectl create -f secret-pod.yaml

# Access the Secret in the Pod
$ kubectl exec -it secret-pod /bin/sh

# Clean up
$ kubectl delete secret dbsecret
$ kubectl delete -f secret-pod.yaml
```

Create a generic secret from files

```console
$ cd Secrets/Demo1
$ kubectl create secret generic dbsecret --from-file=./username.txt --from-file=./password.txt
secret "dbsecret" created
$ kubectl get secret
NAME                  TYPE                                  DATA      AGE
dbsecret              Opaque                                2         54s
default-token-zk79b   kubernetes.io/service-account-token   3         10d
$ kubectl get secret dbsecret -o yaml
apiVersion: v1
data:
  password.txt: UzBtZVBAc3N3MHJE
  username.txt: YWRtaW4=
kind: Secret
metadata:
  creationTimestamp: 2019-05-21T06:10:36Z
  name: dbsecret
  namespace: default
  resourceVersion: "109510"
  selfLink: /api/v1/namespaces/default/secrets/dbsecret
  uid: 267a97c3-7b8f-11e9-b797-080027466657
type: Opaque
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
$ cd Secrets/Demo2
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

Clean up

```console
kubectl delete -f secret-env-pod.yaml -f my-secret.yaml
```

## Key Things to Remember

- Secrets feature is not entirely foolproof
- API Server stores Secrets in plain text
- During replication accross etcd clusters, Secrets are sent in plain text
- Secret definitions may still get exposed to outside world

Reference:
- [Kubernetes Webinar Series - Using ConfigMaps and Secrets](https://www.youtube.com/watch?v=GoITFljdJdo&index=9&list=PLF3s2WICJlqOiymMaTLjwwHz-MSVbtJPQ)
