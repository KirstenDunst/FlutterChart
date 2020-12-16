/*
 * @Author: your name
 * @Date: 2020-10-14 13:06:15
 * @LastEditTime: 2020-11-09 17:37:15
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter_chart/lib/chart/view/chart_line.dart
 */
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_line.dart';
import 'package:flutter_chart_csx/chart/painter/chart_line_painter.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class ChartLine extends StatefulWidget {
  final Size size; //宽高
  final Color backgroundColor; //绘制的背景色
  final BaseBean baseBean;
  final List<ChartBeanSystem> chartBeanSystems; //绘制线条的参数内容

  const ChartLine({
    Key key,
    @required this.size,
    @required this.chartBeanSystems,
    this.backgroundColor,
    this.baseBean,
  })  : assert(size != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => ChartLineState();
}

class ChartLineState extends State<ChartLine>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var painter = ChartLinePainter(widget.chartBeanSystems);
    painter..baseBean = widget.baseBean;
    return CustomPaint(
      size: widget.size,
      painter: widget.backgroundColor == null ? painter : null,
      foregroundPainter: widget.backgroundColor != null ? painter : null,
      child: widget.backgroundColor != null
          ? Container(
              width: widget.size.width,
              height: widget.size.height,
              color: widget.backgroundColor,
            )
          : null,
    );
  }
}
