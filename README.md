# cpu-design

用于计算机组成原理的课设，以及一些 iverilog 的用法笔记。

运行一个 `.v` 文件

```bash
$ iverilog -o main main.v
```

多文件编译时，需要通过``` `include "xxx.v" ```来导入外部模块。