### 说明
这里只是一个简单的示例，需要根据自己项目情况编写对应的Dockerfile  

#### Dockerfile

```
FROM python:3.8.5

RUN mkdir /project
WORKDIR /project
ADD . /project
RUN pip install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/
RUN gunicorn -c gunicorn.py -k gevent rurality.wsgi:application

EXPOSE 18785

CMD ["gunicorn -c gunicorn.py -k gevent rurality.wsgi:application"]
```

> 直接以对应python版本的镜像为基础镜像，然后拷贝自己的代码到指定的目录  
> 一般项目下有一个requirements.txt文件，来管理python依赖库  
> 然后通过使用gunicorn启动服务，gunicorn.py是一个配置模板，可以根据自己实际修改  

一般我们直接通过机器部署的时候，都需要使用systemd或者supervisord来管理程序的运行、重启等  
但是使用docker一般都是通过k8s来部署的，如果出现异常，k8s就有对应操作了  
