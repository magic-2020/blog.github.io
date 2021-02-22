---
title: Kali安装docker
date: 2021-02-15 21:11:55
tags:
	- docker
	- Kali
typora-root-url: ./
---

# docker安装

<span style="color:red">**注：所有操作均需要在root权限下进行。**</span>

1. **安装https协议、CA证书**、dirmngr

```shell
apt-get update
 
apt-get install -y apt-transport-https ca-certificates
 
apt-get install dirmngr
```

**2.添加GPG密钥并添加更新源**

```shell
curl -fsSL https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian/gpg | sudo apt-key add -

echo "deb https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian/ buster stable" | sudo tee /etc/apt/sources.list.d/docker.list

注意echo后面的''，写如到文档中的内容不应当带''，如果带了，要手动删除，才能进行后续的更新成功
```

**3.系统更新以及安装docker**

```text
apt-get update

apt install docker-ce
```

**4.启动docker服务器**

```text
service docker start
```

**5.安装compose**

```text
apt install docker-compose
```

如果您安装了旧版本的Docker，请卸载它们：

```javascript
apt-get remove docker docker-engine docker.io
```

查看docker状态：

```javascript
systemctl status docker
```

启动docker：

```javascript
systemctl start docker
```

开机自动启动：

```javascript
systemctl enable docker
```

PS：

```text
docker version   查看docker的版本信息
 
docker images   查看拥有的images
 
docker ps       查看docker container 
```

# 运行docker报错"Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?"

执行命令：sudo dockerd --debug

之后重启docker：systemctl restart docker就可以了

# dvwa在docker中的使用

1）查找镜像：

```
docker search dvwa
```

2）拉取镜像：

`````
docker pull citizenstig/dvwa
`````

如果出现报错，提示超时：Error response from daemon: pull access denied for dvwa, repository does not exist or may require 'docker login': denied: requested access to the resource is denied，再次执行一遍

## Error response from daemon: pull access denied for xxx , repository does not exist or may require 'docker login

理论上从 docker hub 拉取镜像时是不需要的登录, 所以就只有一个原因: `repository does not exist`,
需要指定了仓库的用户名, 重新拉取

docker hub 的两种仓库

1. 顶层仓库, 由docker hub 自己管理

2. 用户仓库, 由开发人员创建维护, 命名构成: `用户名/仓库名`, 例如: `zabbix/zabbix-proxy-sqlite3`

3)运行镜像：

````
docker run -d --name dvwa -p 8089:80 -p 33066:3306 -e MYSQL_PASS="password" citizenstig/dvwa
````

4)运行网址：

````
http://127.0.0.1:8089/setup.php
````

5）查看并启动已存在镜像：

````
docker ps -a
docker start 9604d00cc039
````

