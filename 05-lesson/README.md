# Scaling and Managing Deployments

## Objectives
- Overview of RelicaSets
- What are Deployments
- Why use Deployments
- Use Cases
- Demo
---
## Overview of Relica Sets
- Replica Sets are the next generation of Replication Controllers
- Replica Sets support set-based selectors
- Replication Controlleronly supports equality-based selectors
- Deployments in Kubernetes use Relica Sets
- Example of set-based selectors in Replica Set
```yaml
	selector:
	  matchLabels:
		coponent: redis
	  matchExpressions:
		- {key: tier, operator: In, values: [cache]}
		- {key: environment, operator: NotIn, values: [dev]}
```
## What are Deployments?
- Deployment provides declarative updates for Pods and Replica Sets
- Deployment defines the state of the application
  - Kubernetes ensures that the cluster maintains the desired state of application 
- Replication Controllers and Replica Sets fall short of key requirements to manage application deployments
- Deployment object is flexible for managing and scaling applications in Kubernetes
## Why use Deployment?
- Create a deployments
  - Deploy an application
- Update a deployment 
  - Deploy a new version of application
- Perform rolling updates
  - Zero downtime during upgrades
- Perform rollback
  - Undo the last deployment
- Pause/resume a Deployment
  - Selective upgrades
## Use Cases of Deployment
- Create a Deployment to bring up a Replica Set and Pods
- Check the status of a Deployment to see if it succeeds or not
- Later, update that Deployment to recreate the Pods
- Rollback to an earlier Deployment revision if the current Deployment isn't stable
- Pause and resume a Deployment
## Deployment Definition
```yaml
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: nginx-deployment 
spec:
  replicas: 3
  template:
    metadata:
	  labels:
	    app: nginx 
	spec:
	  containers:
	  - name: nginx
	    image: nginx:1.7.9
		ports:
		- containerPort: 80
```
```console
$ kubectl create -f nginx-deployment.yaml
deployment "nginx-deployment" created

$ kubectl get deployments
NAME				DESIRED		CURRENT		UP-TO-DATE		AVAILABLE		AGE
nginx-deployment	3			0			0				0				1S

$ kubectl set image deployment/nginx-deployment nginx=nginx:1.9.1
deployment "nginx-deployment" image updated

$ kubectl rollout status deployment/nginx-deployment
Waiting for rollout to finish: 2 out of 3 new replicas have been updated...
deployment "nginx-deployment" successfully rolled out
```

Clean up

```console
kubectl delete -f nginx-deployment.yaml
```

## Demo
### Using Deployments
```bash
# Create the deployment
$ kubectl create -f j-hello.yaml -f j-hello-svc.yaml

# List the deployment
$ kubectl get deployments

# Describe the deployment
$ kubectl describe deployments

# List the pods
$ kubectl get pods

# List the pods with labels
$ kubectl get pods --show-labels

# List the Replica Sets
$ kubectl get rs --show-labels

# Access the pod
$ export NODE_PORT=30001  
$ curl 192.168.99.100:$NODE_PORT

# Scale the deployment 
$ kubectl scale deployment j-hello --replicas 10

# Check the status of deployment
$ kubectl rollout status deploy/j-hello

# Pause the deployment
$ kubectl rollout pause deploy/j-hello

# Check the current version of deployment
$ while true; do curl 192.168.99.100:$NODE_PORT; printf '%s\r\n'; sleep 1; done

# Check the current version of deployment and resume from the pause
$ kubectl rollout resume deployment/j-hello

# Upgrade to version 2
$ kubectl set image deployment j-hello j-hello=janakiramm/j-hello:2

$ watch kubectl get pods

# Check the history
$ kubectl rollout history deployment j-hello

# Undo the previous upgrade
$ kubectl rollout undo deploy/j-hello

# Clean up
$ kubectl delete deployment j-hello
$ kubectl delete service j-hello
```

