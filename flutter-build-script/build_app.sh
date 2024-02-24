#!/usr/bin/env bash

# -e exit immediately if a command exits with a non-zero status
# -x print command and it's arguments, then execute the command
set -e

path_build_script="$(cd $(dirname $0) && pwd)"

source "${path_build_script}/build_config.sh"】
source "${path_build_script}/build_utils.sh"

_log success "##################################################"
_log success "#"
_log success "#  欢迎使用 flutter build 脚本"
_log success "#  遇到任何问题，请联系: xxx@outlook.com"
_log success "#"
_log success "##################################################\n"

buildEnv=""            # 打包环境
mainFile=""            # 打包入口文件
version=""             # 1.2.1+2 由buildName和buildNumber构成
buildName=""           # 又称 versionNumber。安卓: versionName; iOS: CFBundleShortVersionString;
buildNumber=""         # 安卓: versionCode; iOS: CFBundleVersion;
updateLog=""           # 更新日志
onlineUrlForAndroid="" # 在线链接，安卓
onlineUrlForIOS=""     # 在线链接，iOS
buildSummary=""        # 打包信息汇总，用于钉钉机器人

path_project_dir="${path_build_script}/project" # 当前项目的根目录
buildEnv_dev="dev"
buildEnv_test="test"
buildEnv_show="show"
buildEnv_prod="prod"
mainFile_dev="${path_project_dir}/lib/main_dev.dart"
mainFile_test="${path_project_dir}/lib/main_test.dart"
mainFile_show="${path_project_dir}/lib/main_show.dart"
mainFile_prod="${path_project_dir}/lib/main_prod.dart"
flutter_build_mode="--debug"

build_output="${path_project_dir}/build_output"            # 打包导出目录
flutter="${path_project_dir}/flutterw"                     # 使用 flutterw
path_changelog="${path_project_dir}/CHANGELOG.md"          # 更新日志文件路径
path_pubspec="${path_project_dir}/pubspec.yaml"            # flutter项目配置文件路径
path_versionControl="${path_build_script}/.versionControl" # 记录build版本

# $1 打包环境
# $2 打包系统
function build_app() {
  local _env=$(echo $1 | sed "s/-//g")
  local _os=$(echo $2 | sed "s/-//g")
  local _branch=$(echo $3 | cut -d "=" -f2)

  # 计时, 环境变量 SECONDS 表示脚本已经运行的秒数
  SECONDS=0

  clone_project $_branch
  build_before
  init_build_env $_env
  set_build_version_and_updateLog $_os
  start_build $_os
  build_after $_os
}

# $1 打包分支
function clone_project() {
  local tmp_folder="${path_build_script}/tmp"
  local tmp_flutter_folder=""${tmp_folder}/.flutter""
  local temp_url=$(echo $gitlab_project_url | sed -E 's/^https?:\/\///')

  # 项目根目录
  if [[ ! -d $path_project_dir ]]; then
    _log success "mkdir -pv $path_project_dir"
    mkdir -pv $path_project_dir
  fi

  _log success "mv $path_project_dir $tmp_folder"
  mv $path_project_dir $tmp_folder

  # 克隆代码
  _log success "git clone http://${gitlab_token_name}:${gitlab_token}@${temp_url} --branch $1"
  git clone "http://${gitlab_token_name}:${gitlab_token}@${temp_url}" \
    --branch $1 \
    "${path_project_dir}"

  if [[ -d $tmp_flutter_folder ]]; then
    _log success "mv ${tmp_flutter_folder} ${path_project_dir}"
    mv ${tmp_flutter_folder} ${path_project_dir}
  fi

  _log success "rm -rf $tmp_folder"
  rm -rf $tmp_folder

  _log success "cd $path_project_dir"
  cd $path_project_dir
}

function build_before() {
  # 打包文件输出目录
  if [[ ! -d $build_output ]]; then
    mkdir -pv $build_output
  fi

  # 检测 flutterw
  if [[ ! -f $flutter ]]; then
    _log error "flutterw 文件不存在: $flutter"
    exit 1
  elif [[ ! -x $flutter ]]; then
    _log error "flutterw 文件不是可执行文件: $flutter"
    _log warning "可使用 \`chmod +x $flutter\` 命令将文件变为可执行文件"
    exit 1
  fi

  # 检测必备命令是否存在
  command_check "jq" "Install it use \`brew install jq\`"
  command_check "/usr/libexec/PlistBuddy"
  command_check "sed"
  command_check "perl"
  command_check "xcodebuild"
  command_check "xcrun"
  command_check "pod"
}

