---
title: 环境-工具-Hexo的目录结构
date: 2020-03-23 17:11:55
tags:
	- 工具
typora-root-url: ./
---
# 简单认识Hexo的目录结构

本文将简单介绍Hexo的目录结构。

## deploy后的目录结构

在执行过`Hexo deploy`命令之后，目录结构有所变化，新增了`.deploy_git`，`public`，`.gitignore`。

![308502938-5c6e6772c41c8_articlex](/blog.github.io/images/308502938-5c6e6772c41c8_articlex.png)

### _config.yml

初始化时自动创建。

用来配置博客相关的参数。具体参数设置，参照[配置|Hexo](https://hexo.io/zh-cn/docs/configuration)。

### node_modules 和 package.json

都是在初始化时自动创建。

`node_modules`用来存储已安装的各类依赖包。
`package.json`用来查看Hexo的版本以及相关依赖包的版本。

Hexo会默认安装：

- hexo：主程序
- hexo-deployer-git：实现git部署方式
- hexo-generator-archive：存档页面生成器
- hexo-generator-category：分类页面生成器
- hexo-generator-index：index生成器
- hexo-generator-tag：标签页面生成器
- hexo-renderer-ejs：支持EJS渲染
- hexo-renderer-marked：Markdown引擎
- hexo-renderer-stylus：支持stylus渲染
- hexo-server：支持本地预览，默认地址 localhost:4000

在使用过程中，尤其是更换主题时，需要安装其它的依赖包。比如：

- hexo-renderer-scss：支持scss渲染。Even主题需要安装此依赖包。

新安装的依赖包，也会保存在`node_module`文件夹下。

### scaffold

初始化时自动创建。

模板文件夹。包含`page`，`post`，`draft`三种模板，分别对应 页面、要发布的文章、草稿。

### themes

初始化时自动创建。

主题文件夹。每一个主题，都有一个单独的文件夹。默认主题为[landscape](https://github.com/hexojs/hexo-theme-landscape)。

这里值得注意的是，Hexo配置文件中的`language**参数**`的值，取决于每个主题文件夹（如landscape）下的`language**文件夹**`里的文件名。

### source ， public 和 .deploy_git

- source：资源文件夹。用来存放图片、Markdown文档（文章、草稿）、各种页面（分类、关于页面等）。
- public：将source文件夹里的Markdown文档，转换成index.html。再结合主题进行渲染，就是我们最终看到的博客。
- .deploy_git：将public文件夹的内容提交到Github后生成，内容与public文件夹基本一致。

这三者的关系大致是：source -> public -> .deploy_git

执行`hexo generate`，根据source，更新 public。
执行`hexo deploy`，根据public，更新 .deploy_git。

了解了这三个文件夹的关系，也就了解为什么自定义域名需要添加的 CNAME 文件要在 public 文件夹下创建了。