# DWCGFImagePipe

## 图模型架构

<!--
:heavy_check_mark:
:x:
:grey_question:
complete list: https://gist.github.com/rxaviers/7360908
 -->
## 节点设计

| App类型           | 相机      | 前处理类型 | 数据同步 | 推理算法 |  渲染器 | 开发状态    |
|------------------ |-----------|--------|---------|-------------|----|-----------|
| `appRawCameraDeployPipe`  | shunyu |  `DW`     | :grey_question:  |  :grey_question:  |  :x:  | :o: |
| `appVirtualCameraDeployPipe` | virtual |  `DW`    | :grey_question:  |  :grey_question:  |  :x:  | :o: |
| `appYUVCameraDeployPipe` | senyun  |  `DO`     | :grey_question: | :grey_question:  |  :x: | :o: |
| `appRawCameraTestPipe` | shunyu  |  `CUSTOM`  | :grey_question: | :grey_question:  |  :heavy_check_mark: | :o: |
| `appVirtualCameraTestPipe` | virtual |  `CUSTOM`  | :grey_question: | :grey_question:  |  :heavy_check_mark: | :o: |
| `appYUVCameraTestPipe` | senyun  |  `CUSTOM`  | :grey_question: | :grey_question:  |  :heavy_check_mark: | :o: |