```console
$ kubectl create -f j-hello.yaml
deployment "j-hello" created
$ kubectl create -f j-hello-svc.yaml
service "j-hello" created
$ kubectl get deployments
NAME      DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
j-hello   3         3         3            3           12m
$ kubectl get po
NAME                      READY     STATUS        RESTARTS   AGE
j-hello-f8f7c9646-7ln7k   1/1       Running       0          13m
j-hello-f8f7c9646-dz7qr   1/1       Running       0          13m
j-hello-f8f7c9646-sgcqd   1/1       Running       0          13m
$ kubectl describe deployments
Name:                   j-hello
Namespace:              default
CreationTimestamp:      Tue, 12 Dec 2017 08:32:14 +0800
Labels:                 app=helloworld
Annotations:            deployment.kubernetes.io/revision=1
Selector:               app=helloworld
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  1 max unavailable, 1 max surge
Pod Template:
  Labels:  app=helloworld
  Containers:
   j-hello:
    Image:        janakiramm/j-hello
    Port:         3000/TCP
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
OldReplicaSets:  <none>
NewReplicaSet:   j-hello-f8f7c9646 (3/3 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  16m   deployment-controller  Scaled up replica set j-hello-f8f7c9646 to 3
$ kubectl get pods --show-labels
NAME                      READY     STATUS    RESTARTS   AGE       LABELS
j-hello-f8f7c9646-7ln7k   1/1       Running   0          17m       app=helloworld,pod-template-hash=949375202
j-hello-f8f7c9646-dz7qr   1/1       Running   0          17m       app=helloworld,pod-template-hash=949375202
j-hello-f8f7c9646-sgcqd   1/1       Running   0          17m       app=helloworld,pod-template-hash=949375202
$ kubectl get rs --show-labels
NAME                DESIRED   CURRENT   READY     AGE       LABELS
j-hello-f8f7c9646   3         3         3         19m       app=helloworld,pod-template-hash=949375202
$ curl 192.168.99.100:30001
Hello World!
$ kubectl scale deployment j-hello --replicas 10
deployment "j-hello" scaled
$ kubectl rollout status deploy/j-hello
deployment "j-hello" successfully rolled out
$ kubectl rollout pause deploy/j-hello
deployment "j-hello" paused
$ kubectl set image deployment j-hello j-hello=janakiramm/j-hello:2
deployment.extensions/j-hello image updated
$ kubectl rollout status deploy/j-hello
Waiting for rollout to finish: 0 out of 10 new replicas have been updated...
$ kubectl rollout resume deployment/j-hello
deployment "j-hello" resumed
$ kubectl rollout status deploy/j-hello
Waiting for rollout to finish: 2 out of 10 new replicas have been updated...
Waiting for rollout to finish: 2 out of 10 new replicas have been updated...
Waiting for rollout to finish: 2 out of 10 new replicas have been updated...
Waiting for rollout to finish: 2 out of 10 new replicas have been updated...
Waiting for rollout to finish: 3 out of 10 new replicas have been updated...
Waiting for rollout to finish: 3 out of 10 new replicas have been updated...
Waiting for rollout to finish: 3 out of 10 new replicas have been updated...
Waiting for rollout to finish: 4 out of 10 new replicas have been updated...
Waiting for rollout to finish: 4 out of 10 new replicas have been updated...
Waiting for rollout to finish: 4 out of 10 new replicas have been updated...
Waiting for rollout to finish: 4 out of 10 new replicas have been updated...
Waiting for rollout to finish: 4 out of 10 new replicas have been updated...
Waiting for rollout to finish: 5 out of 10 new replicas have been updated...
Waiting for rollout to finish: 5 out of 10 new replicas have been updated...
Waiting for rollout to finish: 5 out of 10 new replicas have been updated...
Waiting for rollout to finish: 6 out of 10 new replicas have been updated...
Waiting for rollout to finish: 6 out of 10 new replicas have been updated...
Waiting for rollout to finish: 6 out of 10 new replicas have been updated...
Waiting for rollout to finish: 6 out of 10 new replicas have been updated...
Waiting for rollout to finish: 7 out of 10 new replicas have been updated...
Waiting for rollout to finish: 7 out of 10 new replicas have been updated...
Waiting for rollout to finish: 7 out of 10 new replicas have been updated...
Waiting for rollout to finish: 7 out of 10 new replicas have been updated...
Waiting for rollout to finish: 8 out of 10 new replicas have been updated...
Waiting for rollout to finish: 8 out of 10 new replicas have been updated...
Waiting for rollout to finish: 8 out of 10 new replicas have been updated...
Waiting for rollout to finish: 8 out of 10 new replicas have been updated...
Waiting for rollout to finish: 8 out of 10 new replicas have been updated...
Waiting for rollout to finish: 9 out of 10 new replicas have been updated...
Waiting for rollout to finish: 9 out of 10 new replicas have been updated...
Waiting for rollout to finish: 9 out of 10 new replicas have been updated...
Waiting for rollout to finish: 9 out of 10 new replicas have been updated...
Waiting for rollout to finish: 1 old replicas are pending termination...
Waiting for rollout to finish: 1 old replicas are pending termination...
Waiting for rollout to finish: 1 old replicas are pending termination...
Waiting for rollout to finish: 9 of 10 updated replicas are available...
deployment "j-hello" successfully rolled out
```

