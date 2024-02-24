#!/usr/bin/env bash

# $1 类型 error | success | warning
# $2 输出指定颜色的文本
# $3 输出默认颜色的文本
function _log() {
  error="\033[0;31m"   # error color
  success="\033[0;32m" # success color
  warning="\033[1;33m" # warning color
  NC="\033[0m"         # No Color

  if [[ -n $3 ]]; then
    echo -e "${!1}${2}${NC}${3}"
  else
    echo -e "${!1}${2} ${NC}"
  fi
}

# 检测命令是否存在
# $1 命令字符串
# $2 相关提示
function command_check() {
  if ! command -v $1 &>/dev/null; then
    _log error "$1 command not found"
    if [[ -n $2 ]]; then
      _log warning "$2"
    fi
    exit 1
  fi
}

# 钉钉机器人通知
# $1 文本消息
function dd_robot_send() {
  # https://developers.dingtalk.com/document/app/custom-robot-access
  local response=$(
    curl \
      "${dd_robot_send_api}?access_token=${dd_robot_token}" \
      -H 'Content-Type: application/json' \
      -d "{ \"msgtype\": \"text\", \"text\": { \"content\": \"$1\" }}"
  )

  local responseCode="$(echo $response | jq '.errcode')"

  if [[ $responseCode == "0" ]]; then
    _log success "钉钉: 消息发送成功"
    _log success "${response}"
  else
    _log error "钉钉: 消息发送失败"
    _log error "$1"
    _log error "${response}"
    exit 1
  fi
}
