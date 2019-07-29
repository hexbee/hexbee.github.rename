---
draft: false
title: "Git hooks post-receive"
date: 2019-04-27
categories:
- Tutorials
- Git
tags:
- Git
- git hooks
- shell
- post-receive
thumbnailImagePosition: left
thumbnailImage: //d1u9biwaxjngwg.cloudfront.net/chinese-test-post/vintage-140.jpg
---

最近学习Git hooks，发现hooks用起来非常实用和效率。分享一下经验。
<!--more-->

为什么最近要看git hooks相关的东西呢，主要是想通过远程提交博客的Markdown文件到服务器，然后利用脚本自动化生成Hugo的`public`目录。
本来想通过Jenkins来实现，但是比较折腾，最近发现还是用hooks比较省心省力。
<!-- toc -->

## 1. 检查Git版本

```sh
git version  # 有些hooks只有比较新的版本才支持
```

## 2. 准备post-receive脚本

```sh
vim post-receive  # 用shell写的
```

## 3. 部署post-receive脚本

```sh
cp post-receive /path/to/repo-name.git/hooks/  # 必须是裸仓库，post-receive只能部署在remote端
```

## 4. 验证

```sh
echo "111" > 111.txt
git add 111.txt
git commit -m "Add 111.txt"
git push  # remote端的post-receive自动被调用，完成自动生成或更新public
```

## 5. 补充post-receive

```sh
# 这是 post-receive 结合 at 命令的实现，供参考
at now + 2 minutes -f /path/to/repo-name.git/hooks/deploy.sh \
&& echo "[hooks/post-receive] deploy.sh will be called in 2 minutes"
```

## 6. 注意点

1. `at` 的参数`-f` 用于传入一个脚本
2. 传入的脚本`at`使用SHELL`/bin/sh`

## 7. 使用crontab 实现

- 安装cron

    ```sh
    sudo apt-get install -y cron
    ```

- 编辑任务脚本

    ```sh
    vim xxx.sh
    ```

- 开启定时任务

    ```sh
    crontab -e
    # * * * * * /bin/bash /path/to/xxx.sh
    ```

- 验证