In another console, run a script so that we can test the load, some will show v1 while other on v2; a nice way to perform updrades.

```console
$ while true; do curl 192.168.99.100:30001; printf '%s\r\n'; sleep 1; done
Hello World!
Hello World v2!
Hello World!
Hello World!
Hello World v2!
Hello World!
Hello World v2!
Hello World!
Hello World!
Hello World!
Hello World v2!
Hello World!
Hello World v2!
Hello World v2!
Hello World v2!
Hello World!
Hello World v2!
```

Take a scenario where we might not be happy with the latest release and would like to rollback, the steps below will do just that.

```console
$ kubectl rollout history deployment j-hello
deployments "j-hello"
REVISION  CHANGE-CAUSE
1         <none>
2         <none>
```

We are going back to the previous deployment, as shown above we have two revisions.

```console
$ kubectl rollout undo deploy/j-hello
deployment "j-hello" rolled back
$ watch kubectl get pods
NAME                      READY     STATUS    RESTARTS   AGE
j-hello-cfcd7f654-2hn85   1/1       Running   0          24m
j-hello-cfcd7f654-2jw2h   1/1       Running   0          25m
j-hello-cfcd7f654-6rjm4   1/1       Running   0          25m
j-hello-cfcd7f654-h7bmz   1/1       Running   0          24m
j-hello-cfcd7f654-kbsk5   1/1       Running   0          24m
j-hello-cfcd7f654-l6k85   1/1       Running   0          24m
j-hello-cfcd7f654-qgv4q   1/1       Running   0          25m
j-hello-cfcd7f654-t87sl   1/1       Running   0          24m
j-hello-cfcd7f654-txgjr   1/1       Running   0          25m
j-hello-cfcd7f654-v92xd   1/1       Running   0          25m
j-hello-cfcd7f654-2hn85   1/1       Terminating   0         24m
j-hello-f8f7c9646-tg96t   0/1       Pending   0         0s
j-hello-f8f7c9646-tg96t   0/1       Pending   0         0s
j-hello-f8f7c9646-78pgt   0/1       Pending   0         0s
j-hello-f8f7c9646-78pgt   0/1       Pending   0         0s
j-hello-f8f7c9646-tg96t   0/1       ContainerCreating   0         0s
j-hello-f8f7c9646-78pgt   0/1       ContainerCreating   0         0s
j-hello-f8f7c9646-78pgt   1/1       Running   0         5s
j-hello-cfcd7f654-l6k85   1/1       Terminating   0         25m
j-hello-f8f7c9646-p787p   0/1       Pending   0         0s
j-hello-f8f7c9646-p787p   0/1       Pending   0         0s
j-hello-f8f7c9646-p787p   0/1       ContainerCreating   0         0s
j-hello-f8f7c9646-tg96t   1/1       Running   0         10s
j-hello-cfcd7f654-h7bmz   1/1       Terminating   0         25m
j-hello-f8f7c9646-zvdhm   0/1       Pending   0         0s
j-hello-f8f7c9646-zvdhm   0/1       Pending   0         0s
j-hello-f8f7c9646-zvdhm   0/1       ContainerCreating   0         0s
j-hello-f8f7c9646-p787p   1/1       Running   0         7s
j-hello-cfcd7f654-t87sl   1/1       Terminating   0         25m
j-hello-f8f7c9646-js6hf   0/1       Pending   0         0s
j-hello-f8f7c9646-js6hf   0/1       Pending   0         0s
j-hello-f8f7c9646-js6hf   0/1       ContainerCreating   0         0s
j-hello-f8f7c9646-zvdhm   1/1       Running   0         6s
j-hello-cfcd7f654-kbsk5   1/1       Terminating   0         25m
j-hello-f8f7c9646-s825n   0/1       Pending   0         0s
j-hello-f8f7c9646-s825n   0/1       Pending   0         0s
j-hello-f8f7c9646-s825n   0/1       ContainerCreating   0         0s
j-hello-f8f7c9646-js6hf   1/1       Running   0         6s
j-hello-cfcd7f654-v92xd   1/1       Terminating   0         26m
j-hello-f8f7c9646-pdnrv   0/1       Pending   0         0s
j-hello-f8f7c9646-pdnrv   0/1       Pending   0         0s
j-hello-f8f7c9646-pdnrv   0/1       ContainerCreating   0         0s
j-hello-f8f7c9646-s825n   1/1       Running   0         7s
j-hello-cfcd7f654-txgjr   1/1       Terminating   0         26m
j-hello-f8f7c9646-hhthl   0/1       Pending   0         0s
j-hello-f8f7c9646-hhthl   0/1       Pending   0         0s
j-hello-f8f7c9646-hhthl   0/1       ContainerCreating   0         0s
j-hello-cfcd7f654-2hn85   0/1       Terminating   0         25m
j-hello-cfcd7f654-2hn85   0/1       Terminating   0         25m
j-hello-f8f7c9646-pdnrv   1/1       Running   0         7s
j-hello-cfcd7f654-qgv4q   1/1       Terminating   0         26m
j-hello-f8f7c9646-ld8xt   0/1       Pending   0         0s
j-hello-f8f7c9646-ld8xt   0/1       Pending   0         0s
j-hello-f8f7c9646-ld8xt   0/1       ContainerCreating   0         0s
j-hello-cfcd7f654-l6k85   0/1       Terminating   0         25m
j-hello-f8f7c9646-hhthl   1/1       Running   0         7s
j-hello-cfcd7f654-2jw2h   1/1       Terminating   0         26m
j-hello-f8f7c9646-k4xk4   0/1       Pending   0         0s
j-hello-f8f7c9646-k4xk4   0/1       Pending   0         0s
j-hello-f8f7c9646-k4xk4   0/1       ContainerCreating   0         0s
j-hello-cfcd7f654-2hn85   0/1       Terminating   0         25m
j-hello-cfcd7f654-2hn85   0/1       Terminating   0         25m
j-hello-f8f7c9646-ld8xt   1/1       Running   0         8s
j-hello-cfcd7f654-6rjm4   1/1       Terminating   0         26m
j-hello-cfcd7f654-h7bmz   0/1       Terminating   0         26m
j-hello-f8f7c9646-k4xk4   1/1       Running   0         6s
j-hello-cfcd7f654-t87sl   0/1       Terminating   0         26m
j-hello-cfcd7f654-t87sl   0/1       Terminating   0         26m
j-hello-cfcd7f654-kbsk5   0/1       Terminating   0         26m
j-hello-cfcd7f654-v92xd   0/1       Terminating   0         26m
j-hello-cfcd7f654-txgjr   0/1       Terminating   0         26m
j-hello-cfcd7f654-qgv4q   0/1       Terminating   0         26m
j-hello-cfcd7f654-2jw2h   0/1       Terminating   0         27m
j-hello-cfcd7f654-6rjm4   0/1       Terminating   0         27m
```

