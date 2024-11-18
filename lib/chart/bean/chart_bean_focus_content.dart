/*
 * @Author: your name
 * @Date: 2020-11-09 18:37:56
 * @LastEditTime: 2022-06-23 10:19:43
 * @LastEditors: Cao Shixin
 * @Description: In User Settings Edit
 * @FilePath: /flutter_chart/lib/chart/bean/chart_bean_focus_content.dart
 */
import 'package:flutter/material.dart';

import '../base/chart_bean.dart';

///内部使用的模型
class ShadowSub {
  //标准小专注矩形
  Path? focusPath;
  //矩形的渐变色
  Shader? rectGradient;

  ShadowSub({this.focusPath, this.rectGradient});
}

class LineSection {
  //上曲线点数组
  List<Offset>? topPoints;
  //下曲线点数组
  List<Offset>? bottomPoints;

  LineSection({this.topPoints, this.bottomPoints});
}

class BeanDealModel {
  //此处的数值处理
  double? value;
  //区间带该点上限
  double valueMax;
  //区间带该点下限
  double valueMin;
  //点设置
  CellPointSet cellPointSet;
  //点标记，用于根据查找点
  String tag;
  //回调参数
  dynamic touchBackValue;
  BeanDealModel(
      {this.value,
      required this.valueMax,
      required this.valueMin,
      this.cellPointSet = CellPointSet.normal,
      this.tag = '',
      this.touchBackValue});
}

//tag标记点外抛信息
class TagModel {
  //偏移点位
  Offset offset;
  //回调参数
  dynamic backValue;
  TagModel({required this.offset, this.backValue});
}

//触摸点外抛信息
class TouchModel {
  bool needRefresh;
  //偏移点位
  Offset? offset;
  //回调参数
  dynamic touchBackValue;
  TouchModel({this.needRefresh = true, this.offset, this.touchBackValue});
}

//曲线的模型信息
class PathModel {
  Path? path;
  bool isHintLineImaginary;
  PathModel({this.path, this.isHintLineImaginary = false});
}
