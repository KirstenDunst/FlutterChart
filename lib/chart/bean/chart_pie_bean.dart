import 'dart:ui';

import 'package:flutter/material.dart';

class ChartPieBean {
  double value;
  String type;
  Color color;
  //辅助性文案展示的文案样式
  TextStyle assistTextStyle;
  //辅助性文案（内部计算勿传）
  String assistText;
  //所占比例（内部计算勿传）
  double rate;
  //开始角度
  double startAngle;
  //所占角度
  double sweepAngle; 

  ChartPieBean(
      {@required this.value,
      this.type,
      this.color,
      this.assistTextStyle,
      this.rate,
      this.startAngle,
      this.sweepAngle});
}


//辅助性文案的显示类型
enum AssistTextShowType {
  //显示
  None,
  //只显示占比并显示在图标中心
  CenterOnlyPercentage,
  //显示占比+名称并显示在图标中心
  CenterNamePercentage,
}