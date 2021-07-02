---
title: git拉取GitHub
date: 2021-05-25 21:11:55
categories:
- 环境
tags:
- 部署
typora-root-url: ./
---

# git拉取GitHub

## 1、 环境准备：git、node.js、hexo、GitHub账号

1） 安装git、node.js软件到本地，下载exe安装文件，然后安装就可以

2） 查看git是否安装成功，在git bash（此后命令均在此输入）中输入 `git –version`

<!-- more -->

## 2、git配置

1、本地创建文件夹（创建空文件夹）用于存放拉取的代码

2、用户名，密码配置
1）在想推送文件的的根目录下，鼠标右击打开 Git bush 命令，首先在 git 命令行窗口配置一下自己的 Github 用户名 和 邮箱；

````
git config --global  user.name "yourusername"
git config --global user.email "youremailcom"

查看用户名和邮箱
git config user.name
git config user.email

查看用户列表
git config --list
````

2）配置好之后，输入 `git init` 命令进行初始化，输入完以后会发现对应根目录下生成一个 .git 文件

3）SSH Key 配置，具体见《hexo+GitHub的blog搭建》

## 3、拉取代码

````
1、与远程代码仓库建立连接
git remote add origin git@github.com:magic-2020/blog.github.io.git （git@github.com:magic-2020/blog.github.io.git为GitHub的SSH网址） 
2、切换分支拉取代码（github_blog为远程代码仓库分支名）
git fetch origin github_blog（更新分支最新状态）
git checkout -b github_blog（切换分支）
git pull origin github_blog（拉取代码）
````

## 4、使用拉取后的代码

1、在Git bush 界面中输入`npm install`，安装所需要的组件，安装路径为拉取代码的根目录

2、`nmp -v`用于验证git是否能够使用nmp命令安装软件

## 5、创建分支

git branch -a --首先查看本地分支

**假设没有分支**
git branch dev --创建一个dev分支（不放心可以再次查看一次 git branch -a ）
git checkout dev–切换到dev 分支上 （这时会看到路径后面的括号里显示的 dev）

## 6、提交

**接下来的操作，就和正常一样了**
git add . //提交所有内容
git commit -m “提交到分支”
git push -u origin 分支名 （同理后续推送最好pull下）

## 7、合并

**当测试完毕，准备合并到主分支时**
(主分支先 git add. 和git commit下)
git checkout master --切换到主分支（假设在dev上）
git pull origin master 建议pull 下
git merge dev --把dev分支合并
git status --查看下状态（可以看到你有几次提交需要push到主分支去）
git push origin master–推到主分支

**如果不需要分支了，可以删除**
git branch -d 分支名
git branch —查看当前分支
