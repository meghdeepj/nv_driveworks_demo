echo "sourcing zs.bashrc"
# xlab env
export XLAB_SYSROOT_DIR="/opt/xlab/sysroot"
export SYSROOT_DIR=$XLAB_SYSROOT_DIR
# using protobuf
export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=cpp
# using cmake
export CMAKE_BUILD_PARALLEL_LEVEL=12
# selecting ros2
source /opt/ros/foxy/setup.bash
# source /opt/ros/galactic/setup.bash
# ros2 common setting
export RCUTILS_COLORIZED_OUTPUT=1
# export RCUTILS_CONSOLE_OUTPUT_FORMAT="[{severity} {time}] [{name}]: {message} ({function_name}() at {file_name}:{line_number})"
# ros2 performance setting
export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
export ROS_LOCALHOST_ONLY=1
export ROS_DOMAIN_ID=110
# DDS performance setting
# export FASTRTPS_DEFAULT_PROFILES_FILE=$PROJ_TOP_DIR/tools/shm_fastdds.xml
# export RMW_FASTRTPS_USE_QOS_FROM_XML=1
# cuda
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

echo "the main setting is in following:"
env | grep XLAB_
env | grep ROS_
env | grep RMW
env | grep RCU
env | grep FASTRTPS
