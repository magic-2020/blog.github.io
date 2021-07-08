---
title: hexo+GitHub的blog搭建
date: 2020-03-22 21:11:55
categories:
- 环境
tags:
- 部署
typora-root-url: ./
---

# hexo+GitHub的blog搭建

## 1、 环境准备：git、node.js、hexo、GitHub账号

1） 安装git、node.js软件到本地，下载exe安装文件，然后安装就可以

2） 查看git是否安装成功，在git bash（此后命令均在此输入）中输入 `git –version`

3） 查看hexo是否安装成功，输入 `hexo -v`

4） 注册github账号，并建立repository，注意一定要是公共的

<!-- more -->

## 2、 hexo搭建

1） 新建一个文件夹，并命令cd进入此文件夹

2） 开始安装Hexo，输入：`npm install hexo -g`

3） 检查hexo是否安装成功，输入：`hexo -v`

4） 初始化该文件夹，输入：`hexo init `（此后想重新搭建，从这一步开始就可以）看到后面的`“Start blogging with Hexo！”`就说明初始化好了

5） 输入`npm install`，安装所需要的组件

6） 安装好后，执行以下命令：（1）`hexo g #generate` 生成静态文件 （2）`hexo s #server` 启动服务器。默认情况下，访问网址为：` http://localhost:4000/`

## 3、 ssh配置 

1） 在Git Bash输入以下指令（任意位置点击鼠标右键），检查是否已经存在了SSH keys。

````
ls -al ~/.ssh
````

2） 如果不存在就没有关系，如果存在的话，直接删除.ssh文件夹里面所有文件：

![clip_image001](/blog.github.io/images/clip_image001.png)


3） 输入以下指令（邮箱就是你注册Github时候的邮箱）后，回车（不停回车，不用输入任何东西）：

````
ssh-keygen -t rsa -C angelen10@163.com
````

4） 进入GitHub，在设置中的在Settings sidebar那里，点击SSH keys，然后新增ssh

5） 在ssh中，粘贴`C:\Users\user\.ssh`下的`id_rsa.pub`文件中的所有内容

6） 在bash中输入   `ssh -T git@github.com `   验证是否连接成功

## 4、 _config.yml配置

1）在文档的最后的配置

````
deploy:
 type: git
 repository: git@github.com:GitHub用户名/repository名称.git
 branch: master
````

2）文档中URL的配置

````
url: 你的repository下的GitHub网址（是GitHub中repository的打开的网址，不是即将部署的你的博客的网址）
root: /blog.github.io
````

3）文档中site的配置

````
# Site
title: 标题
subtitle: 副标题
description: 描述
keywords: 
author: 
language: zh-CN
timezone: Asia/Shanghai
````

4）文档中，每行结尾要有**空格**，冒号后面要有**空格**

## 5、 同步GitHub

1） 执行：`npm install hexo-deployer-git –save` 安装`hexo-deployer-git`插件

2） `hexo d -g` 将文档部署到GitHub上

3） 打开GitHub中的网址，可以看到部署成功的blog

4）hexo同步常用命令：

````
 hexo g #generate 生成静态文件
 hexo s #server 启动服务器。在本地预览效果，默认情况下，访问网址为： http://localhost:4000/
 hexo d #deploy 部署网站同步到github。部署网站前，需要预先生成静态文件
 hexo clean #clean 清除缓存文件 (db.json) 和已生成的静态文件 (public)。
````

## 6、 设置主题

1）` git clone https://github.com/iissnan/hexo-theme-next themes/next`

2） 打开站点配置文件 `_config.yml`，找到 `theme `字段，并将其值更改为 `next`。

`theme: next`

3）设置语言为：`简体中文：zh-Hans`

4）**页面翻页显示出错**：

\themes\next\layout\_partials\pagination.swig中内容改为如下情况：

`````
{% if page.prev or page.next %}
  <nav class="pagination">
    {{
      paginator({
        prev_text: '<',
        next_text: '>',
        mid_size: 1
      })
    }}
  </nav>
{% endif %}
`````

