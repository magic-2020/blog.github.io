---
title: dvwa靶机练习
date: 2021-02-20 21:11:55
tags:
	- dvwa
	- 安全
typora-root-url: ./
---

# dvwa靶机练习

## 密码

DVWA默认的用户有5个，用户名密码如下（一个足以）：

admin/password

gordonb/abc123

1337/charley

pablo/letmein

smithy/password

**获取用户名密码：**

sql盲注：https://blog.csdn.net/qq_37865996/article/details/85564334

**dvwa用户名密码重置：**Database Setup重置数据库

## 文件上传漏洞

https://www.cnblogs.com/sallyzhang/p/11906217.html

我用DVWA的文件上传来做练习，low模式没有任何验证，随便上传任意大小和类型的文件，现实中一般不会存在，故跳过，从medium模式开始。

进入页面后，我尝试传一个php文件上去(文件中有一段代码，用来列出上级目录的所有文件)，下图说明medium模式对文件类型进行了限制(在做这个练习此之前，我觉得做了类型限制就很安全了，反正其他类型都传不上去嘛~)，其实有一些方法可以绕过这种检测。

![img](/blog.github.io/images/832604-20191121154110169-1762395477.png)

 

### 修改Content-Type绕过文件类型检测(medium模式)

用Burp Suite抓包如下，content-type的类型是octet-stream。根据页面的报错，这个页面只能传jpg和png格式的图片。

![img](/blog.github.io/images/832604-20191121155432052-1363568961.png)

尝试把请求中content-type改为image/jpeg，再次发送请求，上传成功。说明medium模式只验证了Mime-Type，并没有验证文件本身(我传的还是php文件)

![img](/blog.github.io/images/832604-20191121155802522-780541502.png)

上传成功后访问3.php，代码被执行（**恶意代码被执行的风险有多大不用多说了**。。。）

![img](/blog.github.io/images/832604-20191121160947698-1523102346.png)

### 利用图片马绕过(high模式)

将security level修改为high，再次使用修改content-type的方法上传，发现上传失败，也就是说，high模式校验了上传文件本身到底是不是图片。接下来尝试用图片马来绕过。什么是图片马，简单来说就是在图片中嵌入了代码。。。步骤如下：

\1. 合成图片马

  找到一张货真价实的图片，然后将图片和php文件合成另一张图片，在命令行使用如下命令：

  copy 3.png /b + test.php /a y.png  (y.png就是图片马)

\2. 上传图片马

  用Burp Suite抓包看到我们的代码已经隐藏在图片里了，然后直接上传即可(因为文件格式是符合要求的)

  ![img](/blog.github.io/images/832604-20191121160805243-2090309796.png)

### 利用GIF89a绕过(high模式)

什么是GIF89a呢？先上传一张货真价实的gif图片，抓包如下图，图片的最开始几个字母就是GIF89a。个人理解GIF89a应该是gif文件的开头标志，只要有这个标志，就会被当做gif图片~

![img](/blog.github.io/images/832604-20191121161608362-449770532.png)

我将本地的php文件开头加上gif89a，然后把文件重命名为.jpg，进行上传并上传成功（实际上我上传的是一段代码）

**这里有个疑问**：明明只允许上传jpeg和png，为何gif图片也上传了呢？我的理解是：文件类型和后缀名是分开校验的。校验文件类型的函数只校验了是否是图片(没管是什么类型的图片)，而jpeg和png的校验只校验了后缀名。

![img](/blog.github.io/images/832604-20191121161958219-1406589924.png)

 

那有没有办法避免这种情况呢？有，把security level修改为impossible模式，图片马和GIF89a都不行了，因为impossible模式在high的基础上，还检测了上传文件是不是货真价实的图片~