# msd.sh
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)
## 本项目采用 [GPL v3](LICENSE) 许可证开源

一个从 **ModelScope（魔搭社区）** 来下载模型文件的下载器，为 Shell 脚本，使用 aria2 来下载模型文件

## 脚本依赖

| 依赖        | 版本 | 用途                                              |
|-------------|------|---------------------------------------------------|
| `GNU Bash`  | 4.0+ | **必需**，脚本运行环境                            |
| `curl`      | 不限 | **必需**，用于构建下载URL                         |
| `aria2c`    | 不限 | **必需**，用于从URL下载文件                       |
| `figlet`    | 不限 | 可选，装饰，用于在脚本开头输出ASCII名字，可注释掉 |

## 脚本特点
- 基于 aria2c ，支持分片下载，断点续传
- 自动解析 ModelScope 上的模型下载地址，确保下载正确文件
- 多参数，可自定义URL中的所有可变字段，以及下载目录，文件名

## 安装方法
如果你使用 Debian GNU/Linux 系发行版或者 Android 上的 Termux（APT Bootstrap），那么你可以添加我们的镜像源后直接通过 APT 安装，这是推荐的做法

### Termux
先添加仓库 GPG Key（需安装 gnupg）
```bash
curl -fsSL https://bluearchive-git.github.io/apt-mirror/bluearchive-git.gpg.key | gpg --dearmor > $PREFIX/etc/apt/trusted.gpg.d/bluearchive-git.gpg
```

写入软件包源配置
```bash
echo "deb https://bluearchive-git.github.io/apt-mirror/ termux main" >> $PREFIX/etc/apt/sources.list
```

更新源索引并安装 msd
```bash
pkg update
pkg install msd -y
```

### Debian GNU/Linux 系发行版
先添加仓库 GPG Key（需安装 gnupg）
```bash
curl -fsSL https://bluearchive-git.github.io/apt-mirror/bluearchive-git.gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/bluearchive-git.gpg
```
写入软件包源配置
```bash
echo "deb https://bluearchive-git.github.io/apt-mirror/ debian main" | sudo tee /etc/apt/sources.list.d/bluearchive.list
```
更新源索引并安装 msd
```bash
sudo apt update
sudo apt install msd -y
```

如果你想使用手动安装，那么有以下两种方法
使用 make
```bash
PREFIX=/usr/local make install
```
或者手动安装
```bash
chmod +x msd.sh
cp msd.sh /usr/local/bin/msd
```

## 使用方法
```bash
./msd.sh <模型仓库> <文件名> <参数>
```

## 参数列表

| 参数                          | 作用                   | 默认值   |
|-------------------------------|------------------------|----------|
| `模型仓库`                    | 指定模型仓库           | 必填     |
| `文件名`                      | 指定下载文件           | 必填     |
| --local-dir `目录`            | 指定下载目录           | .        |
| --name `文件名`               | 指定下载的文件名       | 原文件名 |
| --split `分片数`              | 指定分片数             | 1        |
| --server `单服务器最大连接数` | 指定单服务器最大连接数 | 1        |
| --rev `版本分支`              | 指定版本分支           | master   |

## 示例
下载 Qwen/Qwen2.5-0.5B-Instruct-GGUF 中的 Q4_K_M 量化版 GGUF，分成 128 份下载，单服务器最大连接 16，保存为 ~/models/qwen/model.gguf
```bash
msd Qwen/Qwen2.5-0.5B-Instruct-GGUF qwen2.5-0.5b-instruct-q4_k_m.gguf \
	--local-dir ~/models/qwen \
	--name model.gguf \
	--split 128 \
	--server 16
```

## 环境变量
脚本也可以通过环境变量来控值
```bash
REV=main SPLIT=128 SERVER_CONNECTION=16 ./msd.sh <REPO> <FILE>
```
不过日常使用更推荐使用参数控值

## 致谢
- [aria2](https://github.com/aria2/aria2) - 提供了一个强大的下载工具
- [ModelScope](https://modelscope.cn) - 提供了模型下载平台

作者：BlueArchive-Git
License: GPL v3.0
Copyright (C) 2026 BlueArchive-Git
