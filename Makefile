NAMESPACE=dunand-mathieu
IMAGE=virt-cc-ilia-mathieu-dunand
IMAGETAG=europe-west1-docker.pkg.dev/polytech-dijon/polytech-dijon/

.PHONY: all clean setup apply

all: clean setup docker apply

docker:
	docker-compose down --rmi all
	docker-compose build --no-cache
	docker tag $(IMAGE)-nginx $(IMAGETAG)frontend-dunand-mathieu
	docker tag $(IMAGE)-backend $(IMAGETAG)backend-dunand-mathieu
	docker tag $(IMAGE)-consumer $(IMAGETAG)consumer-dunand-mathieu
	docker push $(IMAGETAG)frontend-dunand-mathieu
	docker push $(IMAGETAG)backend-dunand-mathieu
	docker push $(IMAGETAG)consumer-dunand-mathieu

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

