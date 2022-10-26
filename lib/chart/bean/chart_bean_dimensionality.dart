/*
 * @Author: Cao Shixin
 * @Date: 2020-07-17 19:06:36
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2022-06-01 10:37:23
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/enum/chart_pie_enum.dart';
import 'package:flutter_chart_csx/chart/enum/painter_const.dart';

import 'chart_typedef.dart';

//定位维度的分维
class ChartBeanDimensionality {
  // 维度的标题
  List<TipModel> tip;
  //维度的副标题(标题（上或下）居中对齐的文案)，按钮区域以 标题[tip]来定
  List<TipModel>? subTip;
  //默认样式
  DimensionCellStyle normalStyle;
  //选中的样式,可点击参数设置之后才有效
  DimensionCellStyle selectStyle;
  //可点击的时候外带参数
  dynamic touchBackParam;

  ChartBeanDimensionality({
    required this.tip,
    this.subTip,
    this.normalStyle = DimensionCellStyle.normal,
    this.selectStyle = DimensionCellStyle.normal,
    this.touchBackParam,
  });
}

class TipModel {
  // 标题字体
  final String title;
  // 字体的样式
  final TextStyle titleStyle;
  // 点按选中的时候的字体样式
  final TextStyle selectStyle;
  TipModel(
      {this.title = '',
      this.titleStyle = defaultTextStyle,
      this.selectStyle = defaultTextStyle});
  const TipModel.only(
      {this.title = '',
      this.titleStyle = defaultTextStyle,
      this.selectStyle = defaultTextStyle});
  static const TipModel normal = TipModel.only();
}

//每一个小cell的样式设置，目前按照两端切圆角设置
class DimensionCellStyle {
  //主副标题间距
  final double tipSpace;
  //文字和周围边框的内间距
  final EdgeInsets padding;
  //边框颜色
  final Color borderColor;
  //边框宽度
  final double borderWidth;
  //背景颜色
  final Color backgroundColor;
  //整体区域的偏移,向右向下为正
  final Offset offset;
  //矩形边框的圆角,不设置表示按高度切圆角
  final double? borderRadius;
  DimensionCellStyle({
    this.tipSpace = 0,
    this.padding = EdgeInsets.zero,
    this.borderColor = defaultColor,
    this.borderWidth = 1,
    this.backgroundColor = defaultColor,
    this.offset = Offset.zero,
    this.borderRadius,
  });

  const DimensionCellStyle.only({
    this.tipSpace = 0,
    this.padding = EdgeInsets.zero,
    this.borderColor = defaultColor,
    this.borderWidth = 1,
    this.backgroundColor = defaultColor,
    this.offset = Offset.zero,
    this.borderRadius,
  });
  static const DimensionCellStyle normal = DimensionCellStyle.only();
}

//一个维度图的参数
class DimensionalityBean {
  //一次维度的标记
  String? tagTitle;
  //一次维度的标记的字体样式，绘制于右上角
  TextStyle? tagTitleStyle;
  //线条宽度
  double lineWidth;
  //线条颜色
  Color lineColor;
  //线条是否为虚线
  bool isHintLineImaginary;
  //内部填充色
  Color fillColor;
  //一次维度的数据数组(尽量数据长度、顺序和维度定义的一致，不一致的绘制的时候后面按照0补上)
  //另外：内部的数组包含的是0～1的比率类型的数值。否则大于1的记为1，小于0的记为0
  List<DimensionCellModel> tagContents;

  // 右上角标记本次图层的颜色填充圆角矩形的宽和高
  double? tagTipWidth;
  double? tagTipHeight;

  DimensionalityBean(
      {this.tagTitle,
      this.tagTitleStyle,
      this.lineWidth = 0,
      this.lineColor = Colors.transparent,
      this.isHintLineImaginary = false,
      this.fillColor = defaultColor,
      required this.tagContents,
      this.tagTipWidth = 15,
      this.tagTipHeight = 5});
}

class DimensionCellModel {
  final double value;
  //线条点的显示样式,默认矩形模式
  final PointType pointType;
  //线条点的尺寸
  final Size pointSize;
  //线条点的圆角
  final Radius pointRadius;
  //线条点渐变色，从上到下的闭合颜色集
  final List<Color>? pointShaderColors;
  //PointType为PlacehoderImage的时候下面参数才有意义
  //用户当前进行位置的小图标（比如一个小锁），默认没有只显示y轴的值，如果有内容则显示这个小图标，
  final ui.Image? placehoderImage;
  final Size placeImageSize;

  DimensionCellModel({
    this.value = 0,
    this.pointType = PointType.Rectangle,
    this.pointSize = Size.zero,
    this.pointRadius = Radius.zero,
    this.pointShaderColors,
    this.placehoderImage,
    this.placeImageSize = Size.zero,
  });
}

class DimensionTouchSet {
  //点击坐标轴以外的绘图区域是否取消触摸点的选中？，默认取消选中
  final bool outsidePointClear;

  DimensionaBack? touchBack;

  DimensionTouchSet({this.outsidePointClear = true, this.touchBack});
}

class DimensionBGSet {
  //是否是圆形辅助，false,为两点直线辅助
  final bool isCircle;
  //经度线条设置,数组数量表示平分的有几层
  final List<DimensionBgCircleLine>? circleLines;
  //纬度辅助线宽度
  final double dimensionLineWidth;
  //纬度辅助线颜色
  final Color dimensionLineColor;
  //纬度辅助线是否为虚线
  final bool dimensionLineHintLineImaginary;
  //纬度中心距离最外层圆延伸的半径，默认10，
  final double extensionRadius;

  DimensionBGSet({
    this.isCircle = false,
    this.circleLines,
    this.dimensionLineWidth = 0,
    this.dimensionLineColor = defaultColor,
    this.dimensionLineHintLineImaginary = false,
    this.extensionRadius = 10,
  });

  const DimensionBGSet.normalSet({
    this.isCircle = false,
    this.circleLines,
    this.dimensionLineWidth = 0,
    this.dimensionLineColor = defaultColor,
    this.dimensionLineHintLineImaginary = false,
    this.extensionRadius = 10,
  });

  static const DimensionBGSet normal = DimensionBGSet.normalSet();
}

class DimensionBgCircleLine {
  //是否为虚线
  final bool isHintLineImaginary;
  //线宽
  final double lineWidth;
  //线条颜色
  final Color lineColor;
  DimensionBgCircleLine({
    this.lineWidth = 1,
    this.lineColor = defaultColor,
    this.isHintLineImaginary = false,
  });

  const DimensionBgCircleLine.normalSet({
    this.lineWidth = 1,
    this.lineColor = defaultColor,
    this.isHintLineImaginary = false,
  });

  static const DimensionBgCircleLine normal = DimensionBgCircleLine.normalSet();
}
