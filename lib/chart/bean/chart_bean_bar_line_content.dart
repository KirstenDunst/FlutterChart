//点击的时候带出来的参数
import 'package:flutter/material.dart';

class LineBarTouchBackModel {
  bool needRefresh;
  Offset? startOffset;
  Size size;
  dynamic backParam;
  LineBarTouchBackModel(
      {this.needRefresh = true,
      this.startOffset,
      required this.size,
      this.backParam});
}

class LineBarTouchCellModel {
  //开始的点，左上角
  Offset begainPoint;
  //柱体的大小
  Size size;
  //柱体中间的x轴
  double get centerX => begainPoint.dx + size.width / 2;
  //柱体的点击外带参数
  dynamic param;
  LineBarTouchCellModel(
      {required this.begainPoint, required this.size, this.param});
}
