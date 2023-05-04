# DWCGFImagePipe

## 图模型架构

<!--
:heavy_check_mark:
:x:
:grey_question:
complete list: https://gist.github.com/rxaviers/7360908
 -->
## 节点设计

| App序号           | 相机      | 前处理类型 | 数据同步 | 推理算法 |  渲染器 | 开发状态    |
|------------------ |-----------|--------|---------|-------------|----|-----------|
| `DWCGFImagePipe`  | `shunyu` |  dw     | :grey_question:  |  :grey_question:  |  :x:  | :o: |
| `DWCGFImagePipe1` | `virtual` |  dw    | :grey_question:  |  :grey_question:  |  :x:  | :o: |
| `DWCGFImagePipe2` | `senyun`  |  do     | :grey_question: | :grey_question:  |  :x: | :o: |
| `DWCGFImagePipe3` | `shunyu`  |  custom  | :grey_question: | :grey_question:  |  :heavy_check_mark: | :o: |
| `DWCGFImagePipe4` | `virtual` |  custom  | :grey_question: | :grey_question:  |  :heavy_check_mark: | :o: |
| `DWCGFImagePipe5` | `senyun`  |  custom  | :grey_question: | :grey_question:  |  :heavy_check_mark: | :o: |
