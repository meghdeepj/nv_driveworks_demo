#!/usr/bin/env bash

# 添加用户和组权限，配置超级用户

deluser zs
addgroup --gid "$DOCKER_GRP_ID" "$DOCKER_GRP"
adduser --disabled-password --force-badname --gecos '' "$DOCKER_USER" \
    --uid "$DOCKER_USER_ID" --gid "$DOCKER_GRP_ID" 2>/dev/null
usermod -aG sudo "$DOCKER_USER"
usermod -aG video "$DOCKER_USER"
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# crack解决一个交叉编译错误
# sudo sed -i 's/ || defined(LINUX)//' /usr/local/driveworks/include/dw/core/system/NvMedia.h

pip3 config set global.trusted-host mirrors.xlab.gacrnd.com
pip3 config set global.index-url http://mirrors.xlab.gacrnd.com/repository/pypi/simple
sudo pip3 config set global.trusted-host mirrors.xlab.gacrnd.com
sudo pip3 config set global.index-url http://mirrors.xlab.gacrnd.com/repository/pypi/simple

# 更换国内源
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo sed -i 's/archive.ubuntu.com\/ubuntu/mirrors.xlab.gacrnd.com\/repository\/ubuntu-focal/' /etc/apt/sources.list
sudo sed -i 's/security.ubuntu.com\/ubuntu/mirrors.xlab.gacrnd.com\/repository\/ubuntu-focal/' /etc/apt/sources.list
sudo sed -i 's/ports.ubuntu.com\/ubuntu/mirrors.xlab.gacrnd.com\/repository\/ubuntu/' /etc/apt/sources.list
# sudo cp /gw_demo/tools/ros.key /usr/share/keyrings/ros-archive-keyring.gpg
# sudo echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://mirrors.tuna.tsinghua.edu.cn/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
sudo sed -i 's/packages.ros.org\/ros2\/ubuntu/mirrors.xlab.gacrnd.com\/repository\/ubuntu-ros2/' /etc/apt/sources.list.d/ros2-latest.list

# https://forums.developer.nvidia.com/t/bug-nvidia-container-runtime-csv-mode-cannot-create-sym-link-of-dir/252336
sudo ln -s /usr/local/driveworks-5.10 /usr/local/driveworks
sudo ln -s /usr/local/cuda-11.4 /usr/local/cuda-11
sudo ln -s /usr/local/cuda-11 /usr/local/cuda

# 检测是16.04还是18.04

# case "$(lsb_release -r | cut -f2)" in
#     16.04)
#         echo '
#         source /opt/ros/kinetic/setup.bash
#         ' >> "/home/${DOCKER_USER}/.bashrc"
#         ;;
#     *)
#         echo '
#         source /opt/ros/melodic/setup.bash
#         ' >> "/home/${DOCKER_USER}/.bashrc"
#         ;;
# esac

# 设置bashrc
cat /target/docker/scripts/.bashrc > "/home/${DOCKER_USER}/.bashrc"
# sourcing proj
echo '
source $PROJ_TOP_DIR/docker/scripts/target.bashrc
' >> "/home/${DOCKER_USER}/.bashrc"

# echo '
# genhtml_branch_coverage = 1
# lcov_branch_coverage = 1
# ' > "/home/${DOCKER_USER}/.lcovrc"

# Set user files ownership to current user, such as .bashrc, .profile, etc.
chown ${DOCKER_USER}:${DOCKER_GRP} /home/${DOCKER_USER}
ls -ad /home/${DOCKER_USER}/.??* | xargs chown -R ${DOCKER_USER}:${DOCKER_GRP}

# 配置一些设备最基本的属性

# setup GPS device
if [ -e /dev/novatel0 ]; then
  chmod a+rw /dev/novatel0
fi
if [ -e /dev/novatel1 ]; then
  chmod a+rw /dev/novatel1
fi
if [ -e /dev/novatel2 ]; then
  chmod a+rw /dev/novatel2
fi
if [ -e /dev/ttyACM0 ]; then
  chmod a+rw /dev/ttyACM0
fi

# setup camera device
if [ -e /dev/camera/obstacle ]; then
  chmod a+rw /dev/camera/obstacle
fi
if [ -e /dev/camera/trafficlights ]; then
  chmod a+rw /dev/camera/trafficlights
fi
