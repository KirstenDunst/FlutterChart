import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_bar.dart';
import 'package:flutter_chart_csx/chart/enum/painter_const.dart';
import 'package:flutter_chart_csx/chart/painter/base_painter.dart';
import 'package:flutter_chart_csx/chart/painter/base_painter_tool.dart';

class ChartBarPainter extends BasePainter {
  //x轴刻度显示，不传则没有
  List<ChartBarBeanX> xDialValues;
  //柱状图的宽度,如果小的话按照这个显示，如果过于宽，则按照平均宽度减去最小间距5得出的宽度
  double rectWidth;
  //柱状图顶部的数值显示，默认透明即不显示
  TextStyle? rectTopTextStyle;
  //以下的四周圆角,默认没有圆角
  BorderRadius borderRadius;

  double? _fixedHeight, _fixedWidth, _startX, _endX, _startY, _endY;
  //柱状图的间距
  late double _rectPadding;
  //每一个柱状图的基本宽度
  late double _cellWidth;

  ChartBarPainter(
    this.xDialValues, {
    this.rectTopTextStyle,
    this.rectWidth = 20.0,
    this.borderRadius = BorderRadius.zero,
  }) : assert(xDialValues != null);

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    _init(size);
    //xy轴
    _drawXy(canvas, size);
    //柱状图
    _drawBar(canvas, size);
  }

  @override
  bool shouldRepaint(ChartBarPainter oldDelegate) {
    return true;
  }

  /// 初始化
  void _init(Size size) {
    _startX = baseBean!.basePadding.left;
    _endX = size.width - baseBean!.basePadding.right;
    _startY = size.height - baseBean!.basePadding.bottom;
    _endY = baseBean!.basePadding.top;
    _fixedHeight = _startY! - _endY!;
    _fixedWidth = _endX! - _startX!;
    _rectPadding = 5; //最小间距安排到5
    _cellWidth = _fixedWidth! / (xDialValues.isEmpty ? 1 : xDialValues.length);
    if (rectWidth > (_cellWidth - rectWidth)) {
      rectWidth = _cellWidth - _rectPadding;
    } else {
      _rectPadding = _cellWidth - rectWidth;
    }
    rectTopTextStyle ??= TextStyle(color: Colors.transparent, fontSize: 0);
  }

  /// x,y轴绘制
  void _drawXy(Canvas canvas, Size size) {
    var tempXArr = <DialStyleX>[];
    var halfCellRetioy = _cellWidth * 0.5 / _fixedWidth!;
    for (var i = 0; i < xDialValues.length; i++) {
      tempXArr.add(DialStyleX(
          title: xDialValues[i].title,
          titleStyle: xDialValues[i].titleStyle,
          positionRetioy: i / xDialValues.length + halfCellRetioy));
    }
    PainterTool.drawCoordinateAxis(
        canvas,
        CoordinateAxisModel(
          _fixedHeight,
          _fixedWidth,
          baseBean: baseBean,
          xDialValues: tempXArr,
        ));
  }

  /// 柱状图
  void _drawBar(Canvas canvas, Size size) {
    if (xDialValues == null || xDialValues.isEmpty) return;
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    if (baseBean!.yMax <= 0) return;
    var length = xDialValues.length;
    for (var i = 0; i < length; i++) {
      List<Color>? gradualColors = [defaultColor.withOpacity(0.1), defaultColor];
      if (xDialValues[i].gradualColor != null) {
        gradualColors = xDialValues[i].gradualColor;
      }
      var left = _startX! +
          (_rectPadding + rectWidth) * i +
          _cellWidth / 2 -
          rectWidth / 2;
      var right = left + rectWidth;
      var currentHeight =
          _startY! - (xDialValues[i].value ?? 0) / baseBean!.yMax * _fixedHeight!;
      var rect = Rect.fromLTRB(left, currentHeight, right, _startY!);
      paint.shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.mirror,
              colors: gradualColors!)
          .createShader(rect);
      canvas.drawRRect(
          RRect.fromRectAndCorners(rect,
              topLeft: borderRadius.topLeft,
              topRight: borderRadius.topRight,
              bottomLeft: borderRadius.bottomLeft,
              bottomRight: borderRadius.bottomRight),
          paint);
      var topTextPainter = TextPainter(
          textAlign: TextAlign.center,
          ellipsis: '.',
          maxLines: 1,
          text: TextSpan(
              text: '${xDialValues[i].value ?? ''}', style: rectTopTextStyle),
          textDirection: TextDirection.ltr)
        ..layout();
      var xPoint = (left + right) / 2;
      topTextPainter.paint(
          canvas,
          Offset(xPoint - topTextPainter.width / 2,
              currentHeight - 3 - topTextPainter.height));
    }
  }
}
