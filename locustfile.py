import os
import uuid
import random
import logging
from locust import HttpUser, User, task, between
import redis


class WebUser(HttpUser):
    weight = 2
    wait_time = between(5, 9)
    host = 'http://oracle.com'

    @task
    def index_page(self):
        resp = self.client.get('/')
        logging.info(resp)


'''
class RedisUser(User):
    weight = 3
    wait_time = between(1, 3)

    @task
    def set(self):
        key = str(uuid.uuid4())
        value = str(uuid.uuid4())
        resp = self.rc.set(key, value)
        logging.info(resp)

    def on_start(self):
        self.rc = redis.StrictRedis(host=os.environ.get('REDIS_HOST'), charset='utf-8', decode_responses=True)
        logging.info('on_start')

    def on_stop(self):
        self.rc.flushdb()
        logging.info('on_stop')
'''
