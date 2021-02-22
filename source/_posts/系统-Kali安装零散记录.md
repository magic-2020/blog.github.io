---
title: Kali安装相关问题
date: 2020-04-15 21:11:55
tags:
	- 安全
	- Kali
typora-root-url: ./
---

# 系统更新

**1、查看配置文件，默认设置的是官方更新源**

root@kali:~# cat /etc/apt/sources.list
deb http://http.kali.org/kali kali-rolling main non-free contrib

**2、更新系统**

root@kali:~# apt-get update && apt -y full-upgrade（2019年的命令）

或者：apt-get update && apt-get upgrade && apt-get clean（2020年的命令）

apt-get update //更新可用软件包列表

apt full-upgrade //通过卸载|安装|升级等方式来更新系统

**3、重启**

**4、验证**

root@kali:~# grep VERSION /etc/os-release
VERSION="2018.3"
VERSION_ID="2018.3"

或

root@kali:~# uname -a

# 附其它更新源：

#中科大
deb http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib
deb-src http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib

#阿里云
deb http://mirrors.aliyun.com/kali kali-rolling main non-free contrib
deb-src http://mirrors.aliyun.com/kali kali-rolling main non-free contrib

#清华大学
deb http://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free

#浙大
deb http://mirrors.zju.edu.cn/kali kali-rolling main contrib non-free
deb-src http://mirrors.zju.edu.cn/kali kali-rolling main contrib non-free

#东软大学
deb http://mirrors.neusoft.edu.cn/kali kali-rolling/main non-free contrib
deb-src http://mirrors.neusoft.edu.cn/kali kali-rolling/main non-free contrib

#官方源
deb http://http.kali.org/kali kali-rolling main non-free contrib
deb-src http://http.kali.org/kali kali-rolling main non-free contrib



# Linux常用命令：

1、查看ip： ifconfig -a

2、查看安装了哪些软件： rpm -qa

3、vim 的快捷使用方式

​	1）在命令模式下输入set nu，展示文本行号

​	2）在命令行模式下输入字符v（小写），便可以进入按字符选择模式，通过h、i、j、k键移动光标选择要进行复制的字符串。

​	3）完成选择后按下y键进行复制，将鼠标移动到最后一行，按下p执行粘贴操作就完成了对选择的字符串部分完成了按字符复制与粘贴操作。

4、进入root： sudo su



# kalilinux安装中文输入法 安装fcitx,小企鹅输入法

1、命令来安装：

```
apt-get install fcitx-table-wbpy ttf-wqy-microhei ttf-wqy-zenhei
```

2、启用：

````
fcitx
````

3、设置环境变量：

````
export XMODIFIERS="@im=YOUR_XIM_NAME"
vim ~/.bashrc 
其中输入：
export XMODIFIERS="@im=fcitx"
export XIM=fcitx
export XIM_PROGRAM=fcitx
````

# 卸载输入法

````shell
sudo apt-get  purge  sogoupinyin #卸载搜狗
sudo apt-get purge  fcitx  #卸载fcitx
sudo apt-get autoremove 
````

# 清理垃圾

```shell
sudo apt-get autoclean               # 清理旧版本的软件缓存
sudo apt-get clean                      # 清理所有软件缓存
sudo apt-get autoremove           # 删除系统不再使用的孤立软件
```

# dpkg：警告：无法找到软件包 XXXX 问题解决(不一定有效)

在apt-get install 安装一个新包时 先回去检查`/var/lib/dpkg/info/`目录下的已安装包的配置文件信息；如果发现有已经安装的应用 的配置文件信息不在info目录下 就会提示这个错误

 所以这个时候我们 可以通过：

````shell
sudo dpkg --configure -a
````

然后通过：

````shell
dpkg -l | grep ^ii | awk '{print $2}' | grep -v XXX | xargs sudo aptitude reinstall 
````

重新获取包内容配置信息 ，这样一步步重新安装下去 很快就可以解决这个问题了

二.当然也还有第二种方法，那就是通过：

````shell
sudo apt-get --reinstall install  `dpkg --get-selections | grep '[[:space:]]install' | cut -f1`
````

来重新安装全部软件，会全部刷新info目录 不过这个方法就要多花点时间去等了

# 最新的kali版本为kali2020的登录密码

安装后很多用户还是直接使用之前的默认root账户

账户：root 密码：toor

但是最新的kali2020已经改变安全策略，默认的账户名和密码如下：

账户名：kali

密码：kali

如果想切换为root账户模式，建议使用以下命令操作

sudo su

然后输入默认密码kali就切换到root账户了。

![img](/blog.github.io/images/20200224113147596.png)

# 解决kali linux出现正在设定软件包 无法操作的问题

出现正在设定软件包什么鬼

直接tab+enter即可

![img](/blog.github.io/images/20180316183425080)

# 设置语言

1)默认语言选择

dpkg-reconfigure locales　　　　 //命令注意：如果是root用户可直接执行dpkg-reconfigure locales命令，如果是kali用户则需先切换成root用户登陆再进行执行

进入选择语言的图形化界面之后，（空格是选择，Tab是切换）
使用空格键将zh_CN.GBK_GBK 和 zh-CN.UTF-8.UTF-8其两项勾选上，勾选后用Tab键把光标移动到在<0k>处按下空格

![img](/blog.github.io/images/2038314-20200515165445349-606519698.png)

在此处选择zh_CN.UTF-8字符编码，在<0k> 处按空格键进行确认 ，并完成相关配置操作

![img](/blog.github.io/images/2038314-20200515165453644-20904254.png)

 

(2)更新一下系统，并重新启动，界面字体转为中文

# 安装ibus中文输入法

Ctrl+alt+t 调出命令行，输入：apt install ibus ibus-pinyin
必须安装：zenity
接着输入：apt install zenity
再输入：im-config
安装完成后：ibus-setup
如果输入法没有及时切换，先重启系统，然后在试，如果依旧不行，再根据提示进行文件配置

super键基本上就在键盘左下方Ctrl键和Alt键中间，大都为Windows标志，又被称为Windows键

# kali最新的系统任务栏调节

选择水平模式，不锁定面板，然后拖动任务栏到页面最下方，再锁定面板，kali系统的任务栏和win系统的位置即可一样都在页面下方

![image-20210215213001984](/blog.github.io/images/image-20210215213001984.png)

# 修改系统时间

(1) 在终端输入命令tzselect
(2) 然后再依次选择：Asia-->China-->Beijing Time--Yes（此处根据提示选择相应的数字）
(3)2、修改配置文件
在终端中依次输入以下命令,然后重启

````
echo "ZONE=Asia/Shanghai" >> /etc/sysconfig
rm -f /etc/localtime # 链接到上海时区文件
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
````