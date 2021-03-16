FROM nginx:1.18

RUN mkdir /project
RUN mkdir -p /opt/logs/nginx/
WORKDIR /project
ADD dist/ /project
COPY template.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