# $1 打包系统
function build_after() {
  # 修改 .versionControl 文件
  sed -i '' -e "s/$1=.*/$1=$version/" $path_versionControl
}

# $1 打包环境
function init_build_env() {
  if [[ "$1" == $buildEnv_dev ]]; then
    buildEnv=$buildEnv_dev
    mainFile=$mainFile_dev
  elif [[ "$1" == $buildEnv_test ]]; then
    buildEnv=$buildEnv_test
    mainFile=$mainFile_test
  elif [[ "$1" == $buildEnv_show ]]; then
    buildEnv=$buildEnv_show
    mainFile=$mainFile_show
    flutter_build_mode="--release"
  elif [[ "$1" == $buildEnv_prod ]]; then
    buildEnv=$buildEnv_prod
    mainFile=$mainFile_prod
    flutter_build_mode="--release"
  else
    _log error "init_build_env: 未知参数 $1"
    exit 1
  fi
}

# 版本更新策略:
#   仅在正式环境手动更改 pubspec.yaml 文件
#   其他环境直接 buildNumber 增加 1，利用 .versionControl 文件缓存 buildNumber
# 更新日志更新策略:
#   仅在正式环境手动更改 CHANGELOG.md 文件
# $1 打包系统
function set_build_version_and_updateLog() {
  version="$(grep 'version: ' $path_pubspec | sed 's/version: //')"
  buildName="$(echo $version | cut -d '+' -f 1)"
  buildNumber="$(echo $version | cut -d '+' -f 2)"
  buildNumber="${buildNumber:=1}"
  version="$buildName+$buildNumber"

  local is_first_set="false"

  if [[ ! -f $path_versionControl ]]; then
    is_first_set="true"
    echo -e "android=${version}\nios=${version}" >$path_versionControl
  fi

  local temp_version=$(cat $path_versionControl | grep "$1" | cut -d "=" -f2)
  local temp_buildName="$(echo $temp_version | cut -d '+' -f 1)"
  local temp_buildNumber="$(echo $temp_version | cut -d '+' -f 2)"

  if [[ $buildEnv != $buildEnv_prod ]]; then
    buildNumber=$((temp_buildNumber + 1))
  else
    if [[ $is_first_set == "false" ]]; then
      if [[ $buildName == $temp_buildName ]]; then
        _log error "生产环境发包: 检测到版本号与上次版本号相同，需要手动修改版本号"
        exit 1
      fi
    fi
  fi

  version="$buildName+$buildNumber"

  # 处理日志
  if [[ $buildEnv == $buildEnv_prod ]]; then
    # 生产环境，检测是否填写日志，从 CHANGELOG.md 文件中提取日志
    if ! grep -q "## ${buildName}" $path_changelog; then
      _log error "生产环境发包: 更新日志中未检测到本次版本号，请填写更新日志"
      exit 1
    fi

    if [[ $is_first_set == "false" ]]; then
      # 截取版本之间的日志
      updateLog=$(awk "/## $buildName/,/## $temp_buildName/" $path_changelog | sed -e "/^$/d" -e "/^##/d")
    else
      updateLog=$(sed -e "/^$/d" -e "/^##/d" $path_changelog)
    fi
  else
    updateLog="脚本自动构建，构建 number: $buildNumber"
  fi

}

# $1 打包系统
function start_build() {
  if [[ $1 == "android" ]]; then
    build_android
  elif [[ $1 == "ios" ]]; then
    build_ios
  else
    _log error "start_build: 未知参数 $1"
    exit 1
  fi
}

