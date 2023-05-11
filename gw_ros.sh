#!/usr/bin/env bash

#=================================================
#                   ros环境自动化脚本
#=================================================

# 颜色
BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[32m'
WHITE='\033[34m'
YELLOW='\033[33m'
NO_COLOR='\033[0m'

GW_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"
# GW_ROS_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd -P )"
GW_ROS_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/packages" && pwd -P )"
GW_SYS_ROOT="/drive/drive-linux/filesystem/targetfs"
if [ ! -d "$GW_SYS_ROOT" ];then
  GW_SYS_ROOT=""
fi

function source_ga_base() {
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  cd "${DIR}"

  source ${DIR}/docker/scripts/gw_base.sh
  source ${GW_SYS_ROOT}/opt/ros/${GW_ROS_DIST}/setup.bash
  source ${GW_SYS_ROOT}/opt/ros/${GW_ROS_DIST}-smacc2/target/colcon/install/local_setup.bash
}

function ga_check_system_config() {
  # check docker environment
    # 检查操作系统规格是否满足要求, 设置一些变量
  # check operating system
  OP_SYSTEM=$(uname -s)
  case $OP_SYSTEM in
    "Linux")
      echo "System check passed. Build continue ..."
      ;;
    *)
      error "Unsupported system: ${OP_SYSTEM}."
      error "Please use Linux, we recommend Ubuntu 20.04."
      exit 1
  esac

  # 检测是20.04还是18.04
  case "$(lsb_release -r | cut -f2)" in
      20.04)
        GW_ROS_DIST="foxy"
        ;;
      22.04)
      GW_ROS_DIST="humble"
        ;;
      *)
      error "Unsupported ubuntu distro"
      error "Please use Linux, we recommend Ubuntu 20.04."
      exit 1
  esac
}

function check_machine_arch() {
  # the machine type, currently support x86_64, aarch64
  MACHINE_ARCH=$(uname -m)

}

#=================================================
#              Build functions
#=================================================

function build_dbg() {
  info "Start building, please wait ..."

  info "Building on $MACHINE_ARCH..."

  info "Building with $JOB_ARG for $MACHINE_ARCH"

  cd ${GW_ROS_ROOT_DIR}
  export GPUAC_COMPILE_WITH_CUDA=1
  # --force-cmake
  info "colcon ${LOG_ARG} build ${COLCON_ARG}   ${JOB_ARG} ${PACKAGE_ARG} ${CMAKE_OPT} ${CROSS_OPT} -DCMAKE_BUILD_TYPE=Debug"
  colcon ${LOG_ARG} build ${COLCON_ARG}   ${JOB_ARG} ${PACKAGE_ARG} ${CMAKE_OPT} ${CROSS_OPT} -DCMAKE_BUILD_TYPE=Debug
  if [ ${PIPESTATUS[0]} -ne 0 ]; then
    fail 'Build failed!'
  fi
  info "please source ./colcon/install/setup.bash"
  cd -
  success 'build passed!'
}

function build_rel_dbg() {
  info "Start building, please wait ..."

  info "Building on $MACHINE_ARCH..."

  MACHINE_ARCH=$(uname -m)
  info "Building with $JOB_ARG for $MACHINE_ARCH"

  cd ${GW_ROS_ROOT_DIR}
  export GPUAC_COMPILE_WITH_CUDA=1
  export CMAKE_BUILD_PARALLEL_LEVEL=$(($(nproc)-2))
  # --force-cmake
  info "colcon ${LOG_ARG} build ${COLCON_ARG}   ${JOB_ARG} ${PACKAGE_ARG} ${CMAKE_OPT} ${CROSS_OPT} -DCMAKE_BUILD_TYPE=RelWithDebInfo"
  colcon ${LOG_ARG} build ${COLCON_ARG}   ${JOB_ARG} ${PACKAGE_ARG} ${CMAKE_OPT} ${CROSS_OPT} -DCMAKE_BUILD_TYPE=RelWithDebInfo
  if [ ${PIPESTATUS[0]} -ne 0 ]; then
    fail 'Build failed!'
  fi
  info "please source ./install/setup.bash"
  cd -
  success 'build passed!'
}

