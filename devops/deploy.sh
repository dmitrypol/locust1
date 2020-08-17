#!/bin/bash

docker-compose build master && docker tag locust1_master iad.ocir.io/id5p2j2htymo/locust && docker push iad.ocir.io/id5p2j2htymo/locust

kubectl apply -f devops/oke/

kubectl rollout restart deployment.apps/locust-master-deployment
kubectl rollout restart deployment.apps/locust-worker-deployment
