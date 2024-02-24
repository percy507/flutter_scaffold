#!/usr/bin/env bash

path_build_script="$(cd $(dirname $0) && pwd)"

source "${path_build_script}/build_config.sh"
source "${path_build_script}/build_utils.sh"

build_app="${path_build_script}/build_app.sh"

if [[ ! -x $build_app ]]; then
  chmod +x "$build_app"
fi

function build_help() {
  echo "Usage: ./build.sh [--env] [--os] [--branch=master]"
  echo
  echo "options:"
  echo "--env                 打包环境: --dev 开发环境"
  echo "                               --test 测试环境"
  echo "                               --show 演示环境"
  echo "                               --prod 生产环境"
  echo "--os                  打包系统: --android 安卓"
  echo "                               --ios iOS"
  echo "--branch=<branch>     打包分支"
  echo "--help        输出帮助文档"
  echo
  echo "示例: ./build.sh --dev --android --branch=v1.2"
}

if [[ $1 == "--help" ]]; then
  build_help
  exit
fi

list_env=(
  "--dev"
  "--test"
  "--show"
  "--prod"
)
list_os=(
  "--android"
  "--ios"
)

if ! printf '%s\n' "${list_env[@]}" | grep -q -e "^$1$"; then
  _log error "--env 参数错误，可选值为 [ --dev | --test | --show | --prod ]"
  dd_robot_send "Build failed~"
  exit 1
fi

if ! printf '%s\n' "${list_os[@]}" | grep -q -e "^$2$"; then
  _log error "--os 参数错误，可选值为 [ --android | --ios ]"
  dd_robot_send "Build failed~"
  exit 1
fi

if [[ ! $3 =~ ^--branch=.+$ ]]; then
  _log error "--branch 参数错误"
  dd_robot_send "Build failed~"
  exit 1
fi

# $1 打包环境
# $2 打包系统
$build_app $*

# 打包失败
if [[ "$?" != "0" ]]; then
  dd_robot_send "Build failed~"
fi
