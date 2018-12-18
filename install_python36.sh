#!/bin/sh
yum install -y zlib-devel openssl-devel libxslt-devel libxslt libxml2 libxml2-devel \
    sqlite-devel readline-devel xz-devel  bzip2-devel sqlite-devel
wget https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tar.xz
tar xvf Python-3.6.3.tar.xz
cd Python-3.6.3
./configure --enable-optimizations
make && make install
