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