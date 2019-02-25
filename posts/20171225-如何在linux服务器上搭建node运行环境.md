---
title: 如何在linux服务器上搭建node运行环境
date: 2017/12/25 23:11:00
---

# 如何在linux服务器上搭建node运行环境

本篇文章以安装APP的server端为例，说明如何在linux系统搭建nodejs运行环境。

## 安装nodejs

由于不同版本之间不一定完全兼容，所以尽量安装大版本相同的。  
打开https://nodejs.org/dist/v8.7.0/。选择合适的版本，复制链接地址。  
比如，我选择了node-v8.7.0-linux-x64.tar.gz，复制得到了地址https://nodejs.org/dist/v8.7.0/node-v8.7.0-linux-x64.tar.gz。  

<!-- more -->

在/usr/local目录下创建nodejs目录，并把目录所有权赋给Shawnan用户。

    
    cd /usr/local    
    sudo mkdir nodejs
    sudo chown Shawnan:Shawnan nodejs

然后利用命令wget将压缩包下载到本地。
    
    cd nodejs
    wget https://nodejs.org/dist/v8.7.0/node-v8.7.0-linux-x64.tar.gz

解压压缩包
    
    tar zxvf node-v8.7.0-linux-x64.tar.gz

配置环境变量

    sudo vi /etc/profile

在最后一行加入

    export PATH=/usr/local/nodejs/node-v8.7.0-linux-x64/bin:$PATH

然后保存，使用source命令使环境变量生效，然后测试安装是否成功。

    source /etc/profile
    node -v

如果此时输出v8.7.0则代表安装成功。

## 安装pm2

利用npm安装pm2

    npm install pm2 -g --registry=http://registry.npm.taobao.org

然后测试是否安装成功。

    pm2 -v

如果此时打印出pm2的版本则证明安装成功。

## 上传server代码

安装完nodejs环境及进程管理工具pm2以后，就可以着手创建webapp服务器的目录。

    cd /usr/local
    sudo mkdir webapp 
    sudo chown Shawnan:Shawnan webapp

进入webapp目录，准备上传server端代码。

    cd webapp

上传server端代码有两种方式，分别是svn更新和xftp上传。
方式一：svn更新，适用于内网。  
直接复制项目的svn地址，到指定的目录下执行svn检出操作。  

    svn co https://xxxxxxxxxxx/server

## 安装依赖包

由于server端也是一个nodejs项目，所以也要安装相应的依赖。

    npm install --registry=http://registry.npm.taobao.org

## 启动项目

最后一步就是采用pm2将server端跑起来。

    cd server
    pm2 start -i max --watch ./bin/www

此时可以从网页尝试访问，能够打开则说明部署成功。

## 注意点

1. 为了避免pm2启动的进程无法区分，要将./bin/www文件重命名为一个与项目相关的名字，比如xxx_uweb、yyy_ebs。