# Create the Cron Job
kubectl create -f cron.yaml

# Alternative form
kubectl run hello \
	--schedule="*/1 * * * *" \
	--restart=OnFailure \
	--image=busybox \
	-- /bin/sh -c "date; echo Hello from Kubernetes cluster"

# Get the Cron Job
kubectl get cronjob hello

# Get the Job details
kubectl logs hello-
kubectl get jobs --watch

# Clean up
kubectl delete cronjob hello
