### 使用说明
为了方便管理服务的启动、停止等行为，使用systemd来控制  
通过提供模板文件，替换其中内容生成对应服务的文件  
模板内容如下：  
```
[Unit]
Description={{service_sign}}
After=network.target

[Service]
User=www
WorkingDirectory={{service_path}}
ExecStart={{start_cmd}}
ExecStop={{stop_cmd}}
Restart=always
RestartSec=5
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```
> Unit和Install两节内容视自己需求而定  
> Service节下，User根据自己需求指定用户，一般用root或者www(必须保证系统存在对应用户)  
> WorkingDirectory: 指定工作目录  
> ExecStart: 指定启动命令  
> ExecStop: 指定停止命令，可以给一个默认值: kill -9 $MAINPID
> Restart=always：代表异常退出就重启  
> RestartSec=5：重启前等待5秒  
> PrivateTmp=true: 使用独立的tmp目录，如果设置为false就使用/tmp目录，如果为true就使用/tmp/xxxx/tmp目录  
> java服务需要注意，如果设置为true的话，很多jvm相关命令就查找不到此服务了，比如jps命令  

此模板文件会在ansible-playbook中使用，通过ansible的template模板，生成对应的文件  
在使用之前，需要在ansible-playbook中定义好所需变量，ansible会自动完成替换  
示例:  
```
vars:
  start_cmd: "python manager.py runserver"
  service_sign: "xx"
  service_path: "/var/www/xx"
tasks:
- name:
  template:
    src: ansible/templates/systemd/common/systemd.tpl
    dest: /lib/systemd/system/xx.service
```

### 有关操作
以服务xx为例:  

##### 文件存放路径
Centos：```/usr/lib/systemd/system/xx.service```  
Ubuntu：```/lib/systemd/system/xx.service```  
> 当然可以统一放到相同目录```/lib/systemd/system/xx.service```(在Centos上创建软链接)  

##### 常用命令
* 查看服务运行状态
```
systemctl status xx
```
* 启动服务
```
systemctl start xx
```
* 停止服务
```
systemctl stop xx
```
* 重启服务
```
systemctl restart xx
```
* 开机启动
```
systemctl enable xx
```
* 禁用开机启动
```
systemctl disable xx
```
* 查看服务运行输出日志
```
journalctl -fn 100 -u xx
```