From a separate terminal, we would run this command to monitor the rollback progress, where eventually all will be rolled back to v1.

```console
$ while true; do curl 192.168.99.100:$NODE_PORT; printf '%s\r\n'; sleep 1; done
Hello World v2!
Hello World v2!
Hello World v2!
Hello World v2!
Hello World v2!
Hello World v2!
Hello World v2!
Hello World v2!
Hello World v2!
Hello World v2!
Hello World v2!
Hello World v2!
Hello World!
Hello World v2!
Hello World!
Hello World!
Hello World!
Hello World v2!
Hello World v2!
Hello World v2!
Hello World!
Hello World v2!
Hello World v2!
Hello World!
Hello World!
Hello World v2!
Hello World!
Hello World v2!
Hello World v2!
Hello World!
Hello World!
Hello World!
Hello World v2!
Hello World!
Hello World v2!
Hello World v2!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
```

Time to clean up and run the delete commands for deployments and services.

```console
$ kubectl delete deployment j-hello
deployment "j-hello" deleted
$ kubectl delete service j-hello
service "j-hello" deleted
```

Let's verify that all the services and deployments are deleted and get ready for the next set of demos.

```console
$ kubectl get po
No resources found.
$ kubectl get svc -n default
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)     AGE
kubernetes   ClusterIP   10.96.0.1      <none>        443/TCP     9d
```

