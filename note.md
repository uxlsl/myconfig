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


## docker 设置私有代理

1. 修改/etc/docker/daemon, 增加这一行

"insecure-registries" : ["xxxxxxxxxxx"]

2. 命名标签

docker tag foobar xxxxxxx/foobar

3. 推送

docker push xxxxxxx/foobar


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

## docker 日志处理

```

➜  ~ cat /etc/docker/daemon.json 
{
  "log-driver": "json-file",
  "log-opts": {"max-size": "10m", "max-file": "3"}
}

```

检查日志

```

du -sh /var/lib/docker/containers/*/*-json.log

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


## python

### 使用webkit爬取数据

```python

# -*- coding: utf-8 -*-

import re
import csv
import time
try:
    from PySide.QtGui import QApplication
    from PySide.QtCore import QUrl, QEventLoop, QTimer
    from PySide.QtWebKit import QWebView
except ImportError:
    from PyQt4.QtGui import QApplication
    from PyQt4.QtCore import QUrl, QEventLoop, QTimer
    from PyQt4.QtWebKit import QWebView
import lxml.html


class BrowserRender(QWebView):
    def __init__(self, display=True):
        self.app = QApplication([])
        QWebView.__init__(self)
        if display:
            self.show() # show the browser

    def open(self, url, timeout=60):
        """Wait for download to complete and return result"""
        loop = QEventLoop()
        timer = QTimer()
        timer.setSingleShot(True)
        timer.timeout.connect(loop.quit)
        self.loadFinished.connect(loop.quit)
        self.load(QUrl(url))
        timer.start(timeout * 1000)
        loop.exec_() # delay here until download finished
        if timer.isActive():
            # downloaded successfully
            timer.stop()
            return self.html()
        else:
            # timed out
            print 'Request timed out:', url

    def html(self):
        """Shortcut to return the current HTML"""
        return self.page().mainFrame().toHtml()

    def find(self, pattern):
        """Find all elements that match the pattern"""
        return self.page().mainFrame().findAllElements(pattern)

    def attr(self, pattern, name, value):
        """Set attribute for matching elements"""
        for e in self.find(pattern):
            e.setAttribute(name, value)

    def text(self, pattern, value):
        """Set attribute for matching elements"""
        for e in self.find(pattern):
            e.setPlainText(value)

    def click(self, pattern):
        """Click matching elements"""
        for e in self.find(pattern):
            e.evaluateJavaScript("this.click()")

    def wait_load(self, pattern, timeout=60):
        """Wait for this pattern to be found in webpage and return matches"""
        deadline = time.time() + timeout
        while time.time() < deadline:
            self.app.processEvents()
            matches = self.find(pattern)
            if matches:
                return matches
        print 'Wait load timed out'


def main():
    br = BrowserRender()
    br.open('http://example.webscraping.com/search')
    br.attr('#search_term', 'value', '.')
    br.text('#page_size option:checked', '1000')
    br.click('#search')

    elements = br.wait_load('#results a')
    writer = csv.writer(open('countries.csv', 'w'))
    for country in [str(e.toPlainText()).strip() for e in elements]:
        writer.writerow([country])


if __name__ == '__main__':
    main()


```

webkit_search.py


```python

# -*- coding: utf-8 -*-
import time
try:
    from PySide.QtGui import QApplication
    from PySide.QtCore import QUrl, QEventLoop, QTimer
    from PySide.QtWebKit import QWebView
except ImportError:
    from PyQt4.QtGui import QApplication
    from PyQt4.QtCore import QUrl, QEventLoop, QTimer
    from PyQt4.QtWebKit import QWebView


def main():
    app = QApplication([])
    webview = QWebView()
    loop = QEventLoop()
    webview.loadFinished.connect(loop.quit)
    webview.load(QUrl('http://example.webscraping.com/search'))
    loop.exec_()

    webview.show()
    frame = webview.page().mainFrame()
    frame.findFirstElement('#search_term').setAttribute('value', '.')
    frame.findFirstElement('#page_size option:checked').setPlainText('1000')
    frame.findFirstElement('#search').evaluateJavaScript('this.click()')

    elements = None
    while not elements:
        app.processEvents()
        elements = frame.findAllElements('#results a')
    countries = [str(e.toPlainText()).strip() for e in elements]
    print countries


if __name__ == '__main__':
    main()

```

## python 常用设置logging 例子

logger -> handler -> formatter

```

import logging

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

# create a file handler
handler = logging.FileHandler('hello.log')
handler.setLevel(logging.INFO)

# create a logging format
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)

# add the handlers to the logger
logger.addHandler(handler)

logger.info('Hello baby')

```
https://michaelheap.com/using-ini-config-with-python-logger/
https://realpython.com/python-logging/
https://fangpenlin.com/posts/2012/08/26/good-logging-practice-in-python/

## python ipython 屏蔽debug信息

```

logging.getLogger('parso.python.diff').disabled=True

```

### python 安装 pycurl

```

yum install libcurl-devel
export PYCURL_SSL_LIBRARY=nss
export LDFLAGS=-L/usr/local/opt/openssl/lib
export CPPFLAGS=-I/usr/local/opt/openssl/include
pip install pycurl --compile --no-cache-dir

```

## k8s


### k8s dashboard, token 
```

kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')

```


## golang 

### http设置请求  

```go

package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
)

func main() {
	client := &http.Client{
	}
	req, err := http.NewRequest("GET", "http://httpbin.org/headers", nil)
	req.Header.Add("If-None-Match", `W/"wyzzy"`)
	resp, err := client.Do(req)

	if err != nil {
		// handle error
	}
	//程序在使用完回复后必须关闭回复的主体。
	defer resp.Body.Close()

	body, _ := ioutil.ReadAll(resp.Body)
	fmt.Println(string(body))


}

```
## linux 系统

显示nfs能加载的

```

showmount -e 10.30.4.100


```

### 配置limits(打开文件数)


/etc/security/limits.conf 

```

* soft    nofile  65535
* hard    nofile  65535

```

/etc/systemd/system.conf 
/etc/systemd/user.conf

DefaultLimitNOFILE=65535


安装bbr 到openvz

```

wget https://raw.githubusercontent.com/kuoruan/shell-scripts/master/ovz-bbr/ovz-bbr-installer.sh
chmod +x ovz-bbr-installer.sh
./ovz-bbr-installer.sh

```


## golang 打开帮助文档

```

# dnf install golang-docs
godoc -http=:6060

```
## git 不用输入密码做法

```

git config credential.helper store


```

## git 合并不关联的历史

```

git pull origin master --allow-unrelated-histories

```

## 收藏链接

http://blog.lanyus.com/6.html

nfs

https://www.cnblogs.com/mchina/archive/2013/01/03/2840040.html

k8s

https://github.com/kubernetes/dashboard.git
http://kubernetesbyexample.com/
https://kubernetes.io/docs/concepts/workloads/controllers/deployment/

stackoverflow
https://stackoverflow.com/questions/7979548/how-to-render-my-textarea-with-wtforms/23256596

python
http://dongweiming.github.io/Expert-Python/#1

golang
https://golangexample.com/
