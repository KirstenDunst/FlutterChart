/*
 * @Author: Cao Shixin
 * @Date: 2020-03-29 10:26:09
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-07-03 10:27:45
 * @Description: 绘制承载区, 支持多个不同曲线的绘制
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/bean/chart_bean_focus.dart';
import 'package:flutter_chart/chart/painter/chart_line_focus_painter.dart';
import 'package:flutter_chart/flutter_chart.dart';

class ChartLineFocus extends StatefulWidget {
  final Size size; //内容宽高
  final Color backgroundColor; //绘制的内容背景色

  final List<FocusChartBeanMain> focusChartBeans;
  final Color xyColor; //xy轴的颜色
  final List<DialStyle> xDialValues; //x轴刻度显示，不传则没有
  final List<DialStyle> yDialValues; //y轴左侧刻度显示，不传则没有
  final bool isLeftYDialSub; //y轴显示副刻度是在左侧还是在右侧，默认左侧
  final int xMax; //x轴最大值（以秒为单位）
  final double yMax; //y轴最大值
  final double basePadding; //默认的边距16

  final bool isShowHintX, isShowHintY; //x、y轴的辅助线
  final Color hintLineColor; //辅助线颜色
  final bool isHintLineImaginary; //辅助线是否为虚线

  const ChartLineFocus({
    Key key,
    @required this.size,
    @required this.focusChartBeans,
    this.backgroundColor,
    this.xyColor,
    this.xDialValues,
    this.yDialValues,
    this.isLeftYDialSub,
    this.yMax,
    this.xMax,
    this.basePadding = 16,
    this.isShowHintX = false,
    this.isShowHintY = false,
    this.hintLineColor,
    this.isHintLineImaginary,
  })  : assert(size != null),
        super(key: key);

  @override
  ChartLineFocusState createState() => ChartLineFocusState();
}

class ChartLineFocusState extends State<ChartLineFocus>
    with SingleTickerProviderStateMixin {
  List<FocusChartBeanMain> _chartBeanList;

  void changeBeanList(List<FocusChartBeanMain> beans) {
    setState(() {
      _chartBeanList = beans;
    });
  }

  @override
  void initState() {
    super.initState();
    _chartBeanList = widget.focusChartBeans;
  }

  @override
  Widget build(BuildContext context) {
    var painter = ChartLineFocusPainter(
      _chartBeanList,
      xyColor: widget.xyColor,
      xDialValues: widget.xDialValues,
      yDialValues: widget.yDialValues,
      isLeftYDialSub: widget.isLeftYDialSub,
      yMax: widget.yMax,
      xMax: widget.xMax,
      basePadding: widget.basePadding,
      isShowHintX: widget.isShowHintX,
      isShowHintY: widget.isShowHintY,
      isHintLineImaginary: widget.isHintLineImaginary,
      hintLineColor: widget.hintLineColor,
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
