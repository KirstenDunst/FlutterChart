/*
 * @Author: your name
 * @Date: 2020-11-09 18:35:08
 * @LastEditTime: 2021-05-07 18:02:36
 * @LastEditors: Cao Shixin
 * @Description: In User Settings Edit
 * @FilePath: /flutter_chart/lib/chart/bean/chart_bean_pie_content.dart
 */
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/enum/painter_const.dart';

///内部使用
class RedrawModel {
  Point rowTopPoint;
  Point rectTopLeftPoint;
  TextPainter textPainter;
  bool isAdjust;

  RedrawModel(
      {required this.rowTopPoint,
      required this.rectTopLeftPoint,
      required this.textPainter,
      this.isAdjust = false});
}

class Frame {
  double x;
  double y;
  double width;
  double height;
  //如果多个平行绘制的话，文本框之间的间距
  double get speaceBetween => 2;
  double get maxX => x + width;
  double get maxY => y + height;
  double get maxSpaceX => maxX + speaceBetween;
  double get maxSpaceY => maxY + speaceBetween;
  double get minSpaceX => x - speaceBetween;
  double get minSpaceY => y - speaceBetween;
  Frame(
      {required this.x,
      required this.y,
      required this.width,
      required this.height});
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
  late String assistText;
  //所占比例（内部计算勿传）
  late double rate;
  //开始角度（内部计算）
  late double startAngle;
  //所占角度（内部计算）
  late double sweepAngle;
  PieBean(
      {required this.value,
      this.type = '',
      this.color = defaultColor,
      this.assistTextStyle = defaultTextStyle,
      this.assistText = '',
      this.rate = 0.0,
      this.startAngle = 0.0,
      this.sweepAngle = 0.0});
}
