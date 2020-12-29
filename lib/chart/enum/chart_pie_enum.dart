/*
 * @Author: Cao Shixin
 * @Date: 2020-06-30 10:35:46
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-12-29 11:38:15
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */

//辅助性文案的显示类型
enum AssistTextShowType {
  //不显示辅助型文案
  None,
  //只显示名称在图表中心
  OnlyName,
  //只显示占比并显示在图标中心
  OnlyPercentage,
  //显示占比+名称并显示在图标中心
  NamePercentage,
}

//画圆开始的位置（均为顺时针方向画圆）
enum ArrowBegainLocation {
  //顶端，y轴正方向开始
  Top,
  //x轴正方向开始
  Right,
  //y轴负方向开始
  Bottom,
  //x轴负方向开始
  Left,
}

//点的类型
enum PointType {
  //圆点
  Circle,
  //矩形
  Rectangle,
  //圆边矩形
  RoundEdgeRectangle,
}
