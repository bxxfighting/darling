### 说明
这只是举例说明，需要根据自己的实际使用情况修改  

#### Dockerfile
```
FROM nginx:1.18

RUN mkdir /project
RUN mkdir -p /opt/logs/nginx/
WORKDIR /project
ADD dist /project
COPY template.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
```
> 镜像继承nginx镜像，并且创建自己需要放代码的目录及日志目录  
> 并且提供了nginx配置文件模板，如果这个配置比较确定不会变，可以打在基础镜像中  

#### nginx配置
```
server {
    server_name localhost;
    listen 80;

    root  /project;
    index index.html;
    charset utf-8;

    access_log /opt/logs/nginx/access.log;
    error_log /opt/logs/nginx/error.log;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location ~ ^/(protected|framework|thems/\w+/views) {
        deny all;
    }
}
```
> 根据Dockerfile中路径配置  
> server_name使用了localhost，其实需要使用服务本身的域名，可以通过一些方式替换，比如jinja2等  
