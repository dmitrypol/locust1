# With Docker in distributed mode

```
docker-compose up --build -d --scale worker=5
```

# Without Docker in not distributed mode

```
# run Redis server
# run Python
pipenv install --dev
pipenv shell
locust --config config/locust.conf
```

# Setup infrastructure

```
cd devops/terraform
terraform apply
```

* Browse to https://console.us-ashburn-1.oraclecloud.com/containers/clusters
* Click cluster name
* Follow Quick Start
* Open `~/.kube/` to view contents
* Follow Access Kubernetes Dashboard 
* `kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep oke-admin | awk '{print $1}')`
* Browse to http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login

# Deploy to OKE

```
# Login to OCIR to upload the container image
docker login iad.ocir.io -u bmc_operator_access/dpolyako
# password is Auth Token from User Details page
# create secret in OKE to pull container images
kubectl create secret docker-registry ocir-creds --docker-server=iad.ocir.io --docker-username='bmc_operator_access/dpolyako' --docker-password='___TOKEN_HERE___' --docker-email='dmitry.polyakovsky@oracle.com'
# run
devops/deploy.sh
```