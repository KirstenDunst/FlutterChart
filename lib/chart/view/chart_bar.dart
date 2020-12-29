/*
 * @Author: your name
 * @Date: 2020-09-29 13:25:19
 * @LastEditTime: 2020-12-29 10:43:32
 * @LastEditors: Cao Shixin
 * @Description: In User Settings Edit
 * @FilePath: /flutter_chart/lib/chart/view/chart_bar.dart
 */
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_bar.dart';
import 'package:flutter_chart_csx/chart/painter/chart_bar_painter.dart';

class ChartBar extends StatefulWidget {
  final Size size;
  //绘制的背景色
  final Color backgroundColor;
  //x轴刻度显示，不传则没有
  final List<ChartBarBeanX> xDialValues;
  final BaseBean baseBean;
  //柱状图的宽度
  final double rectWidth;
  //柱状图顶部的数值显示，默认透明即不显示
  final TextStyle rectTopTextStyle;
  //以下的四周圆角
  final BorderRadius borderRadius;

  const ChartBar({
    Key key,
    @required this.size,
    @required this.xDialValues,
    this.baseBean,
    this.backgroundColor,
    this.rectWidth = 20,
    this.rectTopTextStyle,
    this.borderRadius = BorderRadius.zero,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChartBarState();
}

class ChartBarState extends State<ChartBar>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var painter = ChartBarPainter(
      widget.xDialValues,
      rectWidth: widget.rectWidth,
      rectTopTextStyle: widget.rectTopTextStyle,
      borderRadius: widget.borderRadius,
    );
    painter..baseBean = widget.baseBean;
    return CustomPaint(
        size: widget.size,
        foregroundPainter: widget.backgroundColor != null ? painter : null,
        child: widget.backgroundColor != null
            ? Container(
                width: widget.size.width,
                height: widget.size.height,
                color: widget.backgroundColor,
              )
            : null,
        painter: widget.backgroundColor == null ? painter : null);
  }
}
