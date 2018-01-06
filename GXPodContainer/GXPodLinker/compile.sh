#!/bin/sh

# 出错了就退出脚本
set -e

# 要build的target名
target_Name=${PROJECT_NAME}

# 如果自定义了target名.就用自定义的
if [[ $1 ]]
then
target_Name=$1
fi

echo "***********孙广鑫: target_name: $1"

# 输出目录
output_folder="${SRCROOT}/lib"

# 创建输出目录，并删除之前的文件
rm -rf "${output_folder}"
mkdir -p "${output_folder}"

# 分别编译真机和模拟器版本
OLD_IFS="$IFS" 
IFS="-" 
xcodebuild -workspace ${target_Name}".xcworkspace" -scheme ${target_Name} ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos   clean build
xcodebuild -workspace "${target_Name}.xcworkspace" -scheme ${target_Name} ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphonesimulator  clean build

echo "**********孙广鑫: xcodebuild -target "${target_Name}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphonesimulator BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build"

# 合成模拟器和真机.a包
lipo -create "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/lib${target_Name}.a" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/lib${target_Name}.a" -output "${output_folder}/lib${target_Name}.a"



