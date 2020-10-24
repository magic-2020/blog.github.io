---
title: hexo+GitHub的blog搭建
date: 2020-03-25 21:11:55
tags:
	- 部署
typora-root-url: ./
---

# 遇到的实战渗透

信息收集网站：感觉这网站  https://scan.top15.cn/web/ 

# hexo+GitHub的blog搭建

1、 环境准备：git、node.js、hexo、GitHub账号

1） 安装git、node.js软件到本地，下载exe安装文件，然后安装就可以

2） 查看git是否安装成功，在git bash（此后命令均在此输入）中输入 git –version

3） 查看hexo是否安装成功，输入 hexo -v

4） 注册github账号，并建立repository，注意一定要是公共的

2、 hexo搭建

1） 新建一个文件夹，并命令cd进入此文件夹

2） 开始安装Hexo，输入：npm install hexo -g

3） 检查hexo是否安装成功，输入：hexo -v

4） 初始化该文件夹，输入：hexo init （此后想重新搭建，从这一步开始就可以）看到后面的“Start blogging with Hexo！”就说明初始化好了

5） 输入npm install，安装所需要的组件

6） 安装好后，执行以下命令：（1）hexo g #generate 生成静态文件 （2）hexo s #server 启动服务器。默认情况下，访问网址为： http://localhost:4000/

3、 ssh配置 

1） 在Git Bash输入以下指令（任意位置点击鼠标右键），检查是否已经存在了SSH keys。

ls -al ~/.ssh

2） 如果不存在就没有关系，如果存在的话，直接删除.ssh文件夹里面所有文件：

![clip_image001-1584952379327](/blog.github.io/images/clip_image001-1584952379327.png)

3） 输入以下指令（邮箱就是你注册Github时候的邮箱）后，回车（不停回车，不用输入任何东西）：

`ssh-keygen -t rsa -C angelen10@163.com`

4） 进入GitHub，在设置中的在Settings sidebar那里，点击SSH keys，然后新增ssh

5） 在ssh中，粘贴C:\Users\user\.ssh下的id_rsa.pub文件中的所有内容

6） 在bash中输入 `ssh -T git@github.com` 验证是否连接成功

4、 _config.yml配置

1）在文档的最后的配置

````
deploy:
 type: git
 repository: git@github.com:GitHub用户名/repository名称.git
 branch: master
````

2）文档中URL的配置

url: 你的repository下的GitHub网址（是GitHub中repository的打开的网址，不是即将部署的你的博客的网址）

root: /blog.github.io

3）文档中site的配置

````
# Site
title: 标题
subtitle: 副标题
description: 描述
keywords: 
author: 
language: zh-CN
timezone: Asia/Shanghai
````

4）文档中，每行结尾要有空格，冒号后面要有空格

5、 同步GitHub

1） 执行：npm install hexo-deployer-git –save 安装hexo-deployer-git插件

2） hexo d -g 将文档部署到GitHub上

3） 打开GitHub中的网址，可以看到部署成功的blog

4） hexo g #generate 生成静态文件
 hexo s #server 启动服务器。在本地预览效果，默认情况下，访问网址为： http://localhost:4000/
 hexo d #deploy 部署网站同步到github。部署网站前，需要预先生成静态文件
 hexo clean #clean 清除缓存文件 (db.json) 和已生成的静态文件 (public)。

6、 设置主题

1） `git clone https://github.com/iissnan/hexo-theme-next themes/next`

2） 打开站点配置文件 _config.yml，找到 theme 字段，并将其值更改为 next。

theme: next

主题配置：

https://www.jianshu.com/p/208f2c4e3a16

https://www.jianshu.com/p/f054333ac9e6

https://www.jianshu.com/p/b520b49562b2
