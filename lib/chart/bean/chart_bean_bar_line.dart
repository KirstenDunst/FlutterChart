import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/base/painter_const.dart';

import '../base/chart_bean.dart';
import '../base/chart_typedef.dart';

class ChartLineBarBeanSystem {
  //线宽
  double lineWidth;
  //线颜色
  Color lineColor;
  //标记是否为曲线
  bool isCurve;
  //数据集合
  List<LineBarSectionBean> lineBarBeans;
  //是否支持可点击，匹配外部的可点击参数设置,多条线都设置可点击的话，只会取最后一条线的点做可点击处理
  bool enableTouch;

  ChartLineBarBeanSystem(
      {this.lineWidth = 2,
      this.isCurve = false,
      required this.lineBarBeans,
      this.lineColor = defaultColor,
      this.enableTouch = false});
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
  LineBarSectionBean(this.startRatio, this.widthRatio, this.value, this.param);
}


class LineBarTouchSet {
  //点击坐标轴以外的绘图区域是否取消触摸点的选中？，默认取消选中
  final bool outsidePointClear;
  //触摸回调, [touchBackParam]
  final LineBarPointBack? touchBack;
  //触摸点设置
  final CellPointSet pointSet;
  LineBarTouchSet(
      {this.outsidePointClear = true,
      this.pointSet = CellPointSet.normal,
      this.touchBack});
}
