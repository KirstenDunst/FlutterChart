/*
 * @Author: your name
 * @Date: 2020-11-09 17:15:01
 * @LastEditTime: 2020-11-17 10:26:23
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter_chart/lib/chart/bean/chart_bean_line.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/enum/chart_pie_enum.dart';
import 'dart:ui' as ui;

//每条线的定义
class ChartBeanSystem {
  //x轴的字体样式
  TextStyle xTitleStyle;
  //是否显示x轴的文字，用来处理多个线条绘制的时候，同一x轴坐标不需要绘制多次，则只需要将多条线中一个标记绘制即可
  bool isDrawX;
  //线宽
  double lineWidth;
  //线条点的显示样式,默认圆点
  PointType pointType;
  //线条点的特殊处理，如果内容不为空，则在点上面会绘制，这个是圆点半径参数
  double pointRadius;
  //线条点渐变色，从上到下的闭合颜色集，默认线条颜色
  List<Color> pointShaderColors;
  //标记是否为曲线
  bool isCurve;
  //点集合
  List<ChartLineBean> chartBeans;
  //Line渐变色，从曲线到x轴从上到下的闭合颜色集
  List<Color> shaderColors;
  //曲线或折线的颜色
  Color lineColor;
  //占位图是否需要打断线条绘制，如果打断的话这个点的y值将没有意义，只有x轴有效，如果不打断的话，y轴值有效
  bool placehoderImageBreak;
  //用户当前进行位置的小图标（比如一个小锁），默认没有只显示y轴的值，如果有内容则显示这个小图标，
  ui.Image placehoderImage;
  double placeImageRatio;
  ChartBeanSystem(
      {this.xTitleStyle,
      this.isDrawX = false,
      this.lineWidth = 2,
      this.pointType = PointType.Circle,
      this.pointRadius = 0,
      this.pointShaderColors,
      this.isCurve = false,
      this.chartBeans,
      this.shaderColors,
      this.lineColor = Colors.purple,
      this.placehoderImageBreak = true,
      this.placehoderImage,
      this.placeImageRatio = 1.0});
}

class ChartLineBean {
  //x轴坐标显示字段
  String x;
  //y轴的值
  double y;
  //是否显示占位图，目前只结合线定义的placehoderImage使用
  bool isShowPlaceImage;

  ChartLineBean({
    this.x = '',
    this.y = 0,
    this.isShowPlaceImage = false,
  });
}