# https://colcon.readthedocs.io/en/released/user/installation.html
function build_rel() {
  info "Start building, please wait ..."

  info "Building on $MACHINE_ARCH..."

  info "Building with $JOB_ARG for $MACHINE_ARCH"

  cd ${GW_ROS_ROOT_DIR}
  export GPUAC_COMPILE_WITH_CUDA=1
  # --force-cmake
  info "colcon ${LOG_ARG} build ${COLCON_ARG} ${INSTALL_ARG} ${JOB_ARG}  ${PACKAGE_ARG}  ${CMAKE_OPT} ${CROSS_OPT} -DCMAKE_BUILD_TYPE=Release"
  colcon ${LOG_ARG} build ${COLCON_ARG} ${INSTALL_ARG} ${JOB_ARG}  ${PACKAGE_ARG} ${CMAKE_OPT} ${CROSS_OPT} -DCMAKE_BUILD_TYPE=Release

  # --packages-up-to
  if [ ${PIPESTATUS[0]} -ne 0 ]; then
    fail 'Build failed!'
  fi
  info "please source ./install/setup.bash"
  cd -
  success 'build passed!'
}

function build_rel_native() {
  info "Start building, please wait ..."

  info "Building on $MACHINE_ARCH..."

  info "Building with $JOB_ARG for $MACHINE_ARCH"

  cd ${GW_ROS_ROOT_DIR}
  export GPUAC_COMPILE_WITH_CUDA=1
  # --force-cmake
  info "colcon ${LOG_ARG} build ${COLCON_ARG} ${INSTALL_ARG} ${JOB_ARG}  ${PACKAGE_ARG}  ${CMAKE_OPT} -DCMAKE_BUILD_TYPE=Release"
  colcon ${LOG_ARG} build ${COLCON_ARG} ${INSTALL_ARG} ${JOB_ARG}  ${PACKAGE_ARG} ${CMAKE_OPT} -DCMAKE_BUILD_TYPE=Release

  # --packages-up-to
  if [ ${PIPESTATUS[0]} -ne 0 ]; then
    fail 'Build failed!'
  fi
  info "please source ./install/setup.bash"
  cd -
  success 'build passed!'
}

function build() {
  info "Start building, please wait ..."

  info "Building on $MACHINE_ARCH..."

  info "Building with $JOB_ARG for $MACHINE_ARCH"

  cd ${GW_ROS_ROOT_DIR}
  export GPUAC_COMPILE_WITH_CUDA=1
  # --force-cmake
  info "colcon ${LOG_ARG} build ${COLCON_ARG} ${INSTALL_ARG} ${JOB_ARG} ${PACKAGE_ARG} ${CMAKE_OPT} ${CROSS_OPT}"
  colcon ${LOG_ARG} build ${COLCON_ARG} ${INSTALL_ARG} ${JOB_ARG} ${PACKAGE_ARG} ${CMAKE_OPT} ${CROSS_OPT}

  # --packages-up-to
  if [ ${PIPESTATUS[0]} -ne 0 ]; then
    fail 'Build failed!'
  fi
  info "please source ./install/setup.bash"
  cd -
  success 'build passed!'
}

# 编译测试检查
function check() {
  bash $0 build && bash $0 "test" && bash $0 lint

  if [ $? -eq 0 ]; then
    success 'Check passed!'
    return 0
  else
    fail 'Check failed!'
    return 1
  fi
}

function warn_proprietary_sw() {
  echo -e "${RED}all rights reserved, ga_team.${NO_COLOR}"
}

function run_unit_test() {

  info "Building on $MACHINE_ARCH..."

  info "Building with $JOB_ARG for $MACHINE_ARCH"

  cd ${GW_ROS_ROOT_DIR}
  export GPUAC_COMPILE_WITH_CUDA=1
  # --force-cmake
  info "colcon ${LOG_ARG} test ${COLCON_ARG} ${TEST_ARG} ${JOB_ARG} "
  colcon ${LOG_ARG} test ${COLCON_ARG} ${TEST_ARG} ${JOB_ARG}

  # --packages-up-to
  if [ ${PIPESTATUS[0]} -ne 0 ]; then
    fail 'Test failed!'
  fi
  cd -
  success 'Test passed!'
}

