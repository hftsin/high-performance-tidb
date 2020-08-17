## 第一次课：TiDB 总体架构

### Prerequisite

- [How we build TiDB](https://pingcap.com/blog-cn/how-do-we-build-tidb/)
- [三篇文章了解 TiDB 技术内幕 - 说存储](https://pingcap.com/blog-cn/tidb-internal-1/)
- [三篇文章了解 TiDB 技术内幕 - 说计算](https://pingcap.com/blog-cn/tidb-internal-2/)
- [三篇文章了解 TiDB 技术内幕 - 谈调度](https://pingcap.com/blog-cn/tidb-internal-3/)

### Problem

>本地下载`TiDB`, `TiKV`, `PD`源代码，改写源码并编译部署以下环境：
>
>+ 1 TiDB
>+ 1 PD
>+ 3 TiKV
>
>改写后
>
>+ 使得TiDB启动事务时，会打一个"hello transaction"的日志
>
>输出：一篇文章介绍以上过程
>
>截止时间：本周日24点之前
>
>作业提交方式：提交至个人github，链接发送给`talent-plan@tidb.io`

### HowTo

```shell
$ git checkout -b lab01
$ bash build_docker.sh # build docker images for tidb, pd, and tikv respectively
$ docker-compose up -d
$ tail -f run/logs/tidb0.log # check the dummy transaction log
$ docker-compose down
```

### Solution

本次作业的两个小目标分别是熟悉`TiDB`的工程环境搭建和基本的代码流程结构入门。

对于第一个小目标，借助于`docker-compose`工具，可以在本地很方便地搭建`TiDB`集群。具体操作步骤如下，

+ 分别fork `pingcap/tidb`, `pingcap/pd`, `tikv/tikv`，并clone到本地，编译。`TiDB`的工程，使用`Makefile`封装了`go build`和`cargo build`的构建逻辑。这里，需要注意的是，在不指定参数直接运行`make`时，默认的构建目标(target)都是优化后的`release`版本，如果需要构建其他版本，比如带调试信息的开发版本等，需要查看`Makefile`获取构建目标。
+ 准备docker镜像。`tidb`和`pd`已经提供了`Dockerfile`，可以直接使用。`tikv`没有直接提供`Dockerfile`，可以参考[docker hub](https://hub.docker.com/r/pingcap/tikv/dockerfile)上的`Dockerfile`。事实上，`tikv`的`Makefile`里有一个名为`docker`的target，也可以创建镜像。笔者封装了一个[build_docker.sh](https://raw.githubusercontent.com/hftsin/high-performance-tidb/master/build_docker.sh)的脚本，用来从本地工程开发目录快速创建`TiDB`的镜像。
+ 编写`docker-compose.yml`，配置集群环境。这里参考了`pingcap/tidb-docker-compose`，本次作业要求配置1个`pd`实例，3个`tikv`实例，1个`tidb`实例。
+ 测试集群环境。执行`docker-compose up -d`，可以启动`TiDB`集群。此时，可以通过查看各服务实例的日志文件，确认各实例都已经正确启动了。执行`docker-compose down`可以销毁集群。



对于第二个目标，需要了解`TiDB`处理事务的基本流程。在`PingCAP`的官方文档库里，提供了详细的资料以供参考学习。

`TiDB`支持两种事务使用方式，分别是通过`BEGIN/COMMIT`来显式使用事务和配置`autocommit`来隐式使用事务。

`TiDB`支持乐观锁和悲观锁。以乐观锁为例，刨去细节暂不表，事务处理的基本流程：

1. 客户端`begin`一个事务。`tidb`从`pd`获取一个全局唯一的递增版本号`start_ts`。
2. 处理`read request`：`tidb`从`pd`获取数据所在的`kv`，请求`start_ts`版本对于的数据。
3. 处理`write request`：`tidb`本地校验数据，写入内存。
4. 客户端发起`commit`，使用`2pc`将数据写入`kv store`。

具体到代码工程结构上，如[TiDB源码阅读系列文章（二）源码结构](https://pingcap.com/blog-cn/tidb-source-code-reading-2/)所指出的，`store`包是封装了底层存储引擎和sql层的交互。真正的事务是在`TiKV`中实现的，`tidb`只是封装了一个`kv client`，通过调用底层的API来实现事务。

本次作业要求在事务开始时，打印一行日志。因此，可以很直观地从sql语句的执行生命周期入手，寻找事务的开启入口。在 [TiDB 源码阅读系列文章（三）SQL 的一生](https://pingcap.com/blog-cn/tidb-source-code-reading-3/)中，`session`是SQL的核心层。在`session`中定义了两个事务语义相关的操作`StmtCommit`和`StmtRollback`，具体实现都是由成员`session.txn`代理完成。`session.txn`是一个`TxnState`结构，该结构内嵌了一个`kv.Transaction`成员。`kv.Transaction`是一个接口类型，封装了底层`kv store`的事务。进一步追踪，该接口的实现者之一是定义在store/tikv`包中的`tikvTxn`结构。该结构有两个构造函数，分别是`newTiKVTxn`和`newTiKVTxnWithStartTS`，其中前者调用了后者。至此，找到了事务的开启入口。
