/*
 * @Author: Cao Shixin
 * @Date: 2020-07-17 17:38:11
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-08-20 20:00:48
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_dimensionality.dart';
import 'package:flutter_chart_csx/chart/painter/chart_dimensionality_painter.dart';

class ChartDimensionality extends StatefulWidget {
  final List<ChartBeanDimensionality> dimensionalityDivisions; //维度划分的重要参数
  final List<DimensionalityBean> dimensionalityTags; //维度填充数据的重要内容
  final Size size; //宽高
  final double lineWidth; //线宽
  final bool isDotted; //背景网是否为虚线
  final Color lineColor; //线条颜色
  final double centerR; //圆半径
  final int dimensionalityNumber; //阶层：维度图从中心到最外层有几圈

  final Color backgroundColor; //绘制的背景色
  final Duration duration; //动画时长
  final bool isAnimation; //是否执行动画
  final bool isReverse; //是否重复执行动画

  const ChartDimensionality({
    Key key,
    @required this.size,
    @required this.dimensionalityDivisions,
    this.dimensionalityTags,
    this.lineWidth = 4,
    this.isDotted = false,
    this.lineColor,
    this.centerR,
    this.dimensionalityNumber = 4,
    this.backgroundColor,
    this.duration = const Duration(milliseconds: 800),
    this.isReverse = false,
    this.isAnimation = true,
  })  : assert(dimensionalityDivisions != null &&
            dimensionalityDivisions.length > 2),
        assert(size != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => ChartDimensionalityState();
}

class ChartDimensionalityState extends State<ChartDimensionality>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double _value = 0;
  double begin = 0.0, end = 1.0;
  Offset globalPosition;

  @override
  void initState() {
    super.initState();
    if (widget.isAnimation) {
      _controller = AnimationController(vsync: this, duration: widget.duration);
      Tween(begin: begin, end: end).animate(_controller)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            if (widget.isReverse) {
              _controller.repeat(reverse: widget.isReverse);
            }
          }
        })
        ..addListener(() {
          _value = _controller.value;
          setState(() {});
        });
      _controller.forward();
    }
  }

  @override
  void dispose() {
    if (_controller != null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var painter = ChartDimensionalityPainter(
      widget.dimensionalityDivisions,
      dimensionalityTags: widget.dimensionalityTags,
      value: _value,
      lineColor: widget.lineColor,
      lineWidth: widget.lineWidth,
      isDotted: widget.isDotted,
      centerR: widget.centerR,
      dimensionalityNumber: widget.dimensionalityNumber,
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