# $1 系统类型 android 或 ios
# $2 apk或ipa文件路径
function upload_to_pgyer() {
  _log success "正在上传到蒲公英..."

  local response="$(
    curl \
      -F "file=@$2" \
      -F "_api_key=${pgyer_api_key}" \
      -F "buildInstallType=1" \
      -F "buildUpdateDescription=${updateLog}" \
      ${pgyer_upload_api}
  )"

  local responseCode="$(echo $response | jq '.code')"

  if [[ $responseCode == "0" ]]; then
    _log success "蒲公英: 上传成功"
    _log success "${response}"

    local buildShortcutUrl="$(echo $response | jq -r '.data.buildShortcutUrl')"

    if [[ $1 == "android" ]]; then
      onlineUrlForAndroid="https://www.pgyer.com/${buildShortcutUrl}"
    elif [[ $1 == "ios" ]]; then
      buildSummaryForIOS="https://www.pgyer.com/${buildShortcutUrl}"
    else
      _log error "upload_to_pgyer \$1 参数错误"
      exit 1
    fi
  else
    _log error "蒲公英: 上传失败"
    _log error "${response}"
    exit 1
  fi
}

function build_common() {
  _log success "flutter clean"
  $flutter clean

  _log success "flutter packages get"
  $flutter packages get
}

function build_android() {
  build_common

  _log success "flutter build apk
    --target=$mainFile
    --build-name=$buildName
    --build-number=$buildNumber
    $flutter_build_mode"

  $flutter build apk \
    --target=$mainFile \
    --obfuscate \
    --split-debug-info=$build_output \
    --target-platform android-arm \
    --build-name=$buildName \
    --build-number=$buildNumber \
    $flutter_build_mode \
    --verbose

  _log success "flutter build apk success"

  fileName="app_${version}_$(date '+%Y%m%d%H%M').apk"
  output="$build_output/$fileName"
  original_apk="$(find 'build/app/outputs/flutter-apk' -name '*-*.apk' | head -n 1)"
  cp -r "${path_project_dir}/${original_apk}" $output

  if [[ $buildEnv == $buildEnv_prod ]]; then
    # TODO 上传至服务器（需要应用上传接口、应用更新信息接口）
    # 或者分发至指定的应用商店
    # 或者上传到阿里云 oss
    # https://gist.github.com/jsoendermann/fcec332031ff0baea824af972c983c93
    echo "上传至服务器"
  else
    upload_to_pgyer "android" $output
  fi

  output_summary "android" $output
  dd_robot_send "${buildSummary}"
}

function build_ios() {
  # build_common

  _log success "flutter build ios --target=$mainFile
    --target=$mainFile
    --build-name=$buildName
    --build-number=$buildNumber
    $flutter_build_mode"

  # $flutter build ios \
  #   --target=$mainFile \
  #   --obfuscate \
  #   --split-debug-info=$build_output \
  #   --build-name=$buildName \
  #   --build-number=$buildNumber \
  #   $flutter_build_mode \
  #   --verbose

  _log success "flutter build ios success"

  fileName="app_${version}_$(date '+%Y%m%d%H%M').ipa"
  output="$build_output/$fileName"

  build_ios_ipa $output

  if [[ $buildEnv == $buildEnv_prod ]]; then
    # TODO
    # 新上传方式
    # 验证并上传到App Store
    # APP专用密码，在AppleID账号的安全里生成和管理，此处altool上传IPA无法使用AppleID账号的密码，必须使用APP专用密码
    # 参考文章：https://www.jianshu.com/p/328adf860ad5

    # 验证 app
    _log success "xcrun altool --validate-app"
    xcrun altool \
      --validate-app \
      -f $IPA_PATH \
      -t iOS \
      -u "你的AppleId开发者账号" \
      -p "生成的APP专用密码"

    # 上传 app
    _log success "xcrun altool --upload-app"
    xcrun altool \
      --upload-app \
      -f $IPA_PATH \
      -t iOS \
      -u "你的AppleId开发者账号" \
      -p "生成的APP专用密码"

  else
    upload_to_pgyer "ios" $output
  fi

  output_summary "ios" $output
  dd_robot_send "${buildSummary}"
}

