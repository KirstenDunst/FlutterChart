/*
 * @Author: Cao Shixin
 * @Date: 2020-03-29 10:26:09
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2022-10-21 14:30:48
 * @Description: 头环绘制曲线属性设置区
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/material.dart';
import 'chart_bean.dart';
import 'chart_typedef.dart';

class FocusChartBeanMain {
  //数据显示点集合
  List<ChartBeanFocus>? chartBeans;
  //曲线或折线的颜色
  Color lineColor;
  ///曲线或折线的整体绘制区域的渐变设置，如果不为空会覆盖 [lineColor]的设置效果，
  Gradient? lineGradient;
  //曲线或折线的线宽
  double lineWidth;
  //是否是虚线
  bool isLineImaginary;
  //是否是曲线
  bool isCurve;
  //是否需要触摸(针对静态图),触摸之后的显示参数在ChartLineFocus里面有设置,目前仅支持一条触摸线显示，多条线的话只显示最后一条支持触摸的线的触摸
  bool touchEnable;
  //线条区间带的设置参数模型,不为null表示展示线条区间带(chartBeans中的focusMax与focusMin才有意义)
  LineSectionModel? sectionModel;
  //内部的渐变颜色。不设置的话默认按照解释文案的分层显示，如果设置，即为整体颜色渐变显示,
  ///如果[sectionModel]不为null，则显示区间带颜色，不显示闭合x轴的曲线渐变色
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
  //专注值最大值（大师级图表使用）
  num? focusMax;
  //专注值最小值（大师级图表使用）
  num? focusMin;
  //点设置
  CellPointSet cellPointSet;
  //点标记，用于根据查找点
  String tag;
  //支持触摸和tag查找的时候，触发回调的外带参数
  dynamic touchBackValue;

  ChartBeanFocus({
    required this.focus,
    this.focusMax,
    this.focusMin,
    this.second = 0,
    this.touchBackValue,
    this.tag = '',
    this.cellPointSet = CellPointSet.normal,
  });
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
  double? borderWidth;
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

//颜色区间
class SectionBeanY {
  //开始绘制的起始位置占总长度的比例
  double startRatio;
  //绘制的宽度与总宽度的比较
  double widthRatio;
  //内部填充颜色
  Color? fillColor;
  //边框颜色,默认没有颜色
  Color? borderColor;
  //边框线宽度，默认宽度为1
  double? borderWidth;
  //边框线是否为实线还是虚线，默认实线
  bool isBorderSolid;

  SectionBeanY(
      {this.startRatio = 0,
      this.widthRatio = 0,
      this.fillColor,
      this.borderColor,
      this.borderWidth = 1,
      this.isBorderSolid = true});
}

//触摸参数设置
class FocusLineTouchSet {
  //点击坐标轴以外的绘图区域是否取消触摸点的选中？，默认取消选中
  bool outsidePointClear;
  //触摸点设置
  CellPointSet pointSet;
  //触摸回调
  PointPressPointBack? touchBack;
  FocusLineTouchSet({
    this.outsidePointClear = true,
    this.pointSet = CellPointSet.normal,
    this.touchBack,
  });
}

//根据tag查找的外传模型
class TagSearchedModel {
  //xy轴闭合区域左上角的点的相对offset，等同于basebean.basepadding的left、top
  Offset xyTopLeftOffset;
  //当前点的相对offset
  Offset pointOffset;
  //回调参数
  dynamic backValue;
  TagSearchedModel(
      {required this.xyTopLeftOffset,
      required this.pointOffset,
      this.backValue});
}
