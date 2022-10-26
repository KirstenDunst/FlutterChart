/*
 * @Author: your name
 * @Date: 2020-11-09 17:15:55
 * @LastEditTime: 2021-09-22 09:05:26
 * @LastEditors: Cao Shixin
 * @Description: In User Settings Edit
 * @FilePath: /flutter_chart/lib/chart/bean/chart_bean_bar.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/bean/chart_typedef.dart';
import 'package:flutter_chart_csx/chart/enum/painter_const.dart';

class ChartBarBeanX {
  //x轴显示的内容
  String title;
  //x轴显示的内容的样式
  TextStyle titleStyle;
  //数值，用来处理柱体的高度。这里不用比值来操作是因为如果外部没有传最大值内部会有最大y值计算。
  num value;
  //柱状图顶部的数值显示文字，默认为空,
  //提示：如果内容是数字类型的字符串，在动画的时候会自动滚动数值效果。
  String rectTopText;
  //柱状图顶部的数值显示样式，
  TextStyle rectTopTextStyle;
  //柱体多渐变色数组.可支持内部多段自定义颜色段
  List<SectionColor>? sectionColors;
  //点击的时候外带的数据
  dynamic touchBackParam;

  ChartBarBeanX(
      {this.title = '',
      this.titleStyle = defaultTextStyle,
      required this.value,
      this.rectTopText = '',
      this.rectTopTextStyle = defaultTextStyle,
      this.sectionColors,
      this.touchBackParam});
}

class SectionColor {
  //开始比率
  double starRate;
  //结束比率
  double endRate;
  //中间的颜色填充
  List<Color>? gradualColor;
  //填充颜色矩形四周圆角
  BorderRadius borderRadius;
  SectionColor(
      {required this.starRate,
      required this.endRate,
      this.gradualColor,
      this.borderRadius = BorderRadius.zero})
      : assert(starRate >= 0 && starRate <= 1.0),
        assert(endRate >= 0 && endRate <= 1.0);
}

class TouchSet {
  //点击坐标轴以外的绘图区域是否取消触摸点的选中？，默认取消选中
  final bool outsidePointClear;
  //触摸回调, [touchBackParam]
  final BarPointBack? touchBack;
  TouchSet({this.outsidePointClear = true, this.touchBack});
}
