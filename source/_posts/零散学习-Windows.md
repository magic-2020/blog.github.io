---
title: 零散学习-Windows
date: 2020-06-3 21:11:55
tags:
	环境搭建
    Windows
typora-root-url: ./
---

# 端口命令查看关掉

cmd 中输入： netstat -ano|findstr 8080

信息输出如下：

![img](http://note.youdao.com/yws/res/756/3B38A95211154169A791E5D742C159C1)

再输入：taskkill /f /pid 10200

![img](http://note.youdao.com/yws/res/755/664BBF58B3EF422185F0D6B09EBA7525)



# 多版本火狐共存方案及火狐配置文档高级管理技巧

http://mozilla.com.cn/thread-21647-1-1.html

命令行执行：

````shell
D:\Program Files\Mozilla Firefox 4.0\firefox.exe" --no-remote -p
````

--no-remote的作用就是可以运行多个不同配置文档的火狐。也能启动多个版本火狐，但注意最后启动的一个火狐的配置文档会被定为默认。

一般把火狐设置为-p启动有很多好处，用户可以用多个配置文档同时创建n个功能完全不同的火狐，可以有一个专门安装日常使用扩展，使之成为日常使用火狐，有一个配置文档专门安装调试工具，使之成为开发专用火狐等等~~~

# Google下载地址

https://www.chromedownloads.net/chrome64win/

https://www.cnblogs.com/xiangyuecn/p/10583788.html

# 自动化

https://www.cnblogs.com/yufeihlf/p/5949984.html

https://www.cnblogs.com/rf-bear/p/5556451.html

# excel使用：

## 截取左边第一个“-”的数据

=LEFT(B2,FIND("-",SUBSTITUTE(B2,"#","-",1))-1)

## 截取最后一个“-”的数据，直接替换 *-  ，即可

## 生成随机数：

=RANDBETWEEN(1,2978)

# oracle数据库连接

1、安装oracle客户端

2、设置net manager中的数据库连接，或者配置 C:\oracle\product\10.2.0\client_1\NETWORK\ADMIN 下的tnsnames.ora 文件内容（没有的话，新建文件）

内容如下：

htgl =

  (DESCRIPTION =

​    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.109.141)(PORT = 11521))

​    (CONNECT_DATA =

​      (SERVER = DEDICATED)

​      (SERVICE_NAME = htgl)

​    )

  )

3、安装PlSqlDev ，不要安装在（XXX32目录下），安装完成后，以管理员身份运行，并连接数据库

# metasploitable3的安装

 默认账号密码都是：vagrant

注：

1、metasploitable3安装根据虚拟机的不同，安装命令不一样，大致是根据GitHub上的安装方式来

2、安装之前一定要把环境配置好，不让无法安装

环境安装：

1、把github上的metasploitable3项目下载到本地。https://github.com/rapid7/metasploitable3

2、打开powershell，但是系统安全策略默认是不允许powershell执行脚本的，所以需要命令打开功能。

set-ExecutionPolicy RemoteSigned

3、安装packers：

安装powershell下的包管理器Chocolatey。

iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

用前面配置的choco管理器安装packer，packer用于创建虚拟机镜像。

choco install packer

4、安装vagrant

直接从网上下载安装。https://www.vagrantup.com

安装好vagrant后开始配置插件，然后安装vagrant reload插件，基于ruby的工具。创建和部署虚拟化开发环境。之后的搭建使用oracle的vbox，chef创建自动化虚拟环境。

vagrant plugin install vagrant-reload

5、安装虚拟机VMware-workstation15 pro或virtualbox

第一种环境配置：

win10（1089）

VMware-workstation15 pro

packer

vagrant

vagrant-reload

git（如果没有这个可以下载zip包，自己解压也可）

这种方法可以按照https://github.com/rapid7/metasploitable3上的具体步骤手动安装

在powershell（路径要在metasploitable3下）中执行packer build --only=vmware-iso ./packer/templates/windows_2008_r2.json

然后全称自动安装配置，无需干涉，这个过程的快慢取决你的网速。

结束之后执行vagrant box add packer/builds/windows_2008_r2_*_0.1.0.box --name=metasploitable3-win2k8

执行完毕后会在 C:\user\xxx\vagrant\boxes\metasploitable3-win2k8\0\ 中生成 metasploitable3-win2k8-disk001.vmdk，至此，可以直接复制该vmdk文件到其它地方，**直接在virtualbox中使用现有虚拟硬盘新建虚拟机，即可使用。**

**由于家庭版win10的VM与hyper-v不兼容，只能走到这一步，然后手动启动虚拟机**

**千万不要在虚拟机中安装虚拟机，实践证明，又卡又慢，完全无法等到最后观察是否会成功**

如何你已经安装vagrant-reload可以省略再次执行vagrant plugin install vagrant-reload命令

最后一步vagrant up大功告成

第二种环境配置

virtualbox（我只是把VMware删除了，然后就直接按照官网指导制动安装了）

win10（1089）

packer

vagrant

vagrant-reload

