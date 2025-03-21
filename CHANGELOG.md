<!--
 * @Author: Cao Shixin
 * @Date: 2020-07-07 10:38:30
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2023-03-28 15:07:09
 * @Description: 版本更替
 * @Email: cao_shixin@yahoo.com
-->

## 1.6.4

- 柱状线图每条曲线支持设置基准线上下两种颜色设置，参数[segmentationModel]

## 1.6.3

- 折线图修复单个数据的时候无法点击以及单独点展示不出来问题。

## 1.6.2

- 柱状线图支持设置选中的背景底色块设置(LineBarTouchSet 中新增 LineBarSelectSet selelctSet)

## 1.6.1

- 柱状图支持某点多个子柱体之间添加间隔 cellBarSpace，默认间隔为 0，即无间隔。

## 1.6.0+2

- 柱状线图扩展触摸点在区间段的位置（左中右）

## 1.6.0

- 新增柱状线图 ChartLineBar

## 1.5.0+1

- 修复常规曲线基准线以下渐变色绘制异常问题

## 1.5.0

- 常规折现图扩展
  x 轴的区间带 xSectionBeans
  y 轴区间带 ySectionBeans;

## 1.4.1+1

- 柱状图，折线图支持基准线功能
    1.柱状图： 2.一般折线图：ChartBeanSystem 中取消线条渐变色设置属性，调整为 LineShaderSetModel 的 lineShader 属性设置; 3.特殊专注力曲线：FocusChartBeanMain 中取消线条渐变色设置属性，调整为 LineShaderSetModel 的 lineShader 属性设置;
- 坐标轴 x 轴可设置在 y 轴位置（不用固定在最下面）:BaseBean 中增加参数 xBaseLineY
- 提醒：由于专注力曲线(FocusLine)较特殊，有特殊处理机制，属于高度定制化需求，后续折线图功能维护不太方便，后续将停止这一特殊曲线的功能拓展，业务定制化可以放在项目中随项目拓展

## 1.4.0

- 扩展方形、圆形选中和非选中状态“对勾”的常用组件

## 1.3.0+2

- 专注力曲线调整： 1.支持区间自定义填充渐变色
- 坐标系调整： 1.支持特殊辅助线颜色设置

## 1.3.0+1 20221026

- 折线图，专注力曲线调整： 1.支持 y 轴标注显示在右侧功能 2.线条支持区间渐变显示

## 1.2.9 20220927

- 旋转渐变圆形进度条优化，避免在 progress 接近 1 时端点不显示半圆

## 1.2.8 20220729

- 折线图调整：
  1.x 轴显示独立出来，同专注曲线方式设置 2.扩展线条绘制结束通知+根据 tag 查找该点的相对 offset

## 1.2.6+1 20220623

- 专注曲线图扩展： 1.扩展点设置 tag 标记，支持按照 tag 查找该点的相对 offset 2.扩展 y 轴区间带

## 1.2.5+2 20220524

- 纬度图扩展： 1.图片纬度点 2.独立每一个纬度的选中样式,标签显示扩展偏移、圆角自定义设置 3.纬度背景圈独立设置 4.暴漏 tip 中心和最外层圆的间距设置

## 1.2.4 20220217

- 纬度图扩展纬度标题 tip 和副标题 subTip 为富文本模式

## 1.2.3 20220121

- 迁移到 BrainCo Pub

## 1.2.2 20211126

- 多维图扩展功能：点击空白取消选中以及外部触发取消选中功能

## 1.2.1 20211112

- 扩展多维图显示样式：底线和维度点绘制扩展

## 1.2.0 20210924

- 添加两种进度指示器：直线型 LinearPercentIndicator、圆弧型 CircularPercentIndicator（半圆、全圆）

## 1.1.0 20210922

- fix 专注力曲线可拖拽初始化问题，
- add 现有可点击图表，添加选中初始值设定

## 1.0.5+6 20210623

- add 多维图点击回调功能区分点击 or 外部触发切换选中 index 的回调

## 1.0.5+5 20210622

- fix 维度图点击功能数据异步切换问题
- fix 折线图 1.0.5+3 修改影响空的时候占位 image 的绘制

## 1.0.5+4 20210622

- fix 图标空特殊点 bug

## 1.0.5+3 20210619

- fix 折线图起始为 null 断开操作绘制闭合阴影的问题

## 1.0.5+2 20210617

- fix 图表库 BaseBean 参数内部持有导致外部更新内部不变化的问题

## 1.0.5+1 20210615

- 扩展维度图可点击功能

## 1.0.4 20210607

