/*
 * @Author: Cao Shixin
 * @Date: 2020-03-29 10:26:09
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-12-08 16:33:21
 * @Description: 头环绘制曲线属性设置区
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

//长按回调(相对于坐标的偏移point,如果为null则长按辅助消失，value：触摸外传的参数（自给自足）)
typedef PressPointBack = Function(Offset? point, dynamic value);

class FocusChartBeanMain {
  //数据显示点集合
  List<ChartBeanFocus>? chartBeans;
  //曲线或折线的颜色
  Color lineColor;
  //曲线或折线的线宽
  double lineWidth;
  //是否是虚线
  bool isLineImaginary;
  //是否是曲线
  bool isCurve;
  //是否需要触摸(针对静态图),触摸之后的显示参数在ChartLineFocus里面有设置,目前仅支持一条触摸线显示，多条线的话只显示第一条支持触摸的线的触摸
  bool touchEnable;
  //是否显示占位点（每一个值的位置以空心点的形式展示,占位点的颜色目前按照y轴辅助文案的颜色显示）
  bool showSite;
  //是否展示线条区间带(true的时候chartBeans中的focusMax与focusMin才有意义)
  bool showLineSection;
  //线条区间带的设置参数模型
  LineSectionModel? sectionModel;
  //内部的渐变颜色。不设置的话默认按照解释文案的分层显示，如果设置，即为整体颜色渐变显示,
  //如果showLineSection为true，则显示区间带颜色，不显示闭合x轴的曲线渐变色
  List<Color>? gradualColors;
  //beans的时间轴如果断开，true： 是继续上一个有数值的值绘制，还是 false：断开。按照多条绘制,默认true
  bool isLinkBreak;
  //结束回调
  VoidCallback? canvasEnd;

  FocusChartBeanMain(
      {this.chartBeans,
      this.lineColor = Colors.lightBlueAccent,
      this.lineWidth = 4,
      this.isLineImaginary = false,
      this.isCurve = true,
      this.touchEnable = false,
      this.showSite = false,
      this.showLineSection = false,
      this.sectionModel,
      this.gradualColors,
      this.isLinkBreak = true,
      this.canvasEnd});
}

class LineSectionModel {
  //边框的边界线条颜色
  Color lineSectionBorColor;
  //边框线条宽度
  double borLineWidth;
  //线条区间带的边界是否为虚线
  bool isBorLineImaginary;
  //线条区间带的中间填充颜色
  List<Color>? fillColors;
  LineSectionModel(
      {this.lineSectionBorColor = Colors.purple,
      this.borLineWidth = 1,
      this.isBorLineImaginary = true,
      this.fillColors});
}

class ChartBeanFocus {
  //这个专注值开始的时间，以秒为单位
  int second;
  //数值
  num focus;
  //专注值最大值（大师级图表使用,）
  num? focusMax;
  //专注值最小值（大师级图表使用）
  num? focusMin;
  //在该点上下左右的辅助线样式，默认不设置就没有辅助线了
  HintEdgeInset? hintEdgeInset;
  //如果所有的点位都想展示出来，这里就不要在这里设置，FocusChartBeanMain里面的showSite打开即可满足
  //某个特定位置的widget（比如一个小头像），默认没有，什么也不显示，
  ui.Image? centerPoint;
  //centerPoint的显示与原大小的比率,方便屏幕适配使用，默认原比例1.0
  Size? centerPointSize;
  //centerPoint的中心与位置的偏移
  Offset centerPointOffset;
  //centerPoint的中心与位置的偏移的线颜色（目前是虚线颜色连接）
  Color? centerPointOffsetLineColor;
  //支持触摸的时候，触发回调的外带参数
  dynamic touchBackValue;

  ChartBeanFocus(
      {required this.focus,
      this.focusMax,
      this.focusMin,
      this.second = 0,
      this.touchBackValue,
      this.hintEdgeInset,
      this.centerPoint,
      this.centerPointSize,
      this.centerPointOffset = Offset.zero,
      this.centerPointOffsetLineColor});
}

//某点上下左右的辅助线显示类型,不设置某个方位的类型就不会绘制
class HintEdgeInset {
  final PointHintParam? left;
  final PointHintParam? top;
  final PointHintParam? right;
  final PointHintParam? bottom;

  const HintEdgeInset.fromLTRB(this.left, this.top, this.right, this.bottom);

  const HintEdgeInset.all(PointHintParam value)
      : left = value,
        top = value,
        right = value,
        bottom = value;

  const HintEdgeInset.only({
    this.left,
    this.top,
    this.right,
    this.bottom,
  });

  const HintEdgeInset.symmetric({
    PointHintParam? vertical,
    PointHintParam? horizontal,
  })  : left = horizontal,
        top = vertical,
        right = horizontal,
        bottom = vertical;
}

class PointHintParam {
  //辅助线颜色
  Color? hintColor;
  //辅助线是否是虚线
  bool isHintLineImaginary;
  //辅助线宽度
  double hintLineWidth;
  PointHintParam(
      {this.hintColor = Colors.purple,
      this.isHintLineImaginary = false,
      this.hintLineWidth = 1.0});
}

//颜色区间
class SectionBean {
  //标题
  String title;
  //标题字体样式
  TextStyle? titleStyle;
  //开始绘制的起始位置占总长度的比例
  double startRatio;
  //绘制的宽度与总宽度的比较
  double widthRatio;
  //内部填充颜色
  Color? fillColor;
  //边框颜色,默认没有颜色
  Color? borderColor;
  //边框线宽度，默认宽度为1
  double borderWidth;
  //边框线是否为实线还是虚线，默认实线
  bool isBorderSolid;

  SectionBean(
      {this.title = '',
      this.titleStyle,
      this.startRatio = 0,
      this.widthRatio = 0,
      this.fillColor,
      this.borderColor,
      this.borderWidth = 1,
      this.isBorderSolid = true});
}
