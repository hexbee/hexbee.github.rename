---
draft: false
title: "Build a blog site by using Hugo and Nginx"
date: 2019-04-20
categories:
- Tutorials
- Static site generators
tags:
- hugo
- nginx
- docker
- markdown
thumbnailImagePosition: left
thumbnailImage: //d1u9biwaxjngwg.cloudfront.net/chinese-test-post/vintage-140.jpg
---

这篇文章是基于在`Google Cloud`上使用`Nginx`和`Hugo`搭建静态博客的经验而写。
<!--more-->

在学习Golang的过程中发现`Hugo`这个静态博客生成器，在试用后发现比`Hexo`使用更方便和快速。之前使用`Hexo`在`Github Pages`上部署过静态博客，但是没有记录下来。为了记录和分享，简单写一下搭建过程。
<!-- toc -->

## 1. 准备VPC

1. 自备梯子
2. 登录Google Cloud [传送门](https://cloud.google.com)
3. 创建一台ubuntu系统的vm

## 2. 安装docker

1. 登录 vm
2. 安装Docker: [传送门](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
3. 快速入门Docker:  [传送门](https://docs.docker.com/get-started/)

## 3. 部署nginx

1. 登录 vm
2. 部署nginx

    ```sh
    # 1. 创建存储卷
    docker volume create --name nginx01_conf
    docker volume create --name nginx01_www
    ```

    ```sh
    # 2. 创建运行一个新NGINX容器
    docker run --name nginx01 \
    -v nginx01_conf:/etc/nginx \
    -v nginx01_www:/usr/share/nginx/html \
    -p 80:80 \
    -p 443:443 \
    -d nginx:latest
    ```

    ```sh
    # 3. 查看所有容器当前状态
    docker ps -a
    ```

    ```sh
    # 4. 创建软连接
    ln -s /var/lib/docker/volumes/nginx01_conf/_data/ /root/docker/nginx01_conf  # 后面的目标路径随意
    ln -s /var/lib/docker/volumes/nginx01_www/_data/ /root/docker/nginx01_www    # 后面的目标路径随意
    ```

## 4. 安装静态博客生成器Hugo

Note: 其实有很多静态博客生成器 [传送门](https://staticsitegenerators.net/)

1. 登录 vm
2. 安装Hugo: [传送门](https://gohugo.io/getting-started/installing)

    ```sh
    sudo apt-get install hugo
    ```

3. 快速入门Hugo: [传送门](https://gohugo.io/getting-started/quick-start/)
4. 关联到nginx

    ```sh
    # 1. 生成 public
    hugo --theme=hugo-tranquilpeak-theme --baseURL=http://<your-blog-domain-name> -d /root/docker/nginx01_www/public/
    ```

    ```sh
    # 2. 改变 location root
    vim /root/docker/nginx01_conf/conf.d/default.conf
    server {
        listen       80;
        server_name  localhost;

        location / {
            root   /usr/share/nginx/html/public;
            index  index.html index.htm;
        }
    }
    ```

## 5. 绑定域名

1. 选域名 [传送门](https://freenom.com)
2. 绑定
3. 访问域名 - `http://<your-blog-domain-name>`

## 6. 发布新文章

```sh
# 1. 创建新文章
cd /root/docker/nginx01_www/
hugo new post/test.md
vim ./content/post/test.md
```

```sh
# 2. 生成 public
hugo --theme=hugo-tranquilpeak-theme --baseURL=http://<your-blog-domain-name> # 草稿不发布
或
hugo --theme=hugo-tranquilpeak-theme --baseURL=http://<your-blog-domain-name> -D # 草稿也发布
```