在powershell（（路径要在metasploitable3下））中执行.\build.ps1 windows2008

和第一种环境一样全程自动（自动安装期间虚拟机变化和上边的一样），无需干涉

结束后执行vagrant up win2k8

大功告成

以上两种方式是自己安装做box的，可以保证和在自己的机器环境配置完美运行，可是这种方式太费神，容易失败。不适合小白，和追求效率的伙伴。

下面有一种方式是直接的，就是用人家已经做好的box，这样虽然简单有效，但是无法保证下好的box是否和自己的机器环境符合，也无法保证别人是否在里边留下什么东西。

环境要求：vagrant

virtualbox或者vmware-workststion

去https://app.vagrantup.com/boxes/search?utf8=%E2%9C%93&sort=downloads&provider=&q=metasploitable3寻找自己喜欢的box，这里有很多个人做好的box，建议选择rapid7/metasploitable3-win2k8

步骤1：在metasploitable3文件夹下打开powershell，运行vagrant init rapid7/metasploitable3-win2k8 --box-version 0.1.0-weekly命令

会生成一个vagrant的文件，自动配置好了信息

然后直接 vagrant up 自动下载。

# JDK安装

系统变量→新建 JAVA_HOME 变量 。

变量值填写jdk的安装目录（本人是 E:\Java\jdk1.7.0)

系统变量→寻找 Path 变量→编辑

在变量值最后输入 %JAVA_HOME%\bin;%JAVA_HOME%\jre\bin;

（注意原来Path的变量值末尾有没有;号，如果没有，先输入；号再输入上面的代码）

系统变量→新建 CLASSPATH 变量

变量值填写  .;%JAVA_HOME%\lib;%JAVA_HOME%\lib\tools.jar（注意最前面有一点）

系统变量配置完毕

检验是否配置成功 运行cmd 输入 java -version （java 和 -version 之间有空格）

若如图所示 显示版本信息 则说明安装和配置成功。

https://blog.csdn.net/coffee_cream/article/details/51627720

# MySQL数据库安装

1、去官网下载zip文件，

![img](http://note.youdao.com/yws/res/499/1DDD86912CAC4B2BB4040AE9407ED592)

2、解压缩，创建配置文件my.ini。默认解压文件中没有，我们可以新建完添加解压根目录下。

文件内容：

[mysql]

\# 设置mysql客户端默认字符集

default-character-set=utf8 

[mysqld]

\#设置3306端口

port = 3306 

\# 设置mysql的安装目录

basedir=C:\\mysql-8.0.18-winx64

\# 设置mysql数据库的数据的存放目录

datadir=C:\\mysql-8.0.18-winx64\\data

\# 允许最大连接数

max_connections=200

\# 服务端使用的字符集默认为UTF8

character-set-server=utf8

\# 创建新表时将使用的默认存储引擎

default-storage-engine=INNODB

3、以管理员打开命令行并进入到解压根目录/bin目录下，初始化MySQL数据目录，也就是我们配置的datadir进行初始化，执行命令管理员cmd> mysqld --initialize

然后会在data目录下生成一堆文件

4、再执行mysqld install，再执行net start mysql启动MySQL，一切ok

5、执行mysql -u root -p回车然后输入密码，即可登录mysql；获取初始化数据库随机密码，在data目录下生的文件有一个.err文件，这里面有初始化的密码。我们编辑打开此文件，找到密码。该文件命名规则是【电脑用户名.err】

6、修改随机密码为ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';

注：

1、删除数据库安装信息，要先关闭数据库服务，“net stop mysql” ，然后在“mysqld remove”，再进行之前的安装。

2、设置环境变量，可以直接启动服务“net start mysql ”，环境变量加到path中，路径为C:\mysql-8.0.18-winx64\bin

3、navicat 连接本地数据库报1251错误解决方案：

1）输入指令mysql -uroot -p然后再输入密码登录数据库

2）接下来更改密码规则

ALTER USER ‘root’@‘localhost’ IDENTIFIED WITH mysql_native_password BY ‘password’;

修改成自己想要设置的密码；

3）在对密码进行修改

ALTER USER ‘root’@‘localhost’ IDENTIFIED BY ‘123456’ PASSWORD EXPIRE NEVER;

最后刷新数据库

4）FLUSH PRIVILEGES;

没完成一步显示OK，即为修改成功

sql修改密码：1、mysql -u root -p  2、set password for root@localhost = ‘123456’;

# 查看局域网ip命令

查看局域网ip

for /L %i IN (1,1,254) DO ping -w 2 -n 1 59.1.3.%i

arp -a

# 删除多余启动项

方法一：

进入运行，输入msconfig点击确定

进入引导界面，点击你要删除的项次

方法二：

进入管理员运行页面

然后输入“bcdedit /enum”命令，查看各引导状态，在命令提示符里右键标记。

复制“标识符”或“resumeobject”大括号里面的内容，然后输入“bcdedit /delete”，右击粘贴后按回车键即可。bcdedit /delete {c1f3aa20-10b1-11e9-851b-b46bfc09523a}