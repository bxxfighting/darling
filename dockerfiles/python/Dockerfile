FROM python:3.8.5

RUN mkdir /project
WORKDIR /project
ADD . /project
RUN pip install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/
RUN gunicorn -c gunicorn.py -k gevent rurality.wsgi:application

EXPOSE 18785

CMD ["gunicorn -c gunicorn.py -k gevent rurality.wsgi:application"]
