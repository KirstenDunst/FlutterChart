/*
 * @Author: your name
 * @Date: 2020-09-29 13:25:19
 * @LastEditTime: 2020-11-09 17:37:34
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter_chart/lib/chart/painter/base_painter.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean.dart';
import 'package:flutter_chart_csx/chart/enum/painter_const.dart';

class BasePainter extends CustomPainter {
  //基础设置
  BaseBean? baseBean;

  @override
  void paint(Canvas canvas, Size size) {
    baseBean ??= BaseBean();
    baseBean!
      ..xyLineWidth 
      ..xColor
      ..yColor 
      ..isShowBorderTop 
      ..isShowBorderRight 
      ..isLeftYDialSub
      ..isShowX 
      ..yMax
      ..basePadding 
      ..isShowHintX 
      ..isShowHintY 
      ..hintLineColor 
      ..hintLineWidth 
      ..isHintLineImaginary 
      ..isShowXScale 
      ..isShowYScale
      ..rulerWidth;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
