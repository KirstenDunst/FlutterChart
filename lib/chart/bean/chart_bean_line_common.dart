
import 'package:flutter/material.dart';

class LineShaderSetModel {
  //Line渐变色，闭合曲线以上的填充颜色
  LinearGradientModel baseLineTopGradient;
  //Line渐变色，闭合曲线以下的填充颜色(不设置则不展示)
  LinearGradientModel? baseLineBottomGradient;
  //基准y值(影响渐变填充色的闭包区域)，
  //不设置表示正常按照渐变色闭合到x轴，
  //如果设置，则以此值为基准，渐变路径都闭合到此y值对应的一条平行x轴的线上
  double? baseLineY;

  ///此设置只针对[baseLineY]不为null的时候才有意义
  ///true：渐变色是内部路径的最大最小值和[baseLineY]的区间内渐变
  ///false：还是[baseLineY]分两区中的整体区域的渐变范围
  ///注意：（此处只是shader范围，渐变色填充展示出来的仍是路径和基线闭合间的区域）
  bool shaderIsContentFill;

  LineShaderSetModel(
      {required this.baseLineTopGradient,
      this.baseLineBottomGradient,
      this.baseLineY,
      this.shaderIsContentFill = true});
}

//Line渐变色设置
class LinearGradientModel {
  //从上到下的填充闭合颜色集
  List<Color> shaderColors;
  //从上到下的填充闭合颜色分割点集
  List<double>? shadowColorsStops;
  LinearGradientModel({required this.shaderColors, this.shadowColorsStops});
}
