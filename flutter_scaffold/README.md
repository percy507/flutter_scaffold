# flutter_scaffold

flutter 脚手架

### 使用脚手架

```bash
# 出于一些权限的原因，无法使用安装脚本进行安装。。。
# 暂时先使用下面的步骤进行安装

# clone
git clone http://xxx/flutter_scaffold.git ./project-name

# 进入项目目录
cd ./project-name

# 删除 .git 目录
rm -rf .git

# 新初始化一个仓库
git init

# 添加远程仓库
git remote add origin <remote-address>

# 修改代码
# 提交至远程仓库，完成初始化
git add .
git commit -m "init"
git push --set-upstream origin master --force
```

### 环境配置

```bash
# 编辑器
vscode

# 编辑器插件
Flutter   # 会自动安装Dart插件
Tabnine Autocomplete AI # AI插件，输入会智能提示
```

```bash
# java 环境配置
# 安装 JDK(由于brew的更新，以下命令可能会失效)
# 不推荐安装最新版本的jdk，因为最新版本的jdk环境下，使用Android-SDK中的命令行工具时，会发生各种报错
# 所以推荐使用 java8
brew cask install oracle-jdk                                        # 安装最新的版本(不推荐)
brew tap adoptopenjdk/openjdk && brew cask install adoptopenjdk8    # 安装java8

# 查看 java 版本
java -version

# 列出本地所有的 jvm
/usr/libexec/java_home -V
```

### flutterw

**本脚手架使用 `flutterw` 脚本来锁定 flutter 版本并替换默认的 flutter 命令，flutterw 已自动配置 flutter 相关地址或环境变量为国内源。**

**脚手架默认 flutter 版本: 1.22.5。**

如果需要更改版本，直接修改 `./flutterw` 文件的 `flutter_version` 变量即可。

```bash
# 如果 ./flutterw 无法执行，使用下面的命令将其变为可执行文件
chmod +x ./flutterw

# flutter 命令
./flutterw

# dart 命令
./flutterw dart

# flutter 命令帮助信息
./flutterw -h

# 查看 flutter 版本
./flutterw --version

# 查看设备信息
./flutterw devices

# 其他命令请查阅下方链接
# https://flutter.dev/docs/reference/flutter-cli
```

### 其他文档

[学习资料](./docs/学习资料.md)

[脚手架设计](./docs/脚手架设计.md)

[项目初始化配置](./docs/项目初始化配置.md)