# $1 期望ipa文件的输出路径
function build_ios_ipa() {
  local xcodebuild_configuration="Release"
  local xcodebuild_target_name="Runner"

  local path_ios="${path_project_dir}/ios"
  local path_ios_build="${path_ios}/build"
  local path_archive="${path_ios_build}/${xcodebuild_target_name}.xcarchive"
  local path_export_options=""
  local path_adhoc_export_options="${path_build_script}/adhoc_exportOptions.plist"
  local path_appstore_export_options="${path_build_script}/appstore_exportOptions.plist"
  local output=$1

  cd $path_ios

  if [[ $buildEnv == $buildEnv_prod ]]; then
    path_export_options=$path_appstore_export_options
  else
    path_export_options=$path_adhoc_export_options
  fi

  # 清除 pod 缓存，重新装依赖
  _log success "rm -rf ${path_ios}/Pods"
  rm -rf "${path_ios}/Pods"
  _log success "pod cache clean --all"
  pod cache clean --all
  _log success "pod install --verbose"
  pod install --verbose

  # 清理工程
  _log success "xcodebuild: clean"
  xcodebuild clean -workspace ${xcodebuild_target_name}.xcworkspace \
    -scheme ${xcodebuild_target_name} \
    -configuration ${xcodebuild_configuration}

  # 归档
  _log success "xcodebuild: archive"
  xcodebuild archive -workspace ${xcodebuild_target_name}.xcworkspace \
    -scheme ${xcodebuild_target_name} \
    -configuration ${xcodebuild_configuration} \
    -archivePath ${path_archive}

  # 导出 ipa 文件
  _log success "xcodebuild: export ipa"
  xcodebuild -exportArchive \
    -archivePath ${path_archive} \
    -configuration ${xcodebuild_configuration} \
    -exportPath ${build_output} \
    -exportOptionsPlist ${path_export_options}

  # TODO 复制ipa文件名称待定
  local temp_ipa="${build_output}/*.ipa"

  # 判断导出ipa结果
  if [ -f $temp_ipa ]; then
    mv $temp_ipa $output
  else
    _log error "build_ios_ipa 失败"
    exit 1
  fi

  cd ..
}

# $1 系统类型 android 或 ios
# $2 apk或ipa文件路径
function output_summary() {
  local outputFile=$2                                     # apk或ipa文件路径
  local appName=""                                        # app 名称
  local appVersion=$version                               # app 版本
  local appSize="$(du -h $outputFile | awk '{print $1}')" # app 文件大小
  local bundleId=""                                       # bundle id
  local onlineUrl=""                                      # 在线链接
  local updateLog=$updateLog                              # 更新日志

  if [[ $1 == "android" ]]; then
    local apkInfo="$(aapt dump badging $outputFile)"

    appName=$(echo $apkInfo | grep "application: label" | perl -pe "s/^.*?label='(.*?)'.*$/\1/")
    bundleId=$(echo $apkInfo | grep "package: name" | perl -pe "s/^.*?name='(.*?)'.*$/\1/")
    onlineUrl=$onlineUrlForAndroid
  elif [[ $1 == "ios" ]]; then
    local tempFile="$PWD/build_temp.plist"

    unzip -p $outputFile Payload/Runner.app/Info.plist >$tempFile

    appName=$(/usr/libexec/PlistBuddy -c "Print :'CFBundleName'" $tempFile)
    bundleId=$(/usr/libexec/PlistBuddy -c "Print :'CFBundleIdentifier'" $tempFile)
    onlineUrl=$onlineUrlForIOS

    rm $tempFile
  else
    _log error "output_summary \$1 参数错误"
    exit 1
  fi

  _log success "\n------------------------------------------------------------------------------"
  _log success "🎉 Build Success~"
  _log success ""
  _log success "🚀 打包环境:   " "${buildEnv}"
  _log success "📅 打包耗时:   " "${SECONDS}s"
  _log success "🗂  输出目录:   " "${outputFile}"
  _log success ""
  _log success "🗳  应用名称:   " "${appName}"
  _log success "🦉 版本号:     " "${appVersion}"
  _log success "🧩 应用大小:   " "${appSize}"
  _log success "⛳️ Bundle ID:  " "${bundleId}"
  _log success "🌎 在线链接:   " "${onlineUrl}"
  _log success "📝 更新日志:   " "${updateLog}"
  _log success "------------------------------------------------------------------------------"

  buildSummary="🎉 Build Success~\n🚀 打包环境:   ${buildEnv}\n📅 打包耗时:   ${SECONDS}s\n\n🐈 应用名称:   ${appName}[$1]\n🦉 版本号:     ${appVersion}\n🧩 应用大小:   ${appSize}\n⛳️ Bundle ID:  ${bundleId}\n🌎 在线链接:   ${onlineUrl}\n📝 更新日志:   $(sed -e "s/\"/\`/g" <<<${updateLog})"
}

build_app $*