- 扩展柱状图点击+拖拽选中附近的点功能
- 扩展柱状图柱体区域设置颜色功能
- 扩展折线图 chart_line 点击+拖拽选中附近的点功能

## 1.0.3 20210524

- 新增折线图 y 轴区间扩大显示功能，实用参考 example 中的【ChartLineSectionEnlarge】

## 1.0.2+2 20210514

- fix 大师级图表上下限倒序绘制问题

## 1.0.2+1 20210508

- fix 记忆力图表类型问题

## 1.0.2 20210508

- fix nullsafety 记忆力图标遗留的类型不匹配问题
- fix 饼状图首尾可能重叠的问题

## 1.0.1 20210414

- 记忆力图表迁移 nullsafety
  - 修复标题不展开状态下过长的问题

## 1.0.0 20210322

- null safety

## 0.1.8 20210406

- 记忆力图表
  - 修复标题不展开状态下过长的问题

## 0.1.7+1 20210316

- 饼状图
  - 修复防止叠加文案重绘出现的文案指向细长的问题

## 0.1.7 20210120

- 柱状图
  - 添加动画效果

## 0.1.6 20201222

- 专注力图表
  - 修复侧边栏副标签倒序不居中问题

## 0.1.5 20201217

- 记忆力游戏结果
  - 添加外部通过 setState 调整数据源支持

## 0.1.4 20201211

- 记忆力游戏结果
  - 补充查看答案按钮隐藏功能

## 0.1.3 20201211

- 添加记忆力游戏结果展示 UI 功能

## 0.1.2 20201208

- 专注力曲线扩展：
  - 大师级图表扩展：添加线条区间带功能
  - 饼状图：修复标记跨域问题

## 0.1.1 20201110

- 图表库整理扩展：
  - 抽离可共用绘制方法。
  - 创建绘制基类，统一基础参数设置。
  - 抽离私有内部 bean，为 painter 类减负。
  - 统一坐标轴基础的绘制。

## 0.1.0 20201105

- 专注力图表
  - 普通状态下：特定点位显示上下左右辅助线
  - 可触摸状态下： 修复断点绘制传参错位有 null 的问题
- 柱状图
  - 扩展传值 value 为 null 做占位显示

## 0.0.9 20201102

- 专注力图表
  - 可触摸状态下：修复起始点越界问题，修复结束点不可拖拽选中问题

## 0.0.8 20201030

- 专注力图表
  - 修复最后一个点没有绘制的问题

## 0.0.7 20201023

- 柱状图
  - 扩展 y 轴副文本右侧显示
  - 矩形自定义四角弧度
  - 新增 x 轴辅助线
  - 去除动画和长按手势，添加默认柱顶数字文案显示
- 折线图
  - 点绘制扩展：矩形点和圆角矩形点 + 渐变色

## 0.0.6 20201014

- 专注力图表（example：StepCurveLine）
  - 扩展可点击拖拽显示当前点的信息 tip 功能

## 0.0.5 20200923

- 专注力图表
  - 调整专注力连续绘制下：起始点不在初始位置绘制曲线前面不绘制处理。
  - 添加占位图的比例调整参数
- 折线图
  - 添加占位图的比例调整参数

## 0.0.4 20200820

- 专注力图表
  - 曲线更平滑
  - 解决专注力柱状间的分割线问题
- 新增多维图
  - 维度需要大于等于 3 个才可以使用
  - ChartDimensionality
- 折线图
  - 调整坐标轴计算方式
  - 添加点位放大功能
  - 添加自定义占位点功能

## 0.0.3 20200707

- 专注力图表
  - 兼容多个同类型模式绘制
  - 添加最近绘制点的头像支持（对外暴漏一个 centerPoint，widget 类型，可自定义传入）

## 0.0.2 20200707

- 调整 example 条例显示
  - 专注力图表: FocusChartLinePage
  - 柱状顶部半圆型: ChartBarCirclePage
  - 柱状图顶部自定义弧角: ChartBarRoundPage
  - 平滑曲线带填充颜色: ChartCurvePage
  - 折线带填充颜色: ChartLinePage
  - 双折线: DoubleChartlinePage
  - 饼状图: ChartPiePage
- fix 专注力图表绘制回调
- 添加饼状图添加指示标签解释 UI

## 0.0.1 20200706

- 图表集
- 专注力图表集: ChartLineFocus
- 柱状图: ChartBar
  - 方顶
  - 弧形过渡棱角平顶
  - 弧形顶
- 折线图: ChartLine
- 饼状图: ChartPie
