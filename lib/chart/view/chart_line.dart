import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean.dart';
import 'package:flutter_chart_csx/chart/painter/chart_line_painter.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class ChartLine extends StatefulWidget {
  final Size size; //宽高
  final Color backgroundColor; //绘制的背景色
  final double xyLineWidth; //xy轴线条的宽度
  final Color xColor, yColor; //xy轴的颜色
  final double yMax; //y轴最大值，用来计算内部绘制点的y轴位置
  final double rulerWidth; //刻度的宽度或者高度
  final List<DialStyle> yDialValues; //y轴左侧刻度显示，不传则没有
  final bool isShowHintX, isShowHintY; //x、y轴的辅助线
  final bool hintLineSolid; //辅助线是否为实线，在显示辅助线的时候才有效，false的话为虚线，默认实线
  final Color hintLineColor; //辅助线颜色
  final List<ChartBeanSystem> chartBeanSystems; //绘制线条的参数内容
  final bool isShowBorderTop, isShowBorderRight; //顶部和右侧的辅助线

  const ChartLine({
    Key key,
    @required this.size,
    @required this.chartBeanSystems,
    this.backgroundColor,
    this.xyLineWidth = 2,
    this.xColor,
    this.yColor,
    this.rulerWidth = 8,
    this.yMax,
    this.yDialValues,
    this.isShowHintX = false,
    this.isShowHintY = false,
    this.hintLineSolid = true,
    this.hintLineColor,
    this.isShowBorderTop = false,
    this.isShowBorderRight = false,
  })  : assert(size != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => ChartLineState();
}

class ChartLineState extends State<ChartLine>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var painter = ChartLinePainter(
      widget.chartBeanSystems,
      xyLineWidth: widget.xyLineWidth,
      xColor: widget.xColor,
      yColor: widget.yColor,
      rulerWidth: widget.rulerWidth,
      yMax: widget.yMax,
      yDialValues: widget.yDialValues,
      isShowHintX: widget.isShowHintX,
      isShowHintY: widget.isShowHintY,
      hintLineSolid: widget.hintLineSolid,
      hintLineColor: widget.hintLineColor,
      isShowBorderTop: widget.isShowBorderTop,
      isShowBorderRight: widget.isShowBorderRight,
    );
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
