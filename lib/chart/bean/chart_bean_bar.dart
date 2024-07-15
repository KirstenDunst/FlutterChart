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

import 'chart_bean.dart';

class ChartBarBeanX {
  //x轴顶部显示的图片内容设置
  ImgSetModel? xTopImgModel;
  //x轴顶部显示的文本内容
  TextSetModel? xTopTextModel;
  //x轴顶部显示距离坐标轴顶端的间隔,默认为0,无间隔.
  double xTopSpace;
  //x轴底部显示的文本内容
  TextSetModel? xBottomTextModel;
  //某一个坐标对应多个柱体(x轴均分设置的宽度)
  List<ChartBarBeanXCell> beanXModels;
  //点击的时候外带的数据
  dynamic touchBackParam;

  ChartBarBeanX(
      {this.xTopTextModel,
      this.xTopImgModel,
      this.xTopSpace = 0,
      required this.beanXModels,
      this.xBottomTextModel,
      this.touchBackParam});
}

class ChartBarBeanXCell {
  //数值，用来处理柱体的高度。这里不用比值来操作是因为如果外部没有传最大值内部会有最大y值计算。不设置则没有柱体
  num? value;
  //柱状图顶部的数值显示文字，默认为空,
  //提示：如果内容是数字类型的字符串，在动画的时候会自动滚动数值效果。
  String rectTopText;
  //柱状图顶部的数值显示样式，
  TextStyle rectTopTextStyle;
  //柱体多渐变色数组.可支持内部多段自定义颜色段(根据向上设置的对应段内的圆角和从上到下的渐变色，基准线一下的段内则相反取值)
  List<SectionColor>? sectionColors;

  ChartBarBeanXCell(
      {this.value,
      this.rectTopText = '',
      this.rectTopTextStyle = defaultTextStyle,
      this.sectionColors});
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
  //选中的区域高亮蒙层颜色
  final SelectModelSet selelctSet;
  //触摸回调, [touchBackParam]
  final BarPointBack? touchBack;
  TouchSet(
      {this.outsidePointClear = true,
      this.selelctSet = SelectModelSet.normal,
      this.touchBack});
}

class SelectModelSet {
  //选中的区域高亮蒙层颜色
  final Color highLightColor;
  const SelectModelSet({this.highLightColor = Colors.transparent});
  static const SelectModelSet normal = SelectModelSet();
}
