echo "sourcing sdk.bashrc"
GW_SYS_ROOT="/drive/drive-linux/filesystem/targetfs"
XLAB_SYS_ROOT="/opt/xlab/sysroot"
# using ros2
export ROS2_HOME=/drive/drive-linux/filesystem/targetfs/opt/ros/foxy/
export PYTHONPATH=${ROS2_HOME}/lib/python3.8/site-packages
export PATH=${PATH}:${ROS2_HOME}/bin
# using protobuf
export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=cpp
# using cmake
export CMAKE_BUILD_PARALLEL_LEVEL=12
# selecting ros2
source ${GW_SYS_ROOT}/opt/ros/foxy/setup.bash
# source the prebuilt ros2 binary
# source ${GW_SYS_ROOT}/opt/ros/foxy-smacc2/target/colcon/install/local_setup.bash

# echo "the main setting is in following:"
# env | grep XLAB_
# env | grep ROS_
# env | grep RMW
# env | grep RCU
# env | grep FASTRTPS
