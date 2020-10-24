---
title: 反射XSS和CORS漏洞组合拳
date: 2020-03-27 21:11:55
tags:
	- 安全
	- web渗透
typora-root-url: ./
---

# 反射XSS和CORS漏洞组合拳

## 1. 反射型XSS

反射型XSS一般存在于可直接将外部输入在浏览器输出的功能之中，例如搜索、文章分类、选择时间等参数直接输出在URL中。

一般来说小厂商对反射型XSS的关注并不多，早些年反射XSS很多平台都是不收的。只有一些大厂商对反射XSS还有一定关注度，但是因为反射XSS需要用户配合点击构造后的URL才可以实现攻击，利用手法上和危害都有限，所以一般都是按低危处理。反射XSS被用的最多的基本就是获取cookie，通过cookie欺骗登录受害者账号，一般也都是拿来钓鱼。

另外反射XSS和CSRF配合也是比较常见的组合拳打法，漏洞危害同样不小。

## 2. CORS漏洞(这个漏洞有点少)

### 2.1原理分析

CORS，跨域资源共享（Cross-origin resource sharing），是H5提供的一种机制，WEB应用程序可以通过在HTTP增加字段来告诉浏览器，哪些不同来源的服务器是有权访问本站资源的，当不同域的请求发生时，就出现了跨域的现象。

CORS漏洞存在的原因主要在于Access-Control-Allow-Origin参数配置失误，允许非同域站点访问本站资源。

### 2.2漏洞特征

利用burpsuite可以很方便的帮助我们测试网站是否可能存在CORS跨域漏洞。

**a.为每个请求自动加上Origin头**

![708977_AQPRA4GB74BTE4D](/blog.github.io/images/708977_AQPRA4GB74BTE4D.jpg) 

重放后可以看到靶机返回`Access-Control-Allow-Origin: foo.example.org`，且成功获取到数据，则证明存在CORS跨域

 

![708977_T9MVQPJMP3M35V4](/blog.github.io/images/708977_T9MVQPJMP3M35V4.jpg)

**b.在HTTP history中筛选可能存在CORS跨域的请求。**

只需在过滤条件中输入：

1. Access-Control-Allow-Origin: foo.example.org 

2. Access-Control-Allow-Credentials: true 

![708977_DWBGTZJV6UUJE2R](/blog.github.io/images/708977_DWBGTZJV6UUJE2R.jpg) 

另外需要注意的是如果服务器配置为：

1. Access-Control-Allow-Origin: * 

2. Access-Control-Allow-Credentials: true 

不能证明漏洞存在，因为浏览器会自动拦截掉非认证域的请求。

### 2.3漏洞利用

假设用户在网站foo.com处于登录状态，同时用户又点击了我们配置好的链接evil.com。

evil.com的网站向foo.com这个网站发起请求获取敏感数据，那么浏览器能否获取到foo.com中的敏感数据完全取决于foo.com配置

如果foo.com配置了Access-Control-Allow-Origin为允许接受跨域请求，则我们的evil.com就能获取到敏感数据，否则浏览器会因为同源策略接收不到敏感数据。

关于CORS漏洞，可使用开源工具CrossSiteContentHijacking验证

![708977_YJR3X28YDYH53CB](/blog.github.io/images/708977_YJR3X28YDYH53CB.jpg)



 ![708977_8GP7MHW6REY765P](/blog.github.io/images/708977_8GP7MHW6REY765P.jpg)

 

## 3. 鸡肋XSS和CORS组合拳

以KEY师傅的Dorabox靶场<span style='color:red'>（注意这个靶场会被win10判断为病毒，在虚拟机中运行）</span>>模拟漏洞利用，首先验证反射型XSS存在。

![708977_UB2FZNK4MP6X9UN](/blog.github.io/images/708977_UB2FZNK4MP6X9UN.jpg) 

然后CORS也同时存在，假设传递了敏感参数

![708977_2M649ZKVA78MX94](/blog.github.io/images/708977_2M649ZKVA78MX94.jpg) 

因为CORS跨域资源获取漏洞存在，那么我们可以通过让用户点击我们自己服务器上搭建的payload环境，获取到敏感数据，但是很明显这样的漏洞利用姿势成功的概率太小，这年头隔壁卖烤红薯的大爷都知道不要点陌生链接了，所以我们需要反射XSS的配合。

首先我们构造能够通过CORS跨域获取到敏感数据的JavaScript代码，类似于这样：

```
<script>  
function cors() {    
	var xhttp = new XMLHttpRequest();    
	xhttp.onreadystatechange = function() {      
		if (this.status == 200) {      
			alert(this.responseText);       
			document.body.innerHTML = this.responseText;      
		}    
	};     
	xhttp.open("GET", "http://localhost:801/DoraBox/csrf/userinfo.php", true);    
	xhttp.withCredentials = true;    
	xhttp.send();  
}  
cors();  
</script>  
```

简单分析一下，首先创建了一个cors()函数，这个函数首先判断当前的访问状态，如果是正常访问(即状态码为200)，则获取http://localhost:801/DoraBox/csrf/userinfo.php文件的body下的全部内容(也可以根据ID获取)并弹框展示出来。<span style="color:red">(用例注意网址的正确性)</span>>

现在我们只需要把反射XSS的payload替换为利用CORS跨域获取敏感信息的payload即可：

![708977_G2CMKDHMHZJHKGW](/blog.github.io/images/708977_G2CMKDHMHZJHKGW.jpg) 

程序成功执行。



## 总结

至此，反射XSS和CORS配合成功获取到用户敏感数据，虽然同样需要用户点击才能触发，但是漏洞危害足够大，如果是一些大厂的有敏感信息的站点，一般都会给高危。其实漏洞挖掘的乐趣就在于不断的发掘有趣的利用姿势，在遇到一些看似“鸡肋”的漏洞时，可以不用忙着提交，多思考一下是否可以和其他漏洞形成组合拳，这样技术才会有上升的空间，漏洞危害也会因此而提高，相应的白帽子能获得的收益也最大。

注：本文首发自云众可信