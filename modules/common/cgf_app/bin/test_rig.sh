#!/bin/sh

DW_TOP_PATH=$(cd $(dirname ${0})/../; pwd)
RR_TOP_PATH=$(cd /usr/local/driveworks/bin; pwd)

echo "DW_TOP_PATH=${DW_TOP_PATH}"
echo "RR_TOP_PATH=${RR_TOP_PATH}"

CMD=$(pwd)
RR_GRAPHS_PATH=${DW_TOP_PATH}/graphs

DATA_PATH=${DW_TOP_PATH}/data
RR_LOG_PATH=${CMD}/LogFolder

echo "RR_LOG_PATH=${RR_LOG_PATH}"
echo "DATA_PATH=${DATA_PATH}"


echo "Running command: ${RR_TOP_PATH}/sample_rig --rigconfig=${DATA_PATH}/rig.json"
${RR_TOP_PATH}/sample_rig --rigconfig=${DATA_PATH}/rig.json
