/*
 * @Author: Cao Shixin
 * @Date: 2020-03-29 10:26:09
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2021-05-07 13:43:51
 * @Description: 饼状图参数
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/material.dart';
import '../base/painter_const.dart';

class ChartPieBean {
  //占比数值，可以任意写数值，会统一计算最后每块的占比
  double value;
  //扇形板块的类型标记名称
  String type;
  //扇形板块的颜色
  Color color;
  //辅助性文案展示的文案样式
  TextStyle assistTextStyle;

  ChartPieBean(
      {required this.value,
      this.type = '',
      this.color = defaultColor,
      this.assistTextStyle = defaultTextStyle});
}
