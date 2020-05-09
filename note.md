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
### jupyter server : not started, no kernel in vs code

1) Press Command+Shift+P to open a new command pallete

2) Type >Python: Select Intepreter to start jupyter notebook server

3) Open the notebook again


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
### python 的负除法

```
stack.append(int(float(l) / r))
# here take care of the case like "1/-22",
# in Python 2.x, it returns -1, while in

1/-22 = -1
in leetcode is 0
```


### python 一行式

列表辗平

```

 print(list(itertools.chain(*a_list)))

```
一行式的构造器

```
class A(object):
	def __init__(self, a, b, c, d, e, f):
        self.__dict__.update({k: v for k, v in locals().items() if k != 'self'})
```




## k8s


### k8s dashboard, token 
```

kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')

```


## golang 

### golang 比软突出特性

+ chan 通道
+ defer 
+ func init
+ :=
+ 内嵌类型

### golang短声明规则
+ this declaration is in the same scope as the existing declaration of v (if v is already declared in an outer scope, the declaration will create a new variable §),
+ the corresponding value in the initialization is assignable to v, and
there is at least one other variable in the declaration that is being declared anew.

*声明中至少有其它一个变量将被声明为一个新的变量*
出现地方: 返回值的err


### 空白标识符
过go build 关

+ 多重赋值
+ 未使用的导入和变量
+ 副作用式导入
+ 接口检查


### golang 一些使用锁的意外

```

func fab() {
	var a, b int
	var l sync.Mutex // or sync.RWMutex

	l.Lock()
	go func() {
		l.Lock()
		b = 1
		l.Unlock()
	}()
	go func() {
		a = 1
		l.Unlock()
	}()
}

```

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

### ubuntu 必装

apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev


### v2ray 客户端安装

个人建议使用

```

https://qv2ray.github.io/
https://github.com/v2ray/v2ray-core/releases

```

### 为什么TCP4次挥手时等待为2MSL?

https://www.zhihu.com/question/67013338


### 开启代理

export ALL_PROXY=socks5://127.0.0.1:1080

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
### fedora 开启flatpak

```

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

```

### fedora 控制 journal 的日志大小

https://unix.stackexchange.com/questions/130786/can-i-remove-files-in-var-log-journal-and-var-cache-abrt-di-usr

```

journalctl --disk-usage

```


```

/etc/systemd/journald.conf

```

```

SystemMaxUse=50M

```


```

sudo systemctl restart systemd-journald.service

```

### legit提高工作流

同时进行同步本地与服务

```

git sync 

```


### Uninstalling a RPM Package with rpm

fedora 删除软件包

```

rpm -qa
rpm -e 

```

### linux设置max_map_count值(docker elasticsearch 有用)

```

sudo sysctl -w vm.max_map_count=262144

```

### 只打印指定的行

```

sed -n "{start},{end}p" file.txt

```

### 数码相机图片批量处理

```

ufraw-batch *.ARW --out-type=jpeg --compression=99

```

## 设置英文环境

```

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

```

## linux wifi命令行操作

查看命令

```

nmcli dev wifi

```

连接

```

nmcli dev wifi connect AP-SSID password APpassword

```
## 清fedora 缓存

```

pkcon refresh force -c -1


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

## git fatal: index-pack failed

```

git config --global core.compression 0

```

## git 配置显示时间格式

```

git config --global log.date format:’%Y-%m-%d %H:%M:%S’

```


## 使用i3wm的时候多屏输出

```

xrandr --output HDMI1 --auto --left-of eDP1

```

GUI arandr也可以使用

https://wiki.archlinux.org/index.php/Xrandr_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#%E5%9B%BE%E5%BD%A2%E5%8C%96%E6%93%8D%E4%BD%9C%E7%A8%8B%E5%BA%8F




## 收藏链接
linux
+ https://hyper.is/
+ http://blog.lanyus.com/6.html
+ https://mirror.tuna.tsinghua.edu.cn/help/rpmfusion/ 
+ https://www.toolfk.com/

数据库
设计 https://dbdiagram.io/d

算法参考
+ https://www.geeksforgeeks.org/

nfs

https://www.cnblogs.com/mchina/archive/2013/01/03/2840040.html

k8s

+ https://github.com/kubernetes/dashboard.git
+ http://kubernetesbyexample.com/
+ https://kubernetes.io/docs/concepts/workloads/controllers/deployment/

stackoverflow
+ https://stackoverflow.com/questions/7979548/how-to-render-my-textarea-with-wtforms/23256596
+ https://stackoverflow.com/questions/26649716/how-to-show-pil-image-in-ipython-notebook

python
+ http://dongweiming.github.io/Expert-Python/
+ https://towardsdatascience.com/10-steps-to-set-up-your-python-project-for-success-14ff88b5d13
+ https://pymotw.com/3/

golang
+ https://golangexample.com/
+ https://github.com/parnurzeal/gorequest
+ [Clog is a channel-based logging package for Go.](https://github.com/go-clog/clog) 
+ https://golang.org/doc/code.html
+ https://golang.org/doc/effective_go.html
+ https://gocn.vip/article/414
+ https://medium.com/@l.peppoloni/how-to-improve-your-go-code-with-empty-structs-3bd0c66bc531
+ https://gfw.go101.org/article/101.html
+ http://go-database-sql.org/index.html

zsh

+ https://github.com/supercrabtree/k
+ https://github.com/zsh-users/zsh-syntax-highlighting

jupyter 

+ https://github.com/jupyter/jupyter/wiki


简历参考
+ https://juejin.im/post/5b2fb0e1f265da59584d98b9
+ https://github.com/resumejob/awesome-resume
+ https://github.com/geekcompany/ResumeSample
+ http://cv.ftqq.com/?fr=github#
+ https://resume.wuhaolin.cn/
+ https://github.com/CyC2018/Markdown-Resume
+ https://github.com/labuladong/fucking-algorithm
+ https://github.com/dyweb/awesome-resume-for-chinese

python 面试
+ https://github.com/taizilongxu/interview_python
+ https://github.com/kenwoodjw/python_interview_question

杂
+ https://www.justmysocks1.net/members/clientarea.php
+ 学习git https://learngitbranching.js.org 
+ 练习正则 https://regexone.com/
+ https://sqlzoo.net/
