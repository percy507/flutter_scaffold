#!/usr/bin/env bash

################################################################
#
# 本文件不做任何事情，仅显示一些配置参数的说明，以及暂时不会用到的代码
#
################################################################

# flutter 三种构建模式
# --debug 默认模式。支持所有的调试能力，相比其他模式，性能会有所降低
# --profile 保留一部分调试能力，用来分析app性能
# --release 应用得到最大的优化，不可被调试

# xcodebuild -configuration
# Debug – Used for running the environment locally for testing by the development team if needed.
# Release – This is the configuration that will archive the application to be built locally or by CI.

function choose_build_version() {
  version="$(grep 'version: ' $pubspec_path | sed 's/version: //')"
  buildName="$(echo $version | cut -d '+' -f 1)"
  buildNumber="$(echo $version | cut -d '+' -f 2)"
  buildNumber="${buildNumber:=1}"

  PS3='请选择app版本变更方式: '
  options=(
    "版本不变(buildName不变，buildNumber递增)"
    "小版本自增(buildName小版本递增，buildNumber重置为1)"
    "手动输入版本(buildName手动输入，buildNumber重置为1)"
    "退出"
  )
  select opt in "${options[@]}"; do
    case $opt in
    "版本不变(buildName不变，buildNumber递增)")
      buildNumber=$((buildNumber + 1))
      break
      ;;
    "小版本自增(buildName小版本递增，buildNumber重置为1)")
      buildName="$(echo $buildName | perl -pe 's/^(\d+\.\d+\.)(\d+)$/$1.($2+1)/e')"
      buildNumber="1"
      break
      ;;
    "手动输入版本(buildName手动输入，buildNumber重置为1)")
      buildName=""

      while ! [[ $buildName =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; do
        read -p "请输入版本号(示例: 1.2.33): " buildName
      done

      buildNumber="1"
      break
      ;;
    "退出")
      exit
      ;;
    *)
      _log error "请输入有效的序号"
      ;;
    esac
  done

  version="$buildName+$buildNumber"
}

function input_update_log() {
  echo "请输入更新日志(空行回车结束):"
  while read log; do
    if [[ -z $log ]]; then
      break
    fi

    updateLog="${updateLog}\n${log}"
  done
}

function after_build() {
  # 修改 pubspec.yaml 版本号
  sed -i '' -e "s/^version.*$/version: $version/g" $pubspec_path

  # 修改 CHANGELOG.md
  local insertText="## ${version}\n${updateLog}\n\n"
  echo -e "${insertText}$(cat $changelog_path)" >$changelog_path
}