## Demo
### Canary deployment
Canary deployment is a pattern for reducing risk involved with releasing new software versions. But in software, releasing canaries can be a strategic tactic for teams adopting continuous delivery practices.

The idea is that you’ll rollout a new release incrementally to a small subset of servers side by side with its Stable version. Once you test the waters, you can then rollout the changes to the rest of the infrastructure.

This effectively exposes new versions to a small set of users, which acts as an early indicator for failures that might happen. Canaries are very handy for avoiding problematic deployments and angry users! If one canary deployment fails, the rest of your servers aren’t affected and you can simply ditch it and fix the root cause.

### source file for demo..
```bash
# Create the deployment
$ kubectl create -f j-hello.yaml -f j-hello-svc.yaml --validate=false

# List the deployment
$ kubectl get deployments --watch

# Access the pod
$ curl 192.168.99.100:30001

# Scale the deployment 
$ kubectl scale deployment j-hello --replicas 10

# Check the status of deployment
$ kubectl rollout status deploy/j-hello

# Upgrade to version 2
$ kubectl set image deployment j-hello j-hello=janakiramm/j-hello:2

# Pause the deployment
$ kubectl rollout pause deploy/j-hello

# Check the current version of deployment
$ while true; do curl 192.168.99.100:$NODE_PORT; printf '%s\r\n'; sleep 1; done

# Check the current version of deployment and resume from the pause
$ kubectl rollout resume deployment/j-hello

# Clean up
$ kubectl delete deployment j-hello
$ kubectl delete service j-hello
```

