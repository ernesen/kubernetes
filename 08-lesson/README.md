# Deploying StatefulSets in Kubernetes

## Objectives
- Overview of StatefulSets
- Setting up the storage infrastructure of StatefulSet
- Configuring MyQSL Cluster in HA as a StatefulSet
- Scaling the StatefulSet
- Deploying WordPress as a ReplicaSet
- Demos
---
## Persistence and Containers
- Containers are designed to be stateless
- Containers use ephemeral storage
- Pods can be made stateful through volumes
- Running databases could be challenging
	- Lack of stable naming convention
	- Lack of stable persistent storage per Pod
## Introducing StatefulSets
- Bringing the concept of ReplicaSets to stateful Pods
- Enables running Pods in a "clusteres mode"
- Ideal for deploying highly available database workloads
- Valuable for applications that need
	- Stable, unique network identifiers
	- Stable, persistent storage
	- Ordered, graceful deployment and scaling
	- Ordered, graceful deletion and termination
- Currenly in beta - Not available in versions < 1.5
## Kubernetes StatefulSets - Key Concepts
- Depend on a Headless Service for Pod to Pod communication
- Each Pod gets a DNS name accessible to other Pods in the Set
- Leverages Persistent Volumes and Persistent Volume Claims
- Each Pod is suffixed with a predictable, consistent ordinal index
	- mysql-01, mysql-02
- Pods are created sequentially
	- Ideal for setting up master / slave configuration
- The identify is consistent regardeless of the Node it is scheduled on
- Pods are terminated in LiFo order
## Demo Setup
- NFS Storage backend
- Persistent Volume and Claims
- 3 instances of etcd cluster with Node Affinity
- 3 instances of Percona XtraDB Cluster
- 5 instances of WordPress with Horizontal Pod Autoscaling
<!-- Detailed Walktrhough and source code is available at http://tinyurl.com/kubess -->
## Demo
### End-to-End Configuration of StatefulSet

## Summary
- Adding persistence to Pods
- Dealing with block storage in the cloud
- Understanding Persistence Volumes and Claims
- Demos

Reference:
[Kubernetes Webinar Series - Configuring & Deploying StatefulSets](https://www.youtube.com/watch?v=FserPvxKvTA&list=PLF3s2WICJlqOiymMaTLjwwHz-MSVbtJPQ&index=8)
[Deploy a Highly Available WordPress Instance as a StatefulSet in Kubernetes 1.5](https://thenewstack.io/deploy-highly-available-wordpress-instance-statefulset-kubernetes-1-5/)

<!-- the auther mentioned 7th in the series -->
