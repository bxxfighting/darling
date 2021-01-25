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
ExecStart={{run_cmd}}
ExecStop=/bin/kill -9 $MAINPID
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
> Restart=always：代表异常退出就重启  
> RestartSec=5：重启前等待5秒  
> PrivateTmp=true: 使用独立的tmp目录，如果设置为false就使用/tmp目录，如果为true就使用/tmp/xxxx/tmp目录  
> java服务需要注意，如果设置为true的话，很多jvm相关命令就查找不到此服务了，比如jps命令  
> ExecStop: 这里直接使用了```kill -9```来停止服务，如果有其它需求，其实可以设置成参数stop_cmd来配置不同命令  

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
* 查看服务运行输出日志
```
journalctl -fn 100 -u xx
```
