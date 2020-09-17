<!--
 * @Author: Cao Shixin
 * @Date: 2020-07-07 10:38:30
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-09-17 14:38:57
 * @Description: 版本更替
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
-->
## 0.0.1 20200917
* 专注力图表
    * 曲线更平滑
    * 解决专注力柱状间的分割线问题
    * 兼容多个同类型模式绘制
    * 添加最近绘制点的头像支持（对外暴漏一个centerPoint，widget类型，可自定义传入）
    * fix 专注力图表绘制回调

* 新增多维图
    * 维度需要大于等于3个才可以使用
    * ChartDimensionality

* 折线图
    * 调整坐标轴计算方式
    * 添加点位放大功能
    * 添加自定义占位点功能

* 柱状图: ChartBar
    * 方顶
    * 弧形过渡棱角平顶
    * 弧形顶
    
* 饼状图: ChartPie
    * 添加饼状图添加指示标签解释UI


* example条例显示
    * 专注力图表: FocusChartLinePage
    * 柱状顶部半圆型: ChartBarCirclePage
    * 柱状图顶部自定义弧角: ChartBarRoundPage
    * 平滑曲线带填充颜色: ChartCurvePage
    * 折线带填充颜色: ChartLinePage
    * 双折线: DoubleChartlinePage
    * 饼状图: ChartPiePage
    * 维度图: ChartDimensionalityView



