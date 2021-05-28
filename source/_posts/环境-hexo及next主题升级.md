---
title: hexo及next主题升级
date: 2021-05-28 21:11:55
tags:
	- 部署
typora-root-url: ./
---

# hexo及next主题升级

1、进入blog文件夹

2、打开git bash

3、升级过时的依赖 `npm outdated`

4、修改文件加下的`package.json`文件版本，并删除`  node_modules`文件夹

5、在git中执行`npm install --save`

6、检查一下版本信息`hexo version`

7、更新 Hexo CLI ，先查看版本`npm outdated -g`并更新`npm install hexo-cli -g`

8、hexo在5.0之后把swig给删除了需要自己手动安装`npm i hexo-renderer-swig`

之后，如果之前能够正常运行，升级完以后，大概了是可以正常使用了，如果不行，那就是next主题有问题，需要根据问题解决问题
