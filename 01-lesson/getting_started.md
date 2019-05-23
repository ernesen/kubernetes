# Getting started with Kubernetes

## Objectives
* The need for containers orchestration
* Overview of Kubernetes
* Setting up Kubernetes development environment
* Deploying your first application
* Summary
* Q&A

---
## The Need for Container Orchestration
* Containers are becoming the standard unit of deployment 
* Each container images has
	* Code
	* Binaries
	* Configuration
	* Libraries
	* Frameworks
	* Runtime
* Developers and Operators love containers
* Docker has solved the problem of packaging, deploying and running containerized applications
* Docker has three key components
	* Container Engine
	* Registry
	* Tools
* Docker is great for managing a few containers running on a fewer machines
* Production applications deal with dozens of containers running on a hundreds of machines
* The unit of deployment is changing from a machine to a container
* Infrastructure has become immutable
* Emphasis on treating the datacenter as a large server (cluster)
* Tools are evolving to manage the new datacenter infractrusture
	* Docker Swarm
	* Kubernetes
	* Mesosphere DC/OS
* Manage the lifecycle of containerized application running in production
* Automate the distribution of applications
* Ensure higher levels of utilization and efficiency
---
## The Changing Face of the Datacenter

![The Changing Face of the Datacenter](./images/image-01-01.png)

## What is Kubernetes?
* Kubernetes is inspired from an internal Google project called Borg
* Open source project managed by the Linux Foundation
* Unified API for deploying web applications, batch jobs, and databases
* Decouples applications from machines through containers
* Declarative approach configuration applications
* Automates application configuration through services discovery
* Maintains and tracks the global view of the cluster
* APIs for deployment workflows
	* Rolling updates, canary deploys, and blue-green deployments
---
## Kubernetes Architecture

![Kubernetes Architecture](./images/image-01-02.png)

## Configuring Kubernetes Environment
* **Minikube**
	* Simplest way to get Kubernetes cluster up and running
	* Supports Microsoft Windows and Mac OS X
* **Kubernetes Multi-Node Cluster**
	* Emulates production environment
	* Good for testing advanced scenarios
* **Google Container Engine**
	* Hosted and managed by Google
	* Powered by Google Compute Engine