function run_cpp_lint() {
  echo "not support"
}

function run_bash_lint() {
  FILES=$(find "${APOLLO_ROOT_DIR}" -type f -name "*.sh" | grep -v ros)
  echo "${FILES}" | xargs shellcheck
}

function run_lint() {
  # Add cpplint rule to BUILD files that do not contain it.
  run_cpp_lint

  if [ $? -eq 0 ]; then
    success 'Lint passed!'
  else
    fail 'Lint failed!'
  fi
}

function clean() {
  # Remove catkin files
  cd ${GW_ROS_ROOT_DIR}
  info "Start cleaning, please wait ..."
  info "rm -rf  ../target/colcon/*"
  rm -rf  ../target/colcon/*
  cd -
  success "clean passed!"
}

function version() {
  echo "not support"
}

function get_revision() {
  echo "not support"
}

function get_branch() {
  git branch &> /dev/null
  if [ $? = 0 ];then
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
  else
    warning "Could not get the branch name, maybe this is not a git work tree." >&2
    BRANCH="unknown"
  fi
  echo "$BRANCH"
}

function config() {
  JOB_ARG="--parallel-workers $(($(nproc)-1))"
  if [ "$MACHINE_ARCH" == 'aarch64' ]; then
    JOB_ARG="--parallel-workers $(($(nproc)-2))"
  fi
  LOG_ARG=" --log-base ../target/colcon/log "
  COLCON_ARG=" --metas ../packages/colcon.meta --build-base ../target/colcon/build --install-base ../target/colcon/install --test-result-base ../target/colcon/test "
  # --symlink-install --merge-install
  # INSTALL_ARG=" --symlink-install "
  INSTALL_ARG=" --merge-install "
  TEST_ARG=" --packages-select shm_msgs --ctest-args -DSKIP_MULTI_RMW_TESTS=ON "
  # -DRMW_IMPLEMENTATION=rmw_iceoryx_cpp --abort-on-error
  # test_communication test_rclcpp
  CMAKE_OPT=" --cmake-args -DBUILD_TESTING=ON --no-warn-unused-cli"
  CROSS_OPT=" -DCMAKE_TOOLCHAIN_FILE=/gw_demo/cmake/Toolchain-V5L.cmake -DVIBRANTE_PDK=/drive/drive-linux "
  # --cmake-force-configure
  # PACKAGE_ARG=" --packages-up-to performance_test "
  PACKAGE_ARG=" --cmake-force-configure --packages-up-to sm_guardian "
}

function set_use_gpu() {
  echo "not support"
}

function print_usage() {
  RED='\033[0;31m'
  BLUE='\033[0;34m'
  BOLD='\033[1m'
  NONE='\033[0m'

  echo -e "\n${RED}Usage${NONE}:
  .${BOLD}/gw_ros.sh${NONE} [OPTION]"

  echo -e "\n${RED}Options${NONE}:
  ${BLUE}build_rel${NONE}: build_rel
  ${BLUE}build_rel_native${NONE}: build_rel_native
  ${BLUE}build_dbg${NONE}: build_dbg
  ${BLUE}build_rel_dbg${NONE}: build rel with dbg info
  ${BLUE}clean${NONE}: rm -rf colcon/
  ${BLUE}usage${NONE}: print this menu
  "
}

function main() {
  ga_check_system_config

  source_ga_base

  check_machine_arch
  config

  if [ ${MACHINE_ARCH} == "x86_64" ]; then
    echo "x86_64"
  fi

  local cmd=$1
  shift

  START_TIME=$(get_now)
  case $cmd in
    build_dbg)
      build_dbg $@
      ;;
    build_rel_dbg)
      build_rel_dbg $@
      ;;
    build_rel)
      build_rel $@
      ;;
    build_rel_native)
      build_rel_native $@
      ;;
    build)
      build $@
      ;;
    clean)
      clean
      ;;
    usage)
      print_usage
      ;;
    *)
      print_usage
      ;;
  esac
}

main $@
