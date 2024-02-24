# !/usr/bin/env bash

# /bin/bash -c "$(curl -fsSL http://xxxx/flutter_scaffold/raw/master/scripts/install.sh)"

echo -e "\n"
echo "############################################################################"
echo "# 欢迎使用 flutter 脚手架"
echo "############################################################################"
echo -e "\n"

projectName=""

while [[ ! $projectName =~ ^[a-zA-Z0-9_]+$ ]]; do
  read -p "请输入项目名称(只能包含英文大小写、数字、下划线字符): " projectName
  echo $projectName
done

echo "done: "
exit

# clone
git clone http://xxx/flutter_scaffold.git "./$projectName"

# 进入项目目录
cd "./$projectName"

# 删除 .git 目录
rm -rf .git

# 新初始化一个仓库
echo "git init"
git init

# 添加远程仓库
read -p "请输入远程仓库地址: " remoteAddress

git remote add origin "$remoteAddress"

echo "关联远程仓库完毕"
echo "请适当修改代码后，完成首次 commit"
