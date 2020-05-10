---
title: Kali安装零散记录
date: 2020-04-15 21:11:55
tags:
	安全
    Kali
typora-root-url: ./
---

# 更新

step01:

查看配置文件，默认设置的是官方更新源

root@kali:~# cat /etc/apt/sources.list
deb http://http.kali.org/kali kali-rolling main non-free contrib

step02:

更新系统

root@kali:~# apt-get update && apt -y full-upgrade

apt-get update //更新可用软件包列表

apt full-upgrade //通过卸载|安装|升级等方式来更新系统


step03:

Then after running apt -y full-upgrade, you may require a reboot before checking:

step04:

验证

root@kali:~# grep VERSION /etc/os-release
VERSION="2018.3"
VERSION_ID="2018.3"

或

root@kali:~# uname -a

## 附其它更新源：

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