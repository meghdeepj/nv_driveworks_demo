#!/bin/sh
# 重命名文件DWCGF为前缀的

# To rename files only:
# find /your/target/path/ -type f -exec rename 's/special/regular/' '{}' \;

# To rename directories only:
# find /your/target/path/ -type d -execdir rename 's/special/regular/' '{}' \+

# To rename both files and directories:
# find /your/target/path/ -execdir rename 's/special/regular/' '{}' \+

OLD_NAME=CameraDriver
NEW_NAME=ImagePipe

find ./ -type f -exec rename 's/DWCGFCameraDriver/DWCGFImagePipe/' '{}' \;
rm ../schedule/*.yaml
rm ../schedule/*.stm
