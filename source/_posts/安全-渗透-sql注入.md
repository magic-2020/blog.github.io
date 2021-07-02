---
title: sql注入
date: 2020-11-20 21:11:55
categories:
- 安全
tags:
- web渗透
- 注入
typora-root-url: ./
---

# web框架

![image-20201130214815335](/blog.github.io/images/image-20201130214815335.png)

<!-- more -->

![image-20201130214848420](/blog.github.io/images/image-20201130214848420.png)

根据web框架，能大致了解到安全漏洞，大致会发生的那些层级，那些地方，通过什么样的方法可以get到相关漏洞，而不是盲目寻找，可以有目的的进行注入

# sql注入背景介绍

sql注入是一种将恶意的sql代码插入或者添加到应用（用户）的输入参数的攻击，攻击者探测出开发者编程过程中的漏洞，利用这些漏洞，巧妙构造sql语句，对数据库系统的内容进行直接检索或者修改。

#  sqli-labs

##  介绍

是进行sql注入练习相对全面的环境，可以在github中进行下载，可以在虚拟机中安装或者docker中安装，对linux系统不熟悉的建议使用虚拟机win安装

- 报错注入

- 盲注

- update注入

- insert注入

- header注入

- 二阶注入

- 绕过WAF

目前确定的是上述方法会在实践中进行，但是，目前停留在概念阶段

## 安装

1、win7虚拟机安装，使用phpstudy集成环境

2、将sqli-labs解压缩包，放在PHPstudy的www文件夹下

3、**修改 db-creds.inc 里代码**如下：

```
<?php
//give your mysql connection username n password
$dbuser ='root';
$dbpass ='root';
$dbname ="security";
$host = 'localhost';
$dbname1 = "challenges";
```

4、访问网址并创建数据库：http://127.0.0.1:8087/sqli-labs-master

5、访问没问题，安装完成

## 解题

### less-1

![image-20201130230638181](/blog.github.io/images/image-20201130230638181.png)

如图：构造参数，即可



# 注入漏洞分类

- 数字型

- 字符型

1. 不管注入类型如何，攻击者的目的只有一点： **绕过程序限制**

2. 数字型不需要单引号闭合，而字符串类型一般要使用单引号来闭合

3. 只要是字符串类型注入，都需要闭合单引号以及注释解释多余代码：在输入框输入内容

   ````sql
   ' or 1=1;drop table admin --
   ````

4. 数据库不同，字符串连接符也不同，SQL Server连接符为：+；oracle为：||；MySQL为：空格

5. cookie注入、post注入这类注入，主要是通过注入的位置来分辨的，均是数字或字符型注入的不同展现形式，或者不同的展现位置罢了

````
post注入：注入字段在post数据中
cookie注入：注入字段在cookie数据中
延时注入：使用数据库延时特性注入
搜索注入：注入处为搜索的地点
base64注入：注入字符串需要经过base64加密
````