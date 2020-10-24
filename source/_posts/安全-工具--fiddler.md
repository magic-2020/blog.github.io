---
title: 抓包工具--fiddler
date: 2020-09-16 21:11:55
tags:
	- 安全
	- web渗透
	- 工具
typora-root-url: ./

---

# 抓包工具--fiddler

1、fiddler与burp作用相似，在安全测试中用于抓包等

2、下载：https://www.telerik.com/download/fiddler

3、Fiddler 是以代理web服务器的形式工作的，它使用代理地址:127.0.0.1，端口:8888，能支持HTTP代理的任意程序的数据包都能被Fiddler嗅探到，Fiddler的运行机制其实就是本机上监听8888端口的HTTP代理。当Fiddler退出的时候它会自动注销，这样就不会影响别的 程序。不过如果Fiddler非正常退出，这时候因为Fiddler没有自动注销，会造成网页无法访问。解决的办法是重新启动下Fiddler。

基础使用：

1、设置过滤：filters-->response type and size-->选择show only html

2、设置断点，进行截包：rulse-->automatic breakpoints -->before requests\after requests