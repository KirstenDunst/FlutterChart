import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean.dart';
import 'package:flutter_chart_csx/chart/painter/chart_bar_painter.dart';

class ChartBar extends StatefulWidget {
  final Duration duration;
  final Size size;
  final List<ChartBeanX> xDialValues; //x轴刻度显示，不传则没有
  final List<ChartBeanY> yDialValues; //y轴左侧刻度显示，不传则没有
  final double yMax; //y轴最大值
  final Color xyColor; //xy轴的颜色
  final Color backgroundColor; //绘制的背景色
  final bool isShowX; //是否显示x刻度
  final double rectWidth; //柱状图的宽度
  //以下的四周圆角只有在 rectRadius 为0的时候才生效
  final double rectRadiusTopLeft, rectRadiusTopRight;
  final bool isAnimation; //是否执行动画
  final bool isReverse; //是否循环执行动画
  final double fontSize; //刻度文本大小
  final Color fontColor; //文本颜色
  final bool isCanTouch; //是否可以触摸
  final Color rectShadowColor; //触摸时显示的阴影颜色
  final bool isShowTouchShadow; //触摸时是否显示阴影
  final bool isShowTouchValue; //触摸时是否显示值
  final double offsetLeftX; //距离左侧设备边的距离，用来计算长按的文案显示位置计算。
  final double basePadding; //默认的边距

  const ChartBar({
    Key key,
    @required this.size,
    @required this.xDialValues,
    this.yDialValues,
    this.xyColor,
    this.duration = const Duration(milliseconds: 800),
    this.backgroundColor,
    this.isShowX = false,
    this.rectWidth = 20,
    this.offsetLeftX = 0,
    this.isAnimation = true,
    this.isReverse = false,
    this.fontSize = 12,
    this.fontColor,
    this.rectShadowColor,
    this.isCanTouch = false,
    this.isShowTouchShadow = true,
    this.isShowTouchValue = false,
    this.rectRadiusTopLeft = 0,
    this.rectRadiusTopRight = 0,
    this.basePadding = 16,
    this.yMax,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChartBarState();
}

class ChartBarState extends State<ChartBar>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double _value = 0;
  Offset globalPosition;
  double begin = 0.0, end = 1.0;

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
    var painter = ChartBarPainter(
      widget.xDialValues,
      yDialValues: widget.yDialValues,
      xyColor: widget.xyColor,
      yMax: widget.yMax,
      isShowX: widget.isShowX,
      rectWidth: widget.rectWidth,
      value: _value,
      fontSize: widget.fontSize,
      fontColor: widget.fontColor,
      isCanTouch: widget.isCanTouch,
      isShowTouchShadow: widget.isShowTouchShadow,
      isShowTouchValue: widget.isShowTouchValue,
      rectShadowColor: widget.rectShadowColor,
      globalPosition: globalPosition,
      rectRadiusTopLeft: widget.rectRadiusTopLeft,
      rectRadiusTopRight: widget.rectRadiusTopRight,
      basePadding: widget.basePadding,
    );

    if (widget.isCanTouch) {
      return GestureDetector(
        onLongPressStart: (details) {
          setState(() {
            globalPosition = Offset(
                details.globalPosition.dx - widget.offsetLeftX,
                details.globalPosition.dy);
          });
        },
        onLongPressMoveUpdate: (details) {
          setState(() {
            globalPosition = Offset(
                details.globalPosition.dx - widget.offsetLeftX,
                details.globalPosition.dy);
          });
        },
        onLongPressUp: () async {
          await Future.delayed(Duration(milliseconds: 800)).then((_) {
            setState(() {
              globalPosition = null;
            });
          });
        },
        child: CustomPaint(
            size: widget.size,
            foregroundPainter: widget.backgroundColor != null ? painter : null,
            child: widget.backgroundColor != null
                ? Container(
                    width: widget.size.width,
                    height: widget.size.height,
                    color: widget.backgroundColor,
                  )
                : null,
            painter: widget.backgroundColor == null ? painter : null),
      );
    } else {
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
}
