# 相关知识

## 有关运行方式
一般node服务使用pm2启动

### pm2服务本身的开机启动设置
```
pm2 startup
```
> 执行此命令，pm2就会根据当前操作系统自动创建对应的开机启动配置  
> 例如，如果是centos7就会创建systemd对应的配置文件  

[参考文档](https://pm2.keymetrics.io/docs/usage/startup/#startup-script-generator)  

### 服务启动
```
pm2 start [config_file] --name [service_name]
```

### 服务停止
```
pm2 stop [service_name]
```

### 服务重启
```
pm2 restart [service_name]
```

> 以上三步，启动时指定配置文件，配置文件中是可以指定服务名称的  
> 但是运维和开发是两个独立的个体，人家配置文件中的名称未必跟你需要的一致  
> 如果不一致就增加--name [service_name]来指定自己需要的名称  

[参考文档](https://pm2.keymetrics.io/docs/usage/quick-start/)  

### 服务配置
因为是纯nodejs项目，可将pm2设置成cluster模式，并且指定instances为max，即可使用全部可用CPU  
```
module.exports = {
  apps : [{
    script    : "api.js",
    instances : "max",
    exec_mode : "cluster"
  }]
}
```

[参考文档](https://pm2.keymetrics.io/docs/usage/cluster-mode/)  

### 有关日志
默认pm2会把日志文件放到~/.pm2/logs下, 如果需要指定自己想要的路径，则可以通过以下文档配置  

[参考文档](https://pm2.keymetrics.io/docs/usage/log-management/)  
