/*
 * @Author: your name
 * @Date: 2020-11-09 18:36:29
 * @LastEditTime: 2022-10-21 15:20:54
 * @LastEditors: Cao Shixin
 * @Description: In User Settings Edit
 * @FilePath: /flutter_chart/lib/chart/bean/chart_bean_line_content.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/enum/painter_const.dart';
import 'chart_bean.dart';
import 'chart_bean_line_common.dart';

//内部使用模型

//绘制图表的计算之后的结果模型集
class LineCanvasModel {
  List<Path> paths;
  Color pathColor;

  ///曲线或折线的整体绘制区域的渐变设置，如果不为空会覆盖 [lineColor]的设置效果，
  Gradient? lineGradient;
  double pathWidth;
  //基线顶部的渐变区
  LineShadowModel? baseLineTopShadow;
  //基线底部的渐变区
  LineShadowModel? baseLineBottomShadow;
  List<LinePointModel> points;

  LineCanvasModel({
    required this.paths,
    this.pathColor = defaultColor,
    this.lineGradient,
    this.pathWidth = 1,
    this.baseLineTopShadow,
    this.baseLineBottomShadow,
    required this.points,
  });
}

class LineShadowModel {
  List<Path> shadowPaths;
  //渐变色顶部高度
  double shadowTopHeight;
  //渐变色底部高度
  double shadowBottomHeight;
  double get shadowHeigth => (shadowBottomHeight - shadowTopHeight).abs();
  LinearGradientModel linearGradient;

  LineShadowModel({
    required this.shadowPaths,
    required this.linearGradient,
    this.shadowTopHeight = 0,
    this.shadowBottomHeight = 0,
  });
}

//节点的内部模型
class LinePointModel {
  //位置点
  double x;
  //如果为null表示断开的点，（针对占位图有特殊处理，其他模式不用绘制）
  double? y;
  //显示文案
  String text;
  //显示文案的样式
  TextStyle textStyle;
  //点中心距离文字底部的距离（目前文字都是在点的上面绘制）
  double pointToTextSpace;
  //点设置，默认圆点,半径0，默认颜色填充
  CellPointSet cellPointSet;

  LinePointModel(
      {required this.x,
      this.y,
      this.text = '',
      this.textStyle = defaultTextStyle,
      this.pointToTextSpace = 0,
      this.cellPointSet = CellPointSet.normal});
}

//点击的时候带出来的参数
class LineTouchBackModel {
  bool needRefresh;
  Offset? startOffset;
  dynamic backParam;
  LineTouchBackModel(
      {this.needRefresh = true, required this.startOffset, this.backParam});
}

class LineTouchCellModel {
  //开始的点，左上角
  Offset begainPoint;
  //柱体的点击外带参数
  dynamic param;
  LineTouchCellModel({required this.begainPoint, this.param});
}
