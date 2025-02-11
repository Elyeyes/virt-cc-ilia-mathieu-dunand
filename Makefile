NAMESPACE=dunand-mathieu

.PHONY: all clean setup apply

all: clean setup apply

clean:
	kubectl delete all --all -n $(NAMESPACE)
	
setup:
	kubectl get namespace $(NAMESPACE) || kubectl create namespace $(NAMESPACE)
	kubectl config set-context --current --namespace=$(NAMESPACE)

apply:
	kubectl apply -f kubernetes/base/frontend/replicaset.yaml
	kubectl apply -f kubernetes/base/frontend/service.yaml
	kubectl apply -f kubernetes/base/api/replicaset.yaml
	kubectl apply -f kubernetes/base/api/service.yaml
	kubectl apply -f kubernetes/base/rabbitmq/replicaset.yaml
	kubectl apply -f kubernetes/base/rabbitmq/service.yaml
	kubectl apply -f kubernetes/base/redis/replicaset.yaml
	kubectl apply -f kubernetes/base/redis/service.yaml
	kubectl apply -f kubernetes/base/consumer/replicaset.yaml
	kubectl apply -f kubernetes/ingress.yaml

