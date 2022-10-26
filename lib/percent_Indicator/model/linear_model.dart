/*
 * @Author: Cao Shixin
 * @Date: 2021-09-23 17:27:22
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2021-09-24 17:44:47
 * @Description: 
 */

import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/enum/painter_const.dart';

class ColorGradientModel {
  ///单一颜色
  final Color? color;

  ///渐变色，如果设置，将忽略[color]
  final LinearGradient? linearGradient;

  ColorGradientModel({this.color, this.linearGradient})
      : assert(color != null || linearGradient != null);

  const ColorGradientModel.back()
      : color = Colors.white,
        linearGradient = null;

  const ColorGradientModel.progress()
      : color = Colors.purple,
        linearGradient = null;

  static const ColorGradientModel backModel = ColorGradientModel.back();
  static const ColorGradientModel progressModel = ColorGradientModel.progress();
}

//进度中间的widget设置
class CenterSet {
  //进度条中间颜色会根据进度取反的文案
  final String centerText;
  //进度条中间颜色会根据进度取反的字体样式,这里的文字颜色设置没有用，取得是背景色和进度色
  final TextStyle centerTextStyle;
  //其他的剧中显示widget。优先级高于上面的设置
  final Widget? center;
  CenterSet(
      {this.centerText = '',
      this.centerTextStyle = defaultTextStyle,
      this.center});
  const CenterSet.normalSet()
      : centerText = '',
        centerTextStyle = defaultTextStyle,
        center = null;

  static const CenterSet normal = CenterSet.normalSet();
}