## Getting Started with Minikube
* Install [Oracle VirtualBox for Mac](https://www.virtualbox.org/wiki/Downloads) 
* Install [Docker Toolbox for Mac](https://docs.docker.com/toolbox/toolbox_install_mac/)
* Install [Docker Version Manager](https://github.com/howtowhale/dvm)
* Install the latest version of [Minikube for Mac OS X](https://kubernetes.io/docs/getting-started-guides/minikube/)
* Download the latest version of kubectl from this [link](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* Run the following commands from the directory where kubectl is downloaded
	* `$ chmod +x ./kubectl`
	* `$ sudo mv kubectl /usr/local/bin`
* Lauch minikube with the following command:
	* `$ minikube start --vm-driver=virtualbox`
* Test minikube installation with the following commands:
	* `$ minikube status`
	* `$ kubectl get cs`

## Demo
### Installing and Configuring Minikube

To install minikube with specific details such as desired memory and virtualization engine, you can run this command:
``` console
$ minikube start --memory 10240 --vm-driver=virtualbox
Starting local Kubernetes v1.8.0 cluster...
Starting VM...
Getting VM IP address...
Moving files into cluster...
Setting up certs...
Connecting to cluster...
Setting up kubeconfig...
Starting cluster components...
Kubectl is now configured to use the cluster.
Loading cached images from config file.

$ minikube status
minikube: Running
cluster: Running
kubectl: Correctly Configured: pointing to minikube-vm at 192.168.99.100

$ minikube ssh
                         _             _
            _         _ ( )           ( )
  ___ ___  (_)  ___  (_)| |/')  _   _ | |_      __
/' _ ` _ `\| |/' _ `\| || , <  ( ) ( )| '_`\  /'__`\
| ( ) ( ) || || ( ) || || |\`\ | (_) || |_) )(  ___/
(_) (_) (_)(_)(_) (_)(_)(_) (_)`\___/'(_,__/'`\____)

$ docker version
Client:
 Version:      1.12.6
 API version:  1.24
 Go version:   go1.6.4
 Git commit:   78d1802
 Built:        Wed Jan 11 00:23:16 2017
 OS/Arch:      linux/amd64

Server:
 Version:      1.12.6
 API version:  1.24
 Go version:   go1.6.4
 Git commit:   78d1802
 Built:        Wed Jan 11 00:23:16 2017
 OS/Arch:      linux/amd64
$ docker images
REPOSITORY                                             TAG                 IMAGE ID
    CREATED             SIZE
redis                                                  latest              c3eb149853f0
    5 days ago          106.7 MB
gcr.io/google_containers/kubernetes-dashboard-amd64    v1.8.0              55dbc28356f2
    12 days ago         119.2 MB
nginx                                                  latest              9e7424e5dbae
    2 weeks ago         108.5 MB
grafana/grafana                                        latest              2b412f18ade7
    3 weeks ago         285.3 MB
gcr.io/k8s-minikube/storage-provisioner                v1.8.1              4689081edb10
    4 weeks ago         80.82 MB
mongo                                                  latest              d22888af0ce0
    5 weeks ago         360.9 MB
ibmcom/secure-gateway-client                           latest              e2119e0b8c5b
    6 weeks ago         82.3 MB
gcr.io/google_containers/k8s-dns-sidecar-amd64         1.14.5              fed89e8b4248
    10 weeks ago        41.81 MB
gcr.io/google_containers/k8s-dns-kube-dns-amd64        1.14.5              512cd7425a73
    10 weeks ago        49.38 MB
gcr.io/google_containers/k8s-dns-dnsmasq-nanny-amd64   1.14.5              459944ce8cc4
    10 weeks ago        41.42 MB
gcr.io/google-containers/kube-addon-manager            v6.4-beta.2         0a951668696f
    6 months ago        79.23 MB
janakiramm/todo-app                                    latest              7b84a79093a6
    6 months ago        638.4 MB
gcr.io/kubernetes-helm/tiller                          v2.3.1              38527daf791d
    8 months ago        56 MB
janakiramm/j-hello                                     latest              39308dccafb4
    12 months ago       650.9 MB
janakiramm/j-hello                                     2                   a589ef0d2b4e
    12 months ago       650.9 MB
quay.io/prometheus/prometheus                          v1.1.3              324cf4f3e246
    14 months ago       45.48 MB
gcr.io/google_containers/pause-amd64                   3.0                 99e59f495ffa
    19 months ago       746.9 kB
kubernetes/redis                                       v1                  491b9802c21c
    2 years ago         146 MB
gcr.io/google_containers/busybox                       latest              e7d168d7db45
    2 years ago         2.43 MB
	
$ exit
```
Now, you are back to the previous console...

whenever I start minikube I want to make sure I have the right environment to do so I run the below command:
`$ eval $(minikube docker-env)`
Should you encounter issuses you might have to result into setting this variables, but unlikely!
``` console
$ export DOCKER_TLS_VERIFY=1
$ export DOCKER_HOST=tcp://192.168.99.100:2376
$ export DOCKER_CERT_PATH=~/.minikube/certs
$ export DOCKER_MACHINE_NAME=default
$ export COMPOSE_CONVERT_WINDOWS_PATHS=true
```
Hopefully your minikube is installed and now your ready to explore the world of Kubernetes.

## Kubernetes Terminology
Kubernetes contains a number of abstractions that represent the state of your system: deployed containerized applications and workloads, their associated network and disk resources, and other information about what your cluster is doing. These abstractions are represented by objects in the Kubernetes API.

The basic Kubernetes objects include:

* **[Master](http://cdn2.hubspot.net/hubfs/115489/Getting_Started_with_Kubernetes_Sample_Chapter.pdf?t=1449546307078)**
> Essentially, **master** is the brain of our cluster. Here, we have the core API server, which maintains RESTful web services for querying and defining our desired cluster and workload state. It's important to note that the control pane only accesses the master to initiate changes and not the nodes directly.
> Additionally, the master includes the **scheduler**, which works with the API server to schedule workloads in the form of pods on the actual minion nodes. These pods include the various containers that make up our application stacks. By default, the basic Kubernetes scheduler spreads pods across the clusters and uses different nodes for matching pod replicas. Kubernetes also allows specifying necessary resources for each container, so scheduling can be altered by these additional factors.
> The replication controller works with the API server to ensure that the correct number of pod replicas are running at any given time. This is exemplary of the _desired state_  concept. If our replication controller is defining three replicas and our _actual state_  is two copies of the pod running, then the scheduler will be invoked to add a third pod somewhere on our cluster. The same is true if there are too many pods running in the cluster at any given time. In this way, Kubernetes is always pushing towards that _desired state_.
> Finally, we have **etcd** running as a distributed configuration store. The Kubernetes state is stored here and etcd allows values to be watched for changes. Think of this as the brain's shared memory

* **[Nodes](https://kubernetes.io/docs/concepts/architecture/nodes/)**
> A node is a worker machine in Kubernetes, it may be a VM or physical machine, depending on the cluster. Each node has the services necessary to run pods and is managed by the master components. The services on a node include Docker, kubelet and kube-proxy. 

* **[Pods](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/)**
> A Pod is the basic building block of Kubernetes–the smallest and simplest unit in the Kubernetes object model that you create or deploy. A Pod represents a running process on your cluster.
> A Pod encapsulates an application container (or, in some cases, multiple containers), storage resources, a unique network IP, and options that govern how the container(s) should run. A Pod represents a unit of deployment: a single instance of an application in Kubernetes, which might consist of either a single container or a small number of containers that are tightly coupled and that share resources.

* **[Containers](https://www.docker.com/what-container)**
> A container image is a lightweight, stand-alone, executable package of a piece of software that includes everything needed to run it: code, runtime, system tools, system libraries, settings. Available for both Linux and Windows based apps, containerized software will always run the same, regardless of the environment. Containers isolate software from its surroundings, for example differences between development and staging environments and help reduce conflicts between teams running different software on the same infrastructure. 

* **[Replication Controller](https://kubernetes.io/docs/concepts/workloads/controllers/replicationcontroller/)**
> A ReplicationController ensures that a specified number of pod replicas are running at any one time. In other words, a ReplicationController makes sure that a pod or a homogeneous set of pods is always up and available.


* **[Labels](http://cdn2.hubspot.net/hubfs/115489/Getting_Started_with_Kubernetes_Sample_Chapter.pdf?t=1449546307078)**
> Labels give us another level of categorization, which becomes very helpful in terms of everyday operations and management. Similar to tags, labels can be used as the basis of service discovery as well as a useful grouping tool for day-to-day operations and management tasks.
Labels are just simple key-value pairs. You will see them on pods, replication controllers, services, and so on. The label acts as a selector and tells Kubernetes which resources to work with for a variety of operations. Think of it as a _filtering_ option.

* **[Services](http://cdn2.hubspot.net/hubfs/115489/Getting_Started_with_Kubernetes_Sample_Chapter.pdf?t=1449546307078)**
> Services allow us to abstract access away from the consumers of our applications. Using a reliable endpoint, users and other programs can access pods running on your cluster seamlessly.
Kubernetes achieves this by making sure that every node in the cluster runs a proxy named kube-proxy. As the name suggests, kube-proxy's job is to proxy communication from a service endpoint back to the corresponding pod that is running the actual application.

## Demo
### Exploring Kubernetes Environment Deploying Your First Application

Let's make sure we have the right context before starting and to do that, I'll issue the below command from my CLI.
```console
$ kubectl config get-contexts
CURRENT   NAME                    CLUSTER         AUTHINFO             NAMESPACE
*         minikube                minikube        minikube
          mycluster.icp-context   mycluster.icp   mycluster.icp-user   default
```
If the context is different to minibuke then issue this command:
```console
$ kubectl config use-context "minikube"
Switched to context "minikube".
```
Let's issue a few kubernetes commands to improve our understanding of the topic:
```console
$ kubectl get nodes
NAME       STATUS    ROLES     AGE       VERSION
minikube   Ready     <none>    7d        v1.8.0
$ kubectl get cs
NAME                 STATUS    MESSAGE              ERROR
scheduler            Healthy   ok
controller-manager   Healthy   ok
etcd-0               Healthy   {"health": "true"}
$ kubectl get pods
No resources found, use --show-all to see completed objects.
```
So far, all the demos were running from minikube, say I wanted to run another Cloud provider, in my case I have IBM Cloud Private running from my laptop, I can easily switch to my ICP "IBM Cloud Private" environment. 
To do that I'll have switch context.

```console
$ kubectl config use-context "mycluster.icp"
Switched to context "mycluster.icp".
```
Given that I have changed my environment, it will reflect my mycluster.icp cluster, which has four nodes.
But before I can do this I need to login to ICP first and get the right set of credentials.
https://192.168.27.100:8443/oidc/login.jsp

![IBM Cloud Private](./images/image-01-03.png)

Get the Configure client details.

![Configure client](./images/image-01-04.png)

I receive the details, which I need to paste onto my CLI for it to start my session.

![Configure kubectl](./images/image-01-05.png)

```console
$ kubectl config set-cluster mycluster.icp --server=https://192.168.27.100:8001 --insecure-skip-tls-verify=true
Cluster "mycluster.icp" set.
$ kubectl config set-context mycluster.icp-context --cluster=mycluster.icp
Context "mycluster.icp-context" modified.
$ kubectl config set-credentials mycluster.icp-user --token=eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJhZG1pbiIsImF0X2hhc2giOiJoREczalczQkkyaWVjVWpNY25MMXh3IiwiaXNzIjoiaHR0cHM6Ly9teWNsdXN0ZXIuaWNwOjk0NDMvb2lkYy9lbmRwb2ludC9PUCIsImF1ZCI6ImM2ZDk3NTdmYWY0NmIyNDBkNTJjNDkyMjg0YzQxYmY5IiwiZXhwIjoxNTEyOTMxODQ1LCJpYXQiOjE1MTI4ODg2NDV9.gvfzFFVUAKfEfmzc0RaLae0z2ekz62-ftl69Ya-dIrg66e2yCfUTKruFvT2HYg1epr8XUpTDV_d0mPnAWaiamA7zjs7tuQ0RpZftC5Lxy8NwCTMPk5jPmLtGcrZHr31M5tuYlY82PLQLcFnU0WgerNrA-cI3qrbxH7GXLskH3O30zskY7YyjiAkF8OVDfURjhrdhHgIjnNzi_9QHcITZ7z0OT5Tyqfl-ZuzLyxH1QaQQRD-UKbiStPYtHI3smRlHm_PFlJ_q0exC9kfVF-Fbowxwi9duUop5ENdtD8OSvL6P3rdNuzR0bt0cyJEfrtdvx0wpFtf3O18HS1lZQk3mFw
User "mycluster.icp-user" set.
$ kubectl config set-context mycluster.icp-context --user=mycluster.icp-user --namespace=default Context "mycluster.icp-context" modified.
$ kubectl config use-context mycluster.icp-context
Switched to context "mycluster.icp-context".
```
Now that I'm on ICP, I can start issuing my commands:
```console
$ kubectl get nodes
NAME             STATUS    ROLES     AGE       VERSION
192.168.27.100   Ready     <none>    10d       v1.7.3-7+154699da4767fd
192.168.27.101   Ready     <none>    10d       v1.7.3-7+154699da4767fd
192.168.27.102   Ready     <none>    10d       v1.7.3-7+154699da4767fd
192.168.27.111   Ready     <none>    10d       v1.7.3-7+154699da4767fd
$ kubectl get cs
NAME                 STATUS    MESSAGE              ERROR
controller-manager   Healthy   ok
scheduler            Healthy   ok
etcd-0               Healthy   {"health": "true"}
```
I have in a previous instance created a wordpress environment which will be displayed when I request for my pods, shown below:
```console
$ kubectl get po
NAME                                    READY     STATUS    RESTARTS   AGE
my-wordpress-mariadb-107101664-c8ccr    1/1       Running   0          1d
my-wordpress-wordpress-33976066-cw1wc   1/1       Running   2          1d
```
That was a simple demo to show you that it's possible to have different providers of Kubernetes, let me switch back to minikube for the remainng demo, and to that I have to change context.
```console
$ kubectl config use-context "minikube"
Switched to context "minikube".
```
Here is the list of commands that we plan to test.

![demo](./images/image-01-06.png)

Let's start:
```console
$ kubectl get po
No resources found.
$ kubectl run my-web --image=nginx --port=80
deployment "my-web" created
$ kubectl get deployments
NAME      DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
my-web    1         1         1            1           12s
$ kubectl get po
NAME                      READY     STATUS    RESTARTS   AGE
my-web-84b5767c98-vlmb4   1/1       Running   0          1m
$ kubectl expose deployment my-web --target-port=80 --type=NodePort
service "my-web" exposed
$ minikube ip
192.168.99.100
$ kubectl get svc
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
kubernetes   ClusterIP   10.96.0.1        <none>        443/TCP        7d
my-web       NodePort    10.104.222.203   <none>        80:31912/TCP   3m
$ kubectl describe svc my-web
Name:                     my-web
Namespace:                default
Labels:                   run=my-web
Annotations:              <none>
Selector:                 run=my-web
Type:                     NodePort
IP:                       10.104.222.203
Port:                     <unset>  80/TCP
TargetPort:               80/TCP
NodePort:                 <unset>  31912/TCP
Endpoints:                172.17.0.7:80
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>
PORT=$(kubectl get svc my-web -o go-template='{{(index .spec.ports 0).nodePort}}')
echo $PORT
31912
$ minikube service my-web
Opening kubernetes service default/my-web in default browser...
```
Access webpage:

![Access webpage](./images/image-01-07.png)

You can acess the webpage with http://192.168.99.100:31912 or run this command from the CLI
```console
$ curl 192.168.99.100:31912
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```
Minikube provides a great web-page to access/visualize the features of Kubernetes, you simple have to type:
```console
$ minikube dashboard`
```

![Access webpage](./images/image-01-08.png)

## Summary
* Kubernetes manages containerized workloads running in production
* An open source, community-drive project started by Google
* Kubernetes has a master and multiple worker nodes 
* Clients interact with the master through REST API
* Minikube is the simplest way to get started with Kubernetes


Reference:
* [Kubernetes Webinar Series - Getting Started with Kubernetes](https://www.youtube.com/watch?v=_vHTaIJm9uY&index=1&list=PLF3s2WICJlqOiymMaTLjwwHz-MSVbtJPQ)
* [An Introduction to Kubernetes](https://www.digitalocean.com/community/tutorials/an-introduction-to-kubernetes) 
* [Kubernetes – Core Concepts and Constructs](http://cdn2.hubspot.net/hubfs/115489/Getting_Started_with_Kubernetes_Sample_Chapter.pdf?t=1449546307078)
