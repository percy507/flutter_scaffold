# 打包脚本使用手册

### 基本使用

入口文件 **build.sh**，使用 `chmod +x ./build.sh` 将其变为可执行文件

```bash
# 使用示例
# 参数1 指定打包环境
# 参数2 指定打包系统
# 参数3 指定打包的仓库分支
./build.sh --dev --android --branch=dev

# 详细参数请看
./build.sh --help
```

### 参数配置

- **可配置参数统一在 build_config.sh 文件中进行配置**

- 目前需要配置的参数有
  - 项目 gitlab 仓库地址
  - 获取仓库代码的某个开发人员的 access_token 名称和 token（可进入gitlab个人设置，选中左侧侧边栏 Access Tokens 进行配置）
  - 蒲公英分发平台的 API key
  - 钉钉群机器人 token

### 注意事项

- 第一次运行，可能时间较长，因为要下载安装 flutter SDK 及相关资源
- 仅在正式环境发版时修改项目版本号(pubspec.yaml 文件的 version 字段)
- 仅在正式环境发版时修改项目更新日志(CHANGELOG.md)
