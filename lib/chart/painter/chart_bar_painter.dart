import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/bean/chart_bean.dart';
import 'package:flutter_chart/chart/painter/base_painter.dart';

class ChartBarPainter extends BasePainter {
  double _fixedHeight, _fixedWidth; //宽高
  double value; //当前动画值
  double startX, endX, startY, endY;
  List<ChartBeanX> xDialValues; //x轴刻度显示，不传则没有
  List<ChartBeanY> yDialValues; //y轴左侧刻度显示，不传则没有
  double yMax; //y轴最大值
  Color xyColor; //xy轴的颜色
  bool isShowX; //是否显示x轴文本, 
  double rectWidth; //柱状图的宽度,如果小的话按照这个显示，如果过于宽，则按照平均宽度减去最小间距5得出的宽度
  double fontSize; //刻度文本大小
  Color fontColor; //刻度文本颜色
  //以下的四周圆角
  double rectRadiusTopLeft, rectRadiusTopRight;
  bool _isAnimationEnd = false;
  bool isCanTouch;
  Color rectShadowColor; //触摸时显示的阴影颜色
  bool isShowTouchShadow; //触摸时是否显示阴影
  bool isShowTouchValue; //触摸时是否显示值
  Offset globalPosition; //触摸位置
  Map<Rect, double> rectMap = new Map();
  double basePadding; //默认的边距

  static const Color defaultColor = Colors.deepPurple;
  static const Color defaultRectShadowColor = Colors.white;
  double rectPadding; //柱状图的间距
  double cellWidth; //每一个柱状图的基本宽度
  //坐标轴多出的长度
  static const double overPadding = 5;

  ChartBarPainter(
    this.xDialValues, {
    this.yDialValues,
    this.yMax,
    this.xyColor,
    this.value = 1,
    this.isShowX = false,
    this.rectWidth = 20.0,
    this.fontSize = 12,
    this.fontColor,
    this.isCanTouch = false,
    this.isShowTouchShadow = true,
    this.isShowTouchValue = false,
    this.rectShadowColor,
    this.globalPosition,
    this.rectRadiusTopLeft = 0,
    this.rectRadiusTopRight = 0,
    this.basePadding = 16,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _init(size);
    _drawXy(canvas, size); //xy轴
    _drawX(canvas, size); //x轴刻度
    _drawBar(canvas, size); //柱状图
    _drawOnPressed(canvas, size); //绘制触摸
  }

  @override
  bool shouldRepaint(ChartBarPainter oldDelegate) {
    _isAnimationEnd = oldDelegate.value == value;
    return oldDelegate.value != value || isCanTouch;
  }

  ///初始化
  void _init(Size size) {
    startX = basePadding * 2.5;
    endX = size.width - basePadding;
    startY = size.height - (isShowX ? basePadding * 3 : basePadding);
    endY = basePadding * 2;
    _fixedHeight = startY - endY;
    _fixedWidth = endX - startX;
    if (yMax == null || yMax == 0) {
      yMax = calculateMaxMinNew(xDialValues).first;
    }

    rectPadding = 5; //最小间距安排到5
    cellWidth = _fixedWidth / xDialValues.length;
    if (rectWidth > (cellWidth - rectWidth)) {
      rectWidth = cellWidth - rectPadding;
    } else {
      rectPadding = cellWidth - rectWidth;
    }
    if (xyColor == null) {
      xyColor = defaultColor;
    }
  }

  ///x,y轴
  void _drawXy(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..color = xyColor
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
        Offset(startX, startY), Offset(endX + overPadding, startY), paint); //x轴
    canvas.drawLine(
        Offset(startX, startY), Offset(startX, endY - overPadding), paint); //y轴
    _drawRuler(canvas, size);
  }

  //y轴刻度
  void _drawRuler(Canvas canvas, Size size) {
    if (yDialValues == null || yDialValues.length == 0) {
      return;
    }
    for (int i = 0; i < yDialValues.length; i++) {
      var tempYModel = yDialValues[i];

      ///绘制y轴文本
      var yValue = tempYModel.title;
      var yLength = tempYModel.positionRetioy * _fixedHeight;
      TextPainter tpTitle = TextPainter(
          textAlign: TextAlign.right,
          ellipsis: '.',
          maxLines: 1,
          text: TextSpan(text: '$yValue', style: tempYModel.titleStyle),
          textDirection: TextDirection.rtl)
        ..layout(minWidth: 30, maxWidth: 30);
        tpTitle.paint(
            canvas,
            Offset(startX - 40,
                startY - yLength - tpTitle.height / 2));
      //副文本
      var subLength = (yDialValues[i].titleValue -
              (i == yDialValues.length - 1
                  ? 0
                  : yDialValues[i + 1].titleValue)) /
          2 /
          yMax *
          _fixedHeight;
      TextDirection textDirection = TextDirection.rtl;
      TextPainter tp = TextPainter(
          textAlign: TextAlign.center,
          ellipsis: '.',
          maxLines: 1,
          text: TextSpan(
              text: tempYModel.centerSubTitle,
              style: tempYModel.centerSubTextStyle),
          textDirection: textDirection)
        ..layout(minWidth: 40, maxWidth: 40);
      tp.paint(
          canvas,
          Offset(
              startX - 40, startY - yLength + subLength.abs() - tp.height / 2));
    }
  }

