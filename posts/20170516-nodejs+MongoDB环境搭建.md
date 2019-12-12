---
title: nodejs+MongoDB环境搭建
date: 2017/05/16 23:11:00
---


## nodejs

### windows

windows下nodejs的安装十分的简单，首先到[http://nodejs.cn/download/](http://nodejs.cn/download/ "http://nodejs.cn/download/")下载安装包，然后安装即可。

### Linux

#### 下载

Linux下有两种安装方法：  
一种是借助Linux下的软件包管理工具，比如yum、apt-get等，但是此处不推荐这种方式，因为软件包管理工具中维护的都是比较老的版本，这些老的版本可能不满足我们项目对node包管理的版本要求。  
另一种是下载解压包进行解压：  
下载方式有两种，一是windows下进行下载，同样，先到[http://nodejs.cn/download/](http://nodejs.cn/download/ "http://nodejs.cn/download/")下载安装包，然后通过sftp上传到Linux服务器。二是直接在Linux环境下使用wget命令下载，例如文件地址为tongjitest.dataserver.cn/download/node-v6.10.2-linux-x64.tar.xz的话。可以使用`wget tongjitest.dataserver.cn/download/node-v6.10.2-linux-x64.tar.xz`下载文件到Linux本地。  
此处推荐采用第一种方式。  
<!-- more -->
#### 安装

安装的话包括两步，一是解压，二是配置。

##### 解压

解压又包括两部，因为压缩格式是tar.xz，所以需要先解压。命令如下： 
	`tar zxvf  ***.tar.xz`  
执行完成后就会在当前目录生成相应文件夹。

##### 配置

非Root用户的话，需要将软件解压在自己的主目录下面。  
安装完毕后需要配置：  
假设安装路径为/usr/local/nodejs/node-v6.10.2/  
那么将下面三句命令：  
	`export NODE_HOME=/usr/local/nodejs/node-v6.10.2
	export PATH=$PATH:$NODE_HOME/bin
	export NODE_PATH=$NODE_HOME/lib/node_modules`
写入到~/.bashrc或者~/.bash_profile（其中~代表当前用户的Home目录，每次执行shell的时候，会先去执行这两个文件里面的命令）里面使其对当前用户有效，写入完毕以后使用`source ~/.bashrc`使其生效。  
此时nodejs就安装完毕了。  
可以使用node -v命令进行验证，如果能够显示正确版本则代表安装成功。

注意：如果是采用Root账户安装的nodejs，则需要增加xxx/bin/nodejs软链接到/usr/bin/node  
`sudo ln -s /usr/local/nodejs/node-v6.9.2-linux-x64/bin/nodejs /usr/bin/node`

## Express

Express的安装十分简单，其实就是使用npm将相应的包下载下来，使用的命令为：  

	npm install express --save --registry=https://registry.npm.taobao.org  

但是我已经将Express作为依赖保存到用户行为研究项目的依赖文件package.json中，所以此处不需要专门安装，直接在安装项目依赖的时候一并安装即可，安装项目所有依赖方法为：
  
	在项目根目录下执行：npm install --registry=https://registry.npm.taobao.org
	npm会读取package.json并将安装其中所有依赖。

## MongoDB

MongoDB的安装和配置是较为麻烦的一个，主要是因为涉及到了用户的配置，在用户行为研究的开发中，我们可能需要用到两个软件，一是MongoDB，二是一个图形化界面显示MongoDB数据的MongoDBCompass。大家可以自行下载安装包，下载后分别进行安装，安装完毕后进行配置： 
 
### 环境变量

首先是环境变量，要将MongoDB安装位置的bin文件夹路径配置进环境变量里面的path，例如：  
将`D:\work\MongoDB\Server\3.2\bin`加载path变量中，以英文逗号进行分割。 
 
### 将MongoDB配置为windows系统服务

将MongoDB配置为windows系统服务包括以下几个步骤：  

1、创建MongoDB配置文件，这个文件里面指定了数据库文件和日志文件存储的位置。例如我存放于D:\work\MongoDB的配置文件：  

	systemLog:
	    destination: file
	    path: E:\mongodb\log\mongod.log // 指定日志文件路径，文件必须存在
	storage:
	    journal:  
	        enabled: true  
	    dbPath: E:\mongodb\db  // 指定数据库文件路径
	net:
	    port: 27017				// 指定端口号，27017也是默认端口
	security: 
	    authorization: enabled	// 启用安全配置，也就是需要用户名和密码连接数据库
	setParameter:
	    enableLocalhostAuthBypass: false  // 关闭本地例外方式，即本地也不能直接登录

2、用系统管理员打开一个命令行终端(“cmd.exe”),执行下面的命令;

	mongod --config "D:\work\MongoDB\mongod.cfg" --install

3、验证是否成功将MongoDB配置为windows系统服务  

win + R 键，在运行中输入“services.msc”，查看是否有MongoDB服务。

4、启动和停止  

（1）在第3步中找到的MongoDB服务上进行启动和停止。  
（2）使用命令行：net start MongoDB 和 net stop MongoDB。  

至此已经完成了MongoDB配置为系统服务的过程。

### MongoDB用户的创建

1、在配置文件中将`enableLocalhostAuthBypass`配置改为true，允许本地例外方式进行登录。  

2、在命令行中输入mongo，连接到MongoDB Server。  

3、创建root账号：
	
	> use admin
	> db.createUser( { 
	    user: "root", 
	    pwd: "root123456", 
	    roles: [ 
	        { 
				role: "root", 
				db: "admin"
			} 
	    ]
	})
	
此root账号只有访问admin数据库的权限，不能访问其他数据库，仅仅用来管理其他的数据库的账号。  

4、创建数据库ebs_ubs和数据库管理员账号，MongoDB的用户认证绑定到每一个库:  

	> use admin
	> db.auth('root', 'root123456') // 用刚才创建的root用户登录admin数据库
	> use ebs_ubs
	> db.createUser( { 
	    user: "admin", 
	    pwd: "admin123456", 
	    roles: [ 
	        { 
				role: "dbAdmin", 
				db: "ebs_ubs"
			} 
	    ]
	})

此admin账号为ebs_ubs的数据库管理员账号，仅仅用于管理ebs_ubs这一个数据库。数据库之间的权限管理是独立的，所以另外一个数据库的管理员账号可以与这个完全相同。

5、用新创建的账号登录ebs_ubs库

	> use ebs_ubs
	> db.auth(('admin', 'admin123456')

### MongoDB数据库的备份和恢复

直接在命令行执行以下命令：  

1、备份一个数据库

	mongodump -u admin -p admin123456 --port 27017 -d ebs_ubs -o ebs_ubs_data

2、恢复一个数据库

	mongorestore -u admin -p admin123456 --port 27017 -d ebs_ubs test_data/test/

	注：恢复的时候加--drop会删除原来的数据，不加会合并原来的数据。

3、备份一张表
	
	mongoexport -u admin -p admin123456 --port 27017 -d test -c deviceInfo -o deviceInfo.dat

4、恢复一张表

	mongoimport -u admin -p admin123456 --port 27017 -d ebs_ubs --drop -c deviceInfo deviceInfo.dat


















