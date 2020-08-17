## 第二次课：对TiDB进行基准测试

### Prerequisite

- [使用TiUP部署集群](https://docs.pingcap.com/zh/tidb/stable/production-deployment-using-tiup)
- [TiKV线程池优化](https://github.com/pingcap-incubator/tidb-in-action/blob/master/session4/chapter8/threadpool-optimize.md)
- [PD Dashboard说明](https://docs.pingcap.com/zh/tidb/stable/dashboard-intro)
- [TPCC背景知识](https://github.com/pingcap-incubator/tidb-in-action/blob/master/session4/chapter3/tpc-c.md)
- [ycsb, sysben](https://github.com/pingcap-incubator/tidb-in-action/blob/master/session4/chapter3/sysbench.md)

### Problem

> 分值：300
>
> **题目描述**：
>
> 使用`sysbench`, `go-ycsb`和`go-tpc`分别对`TiDB`进行测试，并且产出测试报告。
>
> 测试报告需要包括以下内容
>
> + 部署环境的机器配置（CPU，内存，磁盘规格型号），拓扑结构（`TiDB`, `TikV`各部署于哪些结点）
> + 调整过后的`TiDB`和`TiKV`配置
> + 测试输出结果
> + 关键指标的监控截图
>   + `TiDB Query Summary`中的`qps`与`duration`
>   + `TiKV Details`面板中`Cluster`中各`server`的`CPU`及`QPS`指标
>   + `TiKV Details`面板中`grpc`的`qps`及`duration`
>
> **输出**：写出你对该配置与拓扑环境和`workload`下`TiDB`集群负载的分析，提出你认为的`TiDB`的性能的瓶颈所在（能提出大致在哪个模块即可）
>
> 截止时间：下周二（8.25）24:00:00 （逾期提交不给分）

### Solution

[测试报告](https://raw.githubusercontent.com/hftsin/high-performance-tidb/master/bench/tidb_bench_report.md)
