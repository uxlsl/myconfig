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