  ///x轴刻度
  void _drawX(Canvas canvas, Size size) {
    if (xDialValues != null && xDialValues.length > 0) {
      for (int i = 0; i < xDialValues.length; i++) {
        double x = startX + (rectPadding + rectWidth) * i;
        TextPainter(
            ellipsis: '.',
            maxLines: 1,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            text: TextSpan(
                text: xDialValues[i].title,
                style: xDialValues[i].titleStyle != null ? xDialValues[i].titleStyle : TextStyle(
                  color: fontColor != null ? fontColor : defaultColor,
                  fontSize: fontSize,
                )))
          ..layout(minWidth: cellWidth, maxWidth: cellWidth)
          ..paint(canvas, Offset(x, startY + basePadding));
      }
    }
  }

  ///柱状图
  void _drawBar(Canvas canvas, Size size) {
    if (xDialValues == null || xDialValues.length == 0) return;
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    if (yMax <= 0) return;
    rectMap.clear();
    var length = xDialValues.length;
    for (int i = 0; i < length; i++) {
      List<Color> gradualColors = [rectShadowColor, rectShadowColor];
      if (xDialValues[i].gradualColor != null) {
        gradualColors = xDialValues[i].gradualColor;
      }
      double left = startX +
          (rectPadding + rectWidth) * i +
          cellWidth / 2 -
          rectWidth / 2;
      double right = left + rectWidth;
      double currentHeight =
          startY - xDialValues[i].value / yMax * _fixedHeight * value;
      var rect = Rect.fromLTRB(left, currentHeight, right, startY);
      paint.shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.mirror,
              colors: gradualColors)
          .createShader(rect);
      canvas.drawRRect(
          RRect.fromRectAndCorners(rect,
              topLeft: Radius.circular(rectRadiusTopLeft),
              topRight: Radius.circular(rectRadiusTopRight)),
          paint);
      if (!rectMap.containsKey(rect)) rectMap[rect] = xDialValues[i].value;
    }
  }

  ///绘制触摸
  void _drawOnPressed(Canvas canvas, Size size) {
    if (!_isAnimationEnd) return;
    if (globalPosition == null) return;
    if (xDialValues == null || xDialValues.length == 0 || yMax <= 0) return;
    try {
      Offset pointer = globalPosition;

      ///修复x轴越界
      if (pointer.dx < startX) pointer = Offset(startX, pointer.dy);
      if (pointer.dx > endX) pointer = Offset(endX, pointer.dy);

      //查找当前触摸点对应的rect
      Rect currentRect;
      var yValue;
      rectMap.forEach((rect, value) {
        if ((rect.left - rectPadding / 2) <= (pointer.dx) &&
            (pointer.dx) <= (rect.right + rectPadding / 2)) {
          currentRect = rect;
          yValue = value;
        }
      });
      if (currentRect != null) {
        if (isShowTouchShadow) {
          var paint = new Paint()
            ..isAntiAlias = true
            ..color = rectShadowColor == null
                ? defaultRectShadowColor.withOpacity(0.5)
                : rectShadowColor;

          canvas.drawRRect(
              RRect.fromRectAndCorners(currentRect,
                  topLeft: Radius.circular(rectRadiusTopLeft),
                  topRight: Radius.circular(rectRadiusTopRight)),
              paint);
        }

        ///绘制文本
        if (isShowTouchValue) {
          TextPainter(
              textAlign: TextAlign.center,
              ellipsis: '.',
              maxLines: 1,
              text: TextSpan(
                  text: "$yValue",
                  style: TextStyle(color: fontColor, fontSize: fontSize)),
              textDirection: TextDirection.ltr)
            ..layout(minWidth: 40, maxWidth: 40)
            ..paint(canvas,
                Offset(currentRect.left, currentRect.top - basePadding));
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
