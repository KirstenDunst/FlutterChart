/*
 * @Author: your name
 * @Date: 2020-09-29 13:25:19
 * @LastEditTime: 2021-05-07 09:18:13
 * @LastEditors: Cao Shixin
 * @Description: In User Settings Edit
 * @FilePath: /flutter_chart/lib/chart/painter/base_painter.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/base/chart_bean.dart';

class BasePainter extends CustomPainter {
  //基础设置
  late BaseBean baseBean;

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
