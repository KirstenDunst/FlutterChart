/*
 * @Author: your name
 * @Date: 2020-11-09 18:37:56
 * @LastEditTime: 2020-12-08 16:29:02
 * @LastEditors: Cao Shixin
 * @Description: In User Settings Edit
 * @FilePath: /flutter_chart/lib/chart/bean/chart_bean_focus_content.dart
 */
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'chart_bean_focus.dart';

///内部使用的模型
class ShadowSub {
  //标准小专注矩形
  Path focusPath;
  //矩形的渐变色
  Shader rectGradient;

  ShadowSub({this.focusPath, this.rectGradient});
}

class LineSection {
  //上曲线点数组
  List<Offset> topPoints;
  //下曲线点数组
  List<Offset> bottomPoints;

  LineSection({this.topPoints, this.bottomPoints});
}

//线上面点模型
class PointModel {
  //位置偏移
  Offset offset;
  //点颜色
  Color color;
  PointModel({this.offset, this.color});
}

class BeanDealModel {
  //此处的数值处理
  double value;
  //区间带该点上限
  double valueMax;
  //区间带该点下限
  double valueMin;
  //在该点上下左右的辅助线样式，默认不设置就没有辅助线了
  HintEdgeInset hintEdgeInset;
  //某个特定位置的widget（比如一个小头像），默认没有，什么也不显示，
  ui.Image centerPoint;
  //centerPoint的显示大小
  Size placeImageSize;
  //centerPoint的中心与位置的偏移
  Offset centerPointOffset;
  //centerPoint的中心与位置的偏移的线颜色（目前是虚线颜色连接）
  Color centerPointOffsetLineColor;
  //回调参数
  dynamic touchBackValue;
  BeanDealModel(
      {this.value,
      this.valueMax,
      this.valueMin,
      this.hintEdgeInset,
      this.centerPoint,
      this.centerPointOffset = Offset.zero,
      this.centerPointOffsetLineColor = Colors.purple,
      this.placeImageSize,
      this.touchBackValue});
}

//特殊点位
class SpecialPointModel {
  //位置偏移
  Offset offset;
  //在该点上下左右的辅助线样式，默认不设置就没有辅助线了
  HintEdgeInset hintEdgeInset;
  //1.以centerPoint为主，有值的话不读2种情况
  //某个特定位置的widget（比如一个小头像），默认没有，什么也不显示，
  ui.Image centerPoint;
  //centerPoint的中心与位置的偏移
  Offset centerPointOffset;
  //centerPoint的中心与位置的偏移的线颜色（目前是虚线颜色连接）
  Color centerPointOffsetLineColor;
  //2.
  //特殊圆点的宽度，颜色
  double specialPointWidth;
  Color specialPointColor;

  //centerPoint的显示与原大小的比率
  Size placeImageSize;
  SpecialPointModel(
      {this.offset,
      this.hintEdgeInset,
      this.centerPoint,
      this.centerPointOffset = Offset.zero,
      this.centerPointOffsetLineColor = Colors.purple,
      this.specialPointWidth = 4.0,
      this.specialPointColor,
      this.placeImageSize});
}

//触摸点外抛信息
class TouchModel {
  //偏移点位
  Offset offset;
  //回调参数
  dynamic touchBackValue;
  TouchModel({this.offset, this.touchBackValue});
}

//曲线的模型信息
class PathModel {
  Path path;
  bool isHintLineImaginary;
  PathModel({this.path, this.isHintLineImaginary = false});
}
