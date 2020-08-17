FROM locustio/locust
RUN pip3 install redis
WORKDIR /mnt/locust/
COPY ./ ./
