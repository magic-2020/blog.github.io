---
title: bugfree
date: 2021-02-23 21:11:55
tags:
	- 功能
	- bugfree
typora-root-url: ./

---

# bugfree安装

1、官网下载地址：https://www.zentao.net/download.html

2、官网下载安装包，建议Windows一键安装包下载

![image-20210202224127838](/blog.github.io/images/image-20210202224127838.png)

3、根据官网说明，进行安装：https://www.zentao.net/book/zentaopmshelp/40.html

![image-20210202224342844](/blog.github.io/images/image-20210202224342844.png)

4、windows一键安装，应当放在硬盘的根目录下，会在根目录下将整个网站搭建环境放在设置的目录中

![image-20210202224621627](/blog.github.io/images/image-20210202224621627.png)

5、启动start.exe并初始化环境

![image-20210202224907423](/blog.github.io/images/image-20210202224907423.png)

6、超级管理员登录禅道后，一键安装包默认的账号密码是admin，123456

7、**登录禅道数据库**

禅道Windows一键安装包默认只能在服务器本机登录。

浏览器里输入 **http://127.0.0.1:端口号（apache端口为非80端口时，需要填写端口号）/adminer**，然后点击登录页面左下的 **数据库管理**。

即可进入禅道数据库登录页面。

![image-20210202231402010](/blog.github.io/images/image-20210202231402010.png)

存放数据库密码的位置在：D:\bugfree\xampp\zentao\config\my.php

8、初始化环境后，修改Apache端口以及数据库端口，不建议使用默认端口

![image-20210202231917941](/blog.github.io/images/image-20210202231917941.png)

# 配置

## 禅道的目录结构

了解了zentaoPHP框架的基本原理和二次开发机制之后，您对禅道项目管理软件的目录结构应该也比较熟悉了。

### 一、顶级目录结构：

<img src="/blog.github.io/images/20100827145439_81085.gif" alt="img"  />

- bin目录是存放里禅道的一些命令行脚本；
- config下面存放了禅道运行的主配置文件和数据库配置文件。
- db下面是历次升级的数据库脚本和完整的建库脚本。
- framework里面则是禅道php框架的核心类文件。
- lib目录下面是其他几个类文件。比如数据库访问，发送邮件，数据验证等。
- module下面则是存放了具体的模块。禅道目前已经有30余个模块了。
- tmp目录是禅道程序运行时的临时文件存放目录。
- www目录则是存放了各种样式表文件，js文件，图片文件，以及禅道的入口程序，index.php

### 二、www目录

![img](/blog.github.io/images/20100827145756_31262.gif)

- data目录是上传附件所在的目录。
- fushioncharts则存放了报表解决方案所需要用到的flash文件。
- js目录下面则是禅道用到的各种jquery插件和相应的功能函数。
- theme目录则是样式表文件的目录。
- www根目录下面的index.php是整个禅道程序的入口程序。所有的请求都是通过这个程序进入的。install.php则是安装程序。upgrade.php是升级程序，每次升级的时候需要访问这个文件。.htaccess和.ztaccess文件是apache使用的配置文件。可以在rewrite模块打开的情况下，配置禅道使用静态方式访问。

### 三、module目录

module目录下面总共有30多个模块，分别对应了禅道里面的某一个功能模块。整个禅道的功能，就是由这些模块组合而成。让我们来看一个具体的模块。

![img](/blog.github.io/images/20100827150607_10250.gif)

-  lang目录下面存放的当前模块的语言文件。zh-cn对应中文简体，zh-tw中文繁体，依次类推。如果需要修改禅道里面某些字段的名称或者配置，则需要打开相应的文件进行修改。
- view目录下面存放了每一个页面所对应的模板文件。比如bug浏览页面，对应的模板就是browse.html.php。config.php存放了当前模块相应的配置项。control.php则是整个bug模块所有页面的入口。也就是说，bug相关的页面浏览都可以在这个文件里面找到相应的方法定义。model.php则是bug相关数据库操作的方法列表。

## 修改基础信息

### 1、改变名称：

在数据库的company中改变。

![](/blog.github.io/images/clipboard.png)



### 2、改变主题：

在zentao/config/my.php中添加一行 $config->default->theme = “某主题”;

### 3、改产品字段：

1、在zentao/config/zentaopms.php中修改产品为系统。

![image-20210210160958165](/blog.github.io/images/image-20210210160958165.png)

2、修改所有lang中的相关字段

#### notepad批量替换：

![image-20210217160317640](/blog.github.io/images/image-20210217160317640.png)

### 4、配置语言选项

禅道的语言选项如果现实不全，则要修改3处位置：

1、\xampp\zentao\config\ext\maps.php

````
$config->maps['requestPack']['dataType'][] = array('name' => 'lang', 'type' => 'basic', 'options' => array('zh-cn','zh-tw','en','de','fr','vi','ja'));
````

2、\xampp\zentao\config\ext\zzcmmi.php

````
$config->langs = array();
$config->langs['zh-cn']    = '简体（默认）';
$config->langs['zh-tw']    = '繁體';
$config->langs['en']       = 'English';
$config->langs['de']       = 'Deutsch';
$config->langs['fr']       = 'Français';
$config->langs['vi']       = 'Tiếng Việt';
$config->langs['ja']       = '日本語';
````

3、\xampp\zentao\module\common\lang\zh-cn.php

````
/* 语言 */
$lang->lang = '语言';
````

### 5、修改数据库

1）进入  D:\xampp\mysql\bin

在此页面打开cmd

2)输入`MySQL -u root -p`，并执行`SET PASSWORD FOR 'root'@'localhost' =PASSWORD('123456');`修改密码

````
D:\xampp\mysql\bin>MySQL -u root -p
Enter password: ******
Welcome to the MariaDB monitor.  Commands end with ; or \g.

MariaDB [(none)]> SET PASSWORD FOR 'zentao'@'localhost' =PASSWORD('123456');
Query OK, 0 rows affected (0.050 sec)

MariaDB [(none)]> SET PASSWORD FOR 'root'@'localhost' =PASSWORD('123456');
Query OK, 0 rows affected (0.340 sec)
````

注：在网页端`http://127.0.0.1/adminer/`，无法成功修改密码

3、修改`D:\xampp\zentao\config\my.php`中的密码信息

````
$config->db->password  = '123456';
````

### 6、Apache经常性停止服务

点击过快或者点击个别按钮，出现服务器停止运行的情况，目前没有排查出具体原因，怀疑是不兼容导致的

更换成64位最新版本，问题解决