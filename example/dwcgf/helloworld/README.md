# helllworld

## tools

```sh
cd /target/aarch64/install/example/dwcgf_helloworld

# 严格按照先后顺序启动
# t1: consumer
./bin/dwchannel2ros --cons=1 --prod=0 --downstreams=0 --dataType=int
# t2: producer
/usr/local/driveworks/bin/sample_cgf_dwchannel --cons=0 --prod=1 --downstreams=1 --dataType=int
# t3 todo: ros2 node

```
