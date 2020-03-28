---
title: 零散学习-git预览部署脚本
date: 2020-03-25 21:11:55
tags:
    杂
typora-root-url: ./
---

# git预览部署脚本

1）预览脚本：

````
cp -r source/_posts/blog.github.io/images/*   source/images/
hexo clean
hexo s -d
````

2)部署脚本

````
cp -r source/_posts/blog.github.io/images/*   source/images/
hexo clean
hexo g -d
````

3)git 分支备份文件并部署

````
hexo clean
cp -r source/_posts/blog.github.io/images/*   source/images/
git add -A
git commit -m '写文章的blog全部备份'
git pull --rebase github_blog github_blog
git push -u github_blog github_blog
hexo g -d
````

