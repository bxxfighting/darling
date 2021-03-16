'''
gunicorn -c gunicorn.py -k gevent rurality.wsgi:application
'''
import os
import multiprocessing

CUR_DIR = os.path.dirname(__file__)

bind = "0.0.0.0:18785"
chdir = CUR_DIR
preload = True
worker_class = 'gevent'
