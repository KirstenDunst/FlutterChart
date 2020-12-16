/*
 * @Author: your name
 * @Date: 2020-11-09 18:36:29
 * @LastEditTime: 2020-11-09 18:37:08
 * @LastEditors: your name
 * @Description: In User Settings Edit
 * @FilePath: /flutter_chart/lib/chart/bean/chart_bean_line_content.dart
 */
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/enum/chart_pie_enum.dart';

///内部使用模型

//绘制图表的计算之后的结果模型集
class LineCanvasModel {
  List<Path> paths;
  Color pathColor;
  double pathWidth;

  List<Path> shadowPaths;
  List<Color> shaderColors;

  List<Point> points;
  //线条点的显示样式,默认圆点
  PointType pointType;
  //线条点的特殊处理，如果内容不为空，则在点上面会绘制一个圆点，这个是圆点半径参数
  double pointRadius;
  //线条点渐变色，从上到下的闭合颜色集，默认线条颜色
  List<Color> pointShaderColors;

//占位图的底部中心点
  List<Point> placeImagePoints;
  ui.Image placeImage;
  double placeImageRatio;
  LineCanvasModel(
      {this.paths,
      this.pathColor,
      this.pathWidth,
      this.shadowPaths,
      this.shaderColors,
      this.points,
      this.pointType,
      this.pointShaderColors,
      this.pointRadius,
      this.placeImagePoints,
      this.placeImage,
      this.placeImageRatio = 1.0});
}
