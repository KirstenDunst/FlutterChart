/*
 * @Author: your name
 * @Date: 2020-11-09 18:35:08
 * @LastEditTime: 2020-11-09 18:35:42
 * @LastEditors: your name
 * @Description: In User Settings Edit
 * @FilePath: /flutter_chart/lib/chart/bean/chart_bean_pie_content.dart
 */
import 'dart:math';

import 'package:flutter/material.dart';

///内部使用
class RedrawModel {
  Point rowTopPoint;
  Point rectTopLeftPoint;
  TextPainter textPainter;
  bool isAdjust;

  RedrawModel(
      {this.rowTopPoint,
      this.rectTopLeftPoint,
      this.textPainter,
      this.isAdjust});
}

//角的方位
enum RowDirection {
  //初始占位
  Null,
  //朝上
  Top,
  //朝左
  Left,
  //朝下
  Bottom,
  //朝右
  Right,
}

class PieBean {
  //占比数值，可以任意写数值，会统一计算最后每块的占比
  double value;
  //扇形板块的类型标记名称
  String type;
  //扇形板块的颜色
  Color color;
  //辅助性文案展示的文案样式
  TextStyle assistTextStyle;

  //辅助性文案（内部计算勿传）
  String assistText;
  //所占比例（内部计算勿传）
  double rate;
  //开始角度（内部计算）
  double startAngle;
  //所占角度（内部计算）
  double sweepAngle;
  PieBean(
      {this.value,
      this.type,
      this.color,
      this.assistTextStyle,
      this.assistText,
      this.rate,
      this.startAngle,
      this.sweepAngle});
}
