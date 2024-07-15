/*
 * @Author: your name
 * @Date: 2020-11-09 17:15:01
 * @LastEditTime: 2022-10-21 15:20:35
 * @LastEditors: Cao Shixin
 * @Description: In User Settings Edit
 * @FilePath: /flutter_chart/lib/chart/bean/chart_bean_line.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/enum/painter_const.dart';

import 'chart_bean.dart';
import 'chart_bean_line_common.dart';
import 'chart_typedef.dart';

//每条线的定义
class ChartBeanSystem {
  //线宽
  double lineWidth;
  //标记是否为曲线
  bool isCurve;
  //点集合
  List<ChartLineBean> chartBeans;
  //单独的点样式设置(两个y为null的数值之间只有一个点的样式展示)
  CellPointSet alonePointSet;
  //线条闭合曲线渐变颜色设置,如果为空则不需要渐变填充设置
  LineShaderSetModel? lineShader;
  //曲线或折线的颜色
  Color lineColor;

  ///曲线或折线的整体绘制区域的渐变设置，如果不为空会覆盖 [lineColor]的设置效果，
  Gradient? lineGradient;
  //是否支持可点击，匹配外部的可点击参数设置,多条线都设置可点击的话，只会取最后一条线的点做可点击处理
  bool enableTouch;

  ChartBeanSystem(
      {this.lineWidth = 2,
      this.isCurve = false,
      required this.chartBeans,
      this.lineShader,
      this.lineColor = defaultColor,
      this.lineGradient,
      this.alonePointSet = CellPointSet.normal,
      this.enableTouch = false});
}

class ChartLineBean {
  //x轴坐标占有比例（0～1）
  double xPositionRetioy;
  //y轴的值,如果为null表示连接断开绘制（此时如果pointType为PlacehoderImage，占位图会在对应x轴的指定y的位置，作此位置x对应的y占位）
  double? y;
  //y轴展示的文本内容，默认为空，即：不展示
  String yShowText;
  //y轴展示的文本内容样式
  TextStyle yShowTextStyle;
  //点中心距离文字底部的距离（目前文字都是在点的上面绘制）
  double pointToTextSpace;
  //点设置，默认圆点,半径0，默认颜色填充
  CellPointSet cellPointSet;
  //点标记，用于根据查找点
  String tag;
  //点击的时候外带的数据
  dynamic touchBackParam;

  ChartLineBean(
      {this.xPositionRetioy = 0,
      this.y,
      this.yShowText = '',
      this.yShowTextStyle = defaultTextStyle,
      this.pointToTextSpace = 0,
      this.cellPointSet = CellPointSet.normal,
      this.tag = '',
      this.touchBackParam});
}

//触摸参数设置
class LineTouchSet {
  //点击坐标轴以外的绘图区域是否取消触摸点的选中？，默认取消选中
  bool outsidePointClear;
  //触摸点设置
  CellPointSet pointSet;
  //触摸点四周辅助线设置
  HintEdgeInset hintEdgeInset;
  //触摸回调
  PointPressPointBack? touchBack;
  LineTouchSet({
    this.outsidePointClear = true,
    this.hintEdgeInset = HintEdgeInset.none,
    this.pointSet = CellPointSet.normal,
    this.touchBack,
  });
}