5）**主页点击进去后报错**：

将配置文件\themes\next\layout\_partials\_config.yml里菜单设置中的 ||之前所有的空格删掉

![20200314090351328.PNG](/blog.github.io/images/20200314090351328.PNG)

6）**添加分类模块**：

​	1、新建一个分类页面

```cpp
$ hexo new page categories
```

​	2、你会发现你的`source`文件夹下有了`categorcies/index.md`，打开`index.md`文件将title设置为`title: 分类`

​	3、把文章归入分类只需在文章的顶部标题下方添加`categories`字段，即可自动创建分类名并加入对应的分类中

````
title: hexo+GitHub的blog搭建
date: 2020-03-22 21:11:55
categories:
- 环境
````

7）**添加标签模块**

​	1、新建一个标签页面

```cpp
$ hexo new page tags
```

​	2、你会发现你的`source`文件夹下有了`tags/index.md`，打开`index.md`文件将title设置为`title: 标签`
​	3、把文章添加标签只需在文章的顶部标题下方添加`tags`字段，即可自动创建标签名并归入对应的标签中

tags设置格式：

````
title: hexo+GitHub的blog搭建（一）
date: 2020-03-22 21:11:55
tags:
- 部署
typora-root-url: ./
````

8)**添加关于模块**

​	1、新建一个关于页面

```cpp
$ hexo new page about
```

​	2、你会发现你的`source`文件夹下有了`about/index.md`，打开`index.md`文件即可编辑关于你的信息，可以随便编辑。

## 7、添加阅读全文按钮

因为在你的博客主页会有多篇文章，如果你想让你的文章只显示一部分，多余的可以点击阅读全文来查看，那么你需要在你的文章中添加

```xml
<!--more-->
```

其后面的部分就不会显示了，只能点击阅读全文才能看

## 8、 显示当前浏览进度

修改`themes/next/_config.yml`，把 `false` 改为 `true`：

```yaml
# Back to top in sidebar
b2t: true

# Scroll percent label in b2t button
scrollpercent: true
```

## 9、 设置动态背景

在主题配置文件中找到`canvas_nest`，设置成`ture`就可以啦，当然假如你想要其他样式，那么只要设置该样式为`true`即可。

```yaml
# Canvas-nest
canvas_nest: true

# three_waves
three_waves: false

# canvas_lines
canvas_lines: false

# canvas_sphere
canvas_sphere: false

# Only fit scheme Pisces
# Canvas-ribbon
canvas_ribbon: false
```

##10、边栏头像下面日志链接错误

在\themes\next\layout\_macro\sidebar.swig中，
原代码49行：

````
<a href="{{ url_for(theme.menu.archives).split('||')[0] | trim }}">
````
修改为：
````
<a href="{{ url_for(config.archive_dir) | trim }}">
````

## 11、Next主题中文锚点失效

themes\next\source\js\src\post-details.js 文件中targetSelector 解析 UTF8 有问题

    var targetSelector = NexT.utils.escapeSelector(this.getAttribute('href'));
    <!-- 添加下面这行代码, 重新解析 URL ->
    targetSelector = decodeURI(this.getAttribute('href'))
    var offset = $(targetSelector).offset().top;
##12、主页文章添加阴影效果

打开`.\themes\next\source\css\_custom\custom.styl`，添加以下代码：

```css
// 主页文章添加阴影效果
.post {
    margin-top: 20px;
    padding: 20px;
    -webkit-box-shadow: 0 0 5px rgba(202, 203, 203, .5);
    -moz-box-shadow: 0 0 5px rgba(202, 203, 204, .5);
}
```

##13、修改底部标签样式

修改`.\themes\next\layout\_macro\post.swig`中文件，搜索`rel="tag">#`，将`#`替换成`<i class="fa fa-tag"></i>`。

![img](/blog.github.io/images/v2-81502a3337a5cbdd9905a03a5fb29160_720w.png)



效果如下



![img](/blog.github.io/images/v2-7d95c3799ee55a560af396f3eae14929_720w.jpg)

