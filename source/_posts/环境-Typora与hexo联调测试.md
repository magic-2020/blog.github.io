---
title: Typora与hexo联调测试
date: 2020-03-21 20:11:55
tags:
	- 部署
typora-root-url: ./
---

## 标签使用

### 代码块

```
代码块
hello world！
```

### 代码

```
hello world!
```

### 图片插入

插入图片的技巧：

1）先设置Typora的图片根目录

<img src="/blog.github.io/images/image-20200322212424199.png" alt="image-20200322212424199" style="zoom:50%;" />

2）设置根目录为当前`.md`文件所在的目录，文档会在头部自动添加一段代码：

````
typora-root-url: ./
````

3)在当前的根目录下，添加文件夹路径 /blog.github.io/images

> 注：其中/blog.github.io为hexo的_config.yml文件夹中设置的URL的root路径，此路径必须设置，否则在GitHub中，不会有页面效果展示 

4)在图像全局设置中，设置成如下形式：

![image-20200322213221561](/blog.github.io/images/image-20200322213221561.png)

5）最后，不要忘了，将图片复制粘贴到文件夹 `source\images`中去

如此便可以顺利添加成功图片，并可以在github中的静态页面中展示成功。

![323323](/blog.github.io/images/323323.jpg)