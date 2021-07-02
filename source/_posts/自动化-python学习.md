---
title: 自动化-python学习
date: 2020-03-25 21:11:55
categories:
- 自动化
tags:
- python
typora-root-url: ./
---

# python之爬虫

## pycharm使用

1、安装下载pycharm

2、新建项目，并设置选择exciting interpreter

![image-20200616214237415](/blog.github.io/images/image-20200616214237415.png)

<!-- more -->

## 环境

在有python2和python3的情况下，使用pip安装

````shell
pip install requests
pip list  //看一下是否成功安装了库
````

pip 失效，要重新安装pip

````shell
python -m pip install --upgrade pip --force-reinstall
然后再执行
pip install requests
````

## 教程

https://www.jianshu.com/p/e52e85a3ce48

https://zhuanlan.zhihu.com/p/26673214

https://blog.csdn.net/guanmaoning/article/details/80158554?utm_medium=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.nonecase&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.nonecase

## 过程中问题

1、中文乱码：

声明：`# coding: UTF-8`

# 类（oop，面向对象）

类是封装逻辑和数据的另一种方式

类的三个独到之处：

1、多重实例

2、通过继承进行定制

3、运算符重载