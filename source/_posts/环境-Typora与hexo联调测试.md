---
title: Typora与hexo联调测试
date: 2020-03-21 20:11:55
tags:
	- 部署
typora-root-url: ./
---

## Typore设置

### 打开路径设置

1）打开 文件 -->偏好设置

2）对通用设置中的启动选项、保存&恢复进行设置；设置如下图，可以打开文件时，打开的路径是常用的路径，而不需要每次都要寻找文件

![image-20210525165752513](/blog.github.io/images/image-20210525165752513.png)

### 图片插入

插入图片的技巧：

1）先设置Typora的图片根目录

在 文件 -->偏好设置-->图像中：进行如下图设置，路径设置为`./blog.github.io/images`

![image-20210525170511586](/blog.github.io/images/image-20210525170511586.png)

2）设置根目录为当前`.md`文件所在的目录，在头部添加一段代码：

````
typora-root-url: ./
````

3)在当前的根目录下，添加文件夹路径 /blog.github.io/images

> 注：其中/blog.github.io为hexo的_config.yml文件夹中设置的URL的root路径，此路径必须设置，否则在GitHub中，不会有页面效果展示 

4）最后，不要忘了，将图片复制粘贴到文件夹 `source\images`中去

如此便可以顺利添加成功图片，并可以在github中的静态页面中展示成功。

![323323](/blog.github.io/images/323323.jpg)