Let's get started with the demo
```console
$ kubectl create -f j-hello.yaml -f j-hello-svc.yaml --validate=false
deployment "j-hello" created
service "j-hello" created
$ kubectl get po
NAME                      READY     STATUS    RESTARTS   AGE
j-hello-f8f7c9646-7jlnb   1/1       Running   0          1m
j-hello-f8f7c9646-nf2sm   1/1       Running   0          1m
j-hello-f8f7c9646-qdz2l   1/1       Running   0          1m
$ curl 192.168.99.100:30001
Hello World!
$ kubectl scale deployment j-hello --replicas 10
deployment "j-hello" scaled
$ kubectl get deployments -w
NAME      DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
j-hello   3         3         3            3           2m
j-hello   10        3         3         3         5m
j-hello   10        3         3         3         5m
j-hello   10        3         3         3         5m
j-hello   10        10        10        3         5m
j-hello   10        10        10        4         5m
j-hello   10        10        10        5         5m
j-hello   10        10        10        6         5m
j-hello   10        10        10        7         5m
j-hello   10        10        10        8         6m
j-hello   10        10        10        9         6m
j-hello   10        10        10        10        6m
```

Let's check the status of our deployment...

```console
$ kubectl rollout status deploy/j-hello
deployment "j-hello" successfully rolled out
```
It's time to upgrade to v2 so that we can test the canary deployment scenario, just before that let's watch the status of the deployment, you would have noticed that all 10 are running.
```console
$ kubectl get deployments --watch
NAME      DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
j-hello   10        10        10           10          16m
```
Updating the docker image to the V2 image and see what happens...

```console
$ kubectl set image deployment j-hello j-hello=janakiramm/j-hello:2
deployment "j-hello" image updated
```
On another console we can minitor the progress of the **UP-TO-DATE** image, our aim is to get to between 4-6 to monitor it and start the canary deployment.
```console
$ kubectl get deployments --watch
NAME      DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
j-hello   10        10        10           10          16m
j-hello   10        10        10        10        20m
j-hello   10        10        10        10        20m
j-hello   10        10        0         10        20m
j-hello   10        9         0         9         20m
j-hello   10        10        1         9         20m
j-hello   10        11        2         9         20m
j-hello   10        11        2         10        20m
j-hello   10        10        2         9         20m
j-hello   10        11        3         9         20m
j-hello   10        11        3         10        20m
j-hello   10        11        3         10        20m
j-hello   10        11        3         10        20m
j-hello   10        10        3         9         20m
j-hello   10        11        4         9         20m
j-hello   10        11        4         9         20m
j-hello   10        11        4         9         20m
j-hello   10        11        4         10        20m
j-hello   10        11        4         11        21m
```
Now that we have **4/10** running on v2, we can pause the deployement.
```console
$ kubectl rollout pause deploy/j-hello
deployment "j-hello" paused
```
As stated earlier, we have **4/10** running on v2, shown below is a good indication that the canary deployment is working as stated.

```console
$ while true; do curl 192.168.99.100:30001; printf '%s\r\n'; sleep 1; done
Hello World v2!
Hello World!
Hello World!
Hello World v2!
Hello World!
Hello World v2!
Hello World!
Hello World!
Hello World!
Hello World v2!
```

Let's resume this  and have it run at 100%, follow the steps below:

```console
$ kubectl rollout resume deployment/j-hello
deployment "j-hello" resumed
```

We go back to running our curl command to see that all is running on the latest version v2.

```console
$ while true; do curl 192.168.99.100:30001; printf '%s\r\n'; sleep 1; done
Hello World v2!
Hello World v2!
Hello World v2!
Hello World v2!
Hello World v2!
Hello World v2!
Hello World v2!
Hello World v2!
Hello World v2!
Hello World v2!
```
This concludes our demo on canary deployment with Kubernetes...
Deleting the service and deployment

```console
$ kubectl delete deployment j-hello
deployment "j-hello" deleted
$ kubectl delete service j-hello
service "j-hello" deleted
```

## Summary

- Overview of RelicaSets
- What are Deployments
- Why use Deployments
- Use Cases
- Demo

Reference:
- [Kubernetes Webinar Series - Scaling and Managing Deployments](https://www.youtube.com/watch?v=HTA5LihRIoA&list=PLF3s2WICJlqOiymMaTLjwwHz-MSVbtJPQ&index=5)
