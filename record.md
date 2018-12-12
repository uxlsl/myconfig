# 常用记录

## virtualbox 设置数据路径

```

vboxmanage setproperty machinefolder /path/to/directory/

```

vboxmanage list systemproperties | grep folder 可通过这条命令查出

[参考](https://askubuntu.com/questions/800824/how-to-change-virtualbox-default-vm-location-in-command-line)


## vagrant 默认下载位置

由VAGRANT_HOME这个环境变量决定，默认在~/.vagrant.d
[参考](https://www.vagrantup.com/docs/other/environmental-variables.html)



## iptables 开启端口

```

iptables -I INPUT -p tcp --dport 80 -j ACCEPT

```


## docker 服务端设置代理

1.

```

sudo mkdir -p /etc/systemd/system/docker.service.d

```

2. 

设置文件:
/etc/systemd/system/docker.service.d/http-proxy.conf

```

[Service]
Environment="HTTP_PROXY=http://proxy.example.com:80/"


```


3.

```

sudo systemctl daemon-reload

```


4.

```

sudo systemctl daemon-reload

```

5. 

```

sudo systemctl restart docker

```

https://docs.docker.com/config/daemon/systemd/#httphttps-proxy


## docker镜像加速

```

sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://1bkzzdn7.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

```

## bash强键参数set

```

set -euxo pipefail

```


## ubuntu 设置hostname

```

hostnamectl set-hostname new_host_name

```


## centos 系统常用安装包

```

sudo yum install -y zlib-devel openssl-devel libxslt-devel libxslt libxml2 libxml2-devel \
    sqlite-devel readline-devel xz-devel  bzip2-devel sqlite-devel

```


## dockerfile 内容常加部份


```

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

```


## kubectl 使用

### kubectl 删除deployment资源


```

kubectl get deployment
kubectl delete deployments/my-nginx

```

### kubectl 获取pod 的ip

```

kubectl get pod -o wide

```


## k8s一些设计思想

通过service访问pod

## sshd 的一些配置

PermitRootLogin 这个选项可以使用root无法登录
PasswordAuthentication 这个选项让ssh-copy-id不能成功
