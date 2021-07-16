/*
 * @Author: your name
 * @Date: 2020-11-09 17:15:55
 * @LastEditTime: 2020-11-09 17:16:15
 * @LastEditors: your name
 * @Description: In User Settings Edit
 * @FilePath: /flutter_chart/lib/chart/bean/chart_bean_bar.dart
 */
import 'package:flutter/material.dart';

class ChartBarBeanX {
  //x轴显示的内容
  String? title;
  //刻度标志样式
  TextStyle? titleStyle;
  //数值，用来处理柱体的高度。这里不用比值来操作是因为如果外部没有传最大值内部会有最大y值计算。
  num? value;
  //柱体的渐变色数组
  List<Color>? gradualColor;

  ChartBarBeanX({this.title, this.titleStyle, this.value, this.gradualColor});
}
