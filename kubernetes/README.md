Le nom du namespace est: dunand-mathieu

il faut les replicaset:
- api-replicaset.yaml
- frontend-replicaset.yaml
- consumer-replicaset.yaml
- rabbitmq-replicaset.yaml
- redis-replicaset.yaml

les services:
- api-service.yaml
- frontend-service.yaml
- rabbitmq-service.yaml
- redis-service.yaml

et:
- ingress.yaml


## Schéma Descriptif

```mermaid

 graph LR
    subgraph "Kubernetes"
    subgraph "dunand-mathieu"
    subgraph "frontend-replicaset"
      pod-front
    end
    subgraph "api-replicaset"
      pod-api
    end
    subgraph "redis-replicaset"
      pod-redis[("Redis
                  pod")]
    end
    subgraph "rabbitmq-replicaset"
      pod-rabbitmq[\" RabbitMQ
                      pod"/]
    end
    subgraph "consumer-replicaset"
      pod-consumer
    end
    svc-api([svc-api]) --> pod-api
    svc-redis([svc-redis]) --> pod-redis
    svc-rabbitmq([svc-rabbitmq]) --> pod-rabbitmq
    pod-consumer -.-> svc-rabbitmq
    pod-consumer -.-> svc-redis
    pod-api -.-> svc-redis
    pod-api -.-> svc-rabbitmq
    ing -->|"calculatrice-dunand-mathieu-polytech-dijon.kiowy.net
/api"| svc-api
    ing(Ingress NGINX rules) -->|"calculatrice-dunand-mathieu-polytech-dijon.kiowy.net
/"| svc-front
    svc-front([svc-front]) --> pod-front
    end
    end

```