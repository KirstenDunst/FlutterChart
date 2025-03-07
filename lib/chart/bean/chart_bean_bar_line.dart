import 'package:flutter/material.dart';

import '../base/chart_bean.dart';
import '../base/chart_typedef.dart';

class ChartLineBarBeanSystem {
  //线宽
  double lineWidth;

  /// 线颜色 ,与参数[segmentationModel]互斥
  Color? lineColor;

  ///线条分段颜色设置，如果不为空则会覆盖[lineColor]效果,故此参数设置和[lineColor]参数互斥
  LineColorSegmentationModel? segmentationModel;
  //数据集合
  List<LineBarSectionBean> lineBarBeans;
  //是否支持可点击，匹配外部的可点击参数设置,多条线都设置可点击的话，只会取最后一条线的点做可点击处理
  bool enableTouch;

  ChartLineBarBeanSystem(
      {this.lineWidth = 2,
      required this.lineBarBeans,
      this.lineColor,
      this.segmentationModel,
      this.enableTouch = false});
}

class LineColorSegmentationModel {
  //基准线以上的线条颜色
  Color baseLineTopColor;
  //基准线以下的线条颜色
  Color baseLineBottomColor;
  //基准线数值
  double baseLineY;

  LineColorSegmentationModel(
      this.baseLineTopColor, this.baseLineBottomColor, this.baseLineY);
}

class LineBarSectionBean {
  //开始绘制的起始位置占总长度的比例
  double startRatio;
  //绘制的宽度与总宽度的比较
  double widthRatio;
  //数值(无数值则断开)
  num? value;
  //点击参数
  dynamic param;
  LineBarSectionBean(this.startRatio, this.widthRatio, this.value,
      {this.param});
}

class LineBarTouchSet {
  //点击坐标轴以外的绘图区域是否取消触摸点的选中？，默认取消选中
  final bool outsidePointClear;
  //触摸回调, [touchBackParam]
  final LineBarPointBack? touchBack;
  //触摸点设置
  final CellPointSet pointSet;
  //选中的区域高亮蒙层颜色
  final LineBarSelectSet selelctSet;
  LineBarTouchSet(
      {this.outsidePointClear = true,
      this.pointSet = CellPointSet.normal,
      this.selelctSet = LineBarSelectSet.normal,
      this.touchBack});
}

class LineBarSelectSet {
  //选中的区域高亮蒙层颜色
  final Color highLightColor;
  const LineBarSelectSet({this.highLightColor = Colors.transparent});
  static const LineBarSelectSet normal = LineBarSelectSet();
}
