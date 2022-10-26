import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_bar.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_bar_content.dart';
import 'package:flutter_chart_csx/chart/enum/painter_const.dart';
import 'package:flutter_chart_csx/chart/painter/base_painter.dart';
import 'package:flutter_chart_csx/chart/painter/base_painter_tool.dart';

class ChartBarPainter extends BasePainter {
  //当前动画值
  double? value;
  //x轴刻度显示，不传则没有
  List<ChartBarBeanX> xDialValues;
  //柱状图的宽度,如果小的话按照这个显示，如果过于宽，则按照平均宽度减去最小间距5得出的宽度
  double? rectWidth;

  late double _fixedHeight, _fixedWidth, _startX, _endX, _startY, _endY;
  //柱状图的间距
  late double _rectPadding;
  //每一个柱状图的基本宽度
  late double _cellWidth;
  late double _rectWidth;
  late List<BarTouchCellModel> _touchCellModels;

  ChartBarPainter(
    this.xDialValues, {
    this.value = 1,
    this.rectWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    _init(size);
    //xy轴
    _drawXy(canvas, size);
    //柱状图
    _drawBar(canvas, size);
  }

  /// 初始化
  void _init(Size size) {
    _startX = baseBean.basePadding.left;
    _endX = size.width - baseBean.basePadding.right;
    _startY = size.height - baseBean.basePadding.bottom;
    _endY = baseBean.basePadding.top;
    _fixedHeight = _startY - _endY;
    _fixedWidth = _endX - _startX;
    _rectPadding = 5; //最小间距安排到5
    _rectWidth = rectWidth ?? 20.0;
    _cellWidth = _fixedWidth / (xDialValues.isEmpty ? 1 : xDialValues.length);
    if (_rectWidth > (_cellWidth - _rectWidth)) {
      _rectWidth = _cellWidth - _rectPadding;
    } else {
      _rectPadding = _cellWidth - _rectWidth;
    }
    _touchCellModels = <BarTouchCellModel>[];
  }

  /// x,y轴绘制
  void _drawXy(Canvas canvas, Size size) {
    var tempXArr = <DialStyleX>[];
    var halfCellRetioy = _cellWidth * 0.5 / _fixedWidth;
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
    if (xDialValues.isEmpty) return;
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    if (baseBean.yAdmissSecValue <= 0) return;
    var length = xDialValues.length;
    for (var i = 0; i < length; i++) {
      var defaultColors = [defaultColor.withOpacity(0.1), defaultColor];
      var sectionColors = [
        SectionColor(
            starRate: 0,
            endRate: 1,
            gradualColor: defaultColors,
            borderRadius: BorderRadius.zero)
      ];
      if (xDialValues[i].sectionColors != null &&
          xDialValues[i].sectionColors!.isNotEmpty) {
        sectionColors.clear();
        xDialValues[i].sectionColors!.forEach((element) {
          var starRatio = element.starRate;
          var endRatio = element.endRate;
          if (starRatio > endRatio) {
            starRatio = element.endRate;
            endRatio = element.starRate;
          }
          sectionColors.add(SectionColor(
              starRate: starRatio,
              endRate: endRatio,
              gradualColor: element.gradualColor,
              borderRadius: element.borderRadius));
        });
      }
      var left = _startX +
          (_rectPadding + _rectWidth) * i +
          _cellWidth / 2 -
          _rectWidth / 2;
      var right = left + _rectWidth;
      var contentHeight =
          ((xDialValues[i].value.clamp(baseBean.yMin, baseBean.yMax) -
                      baseBean.yMin) /
                  baseBean.yAdmissSecValue *
                  _fixedHeight) *
              (value ?? 1.0);
      _touchCellModels.add(
        BarTouchCellModel(
          begainPoint: Offset(left, _startY - contentHeight),
          size: Size(_rectWidth, contentHeight),
          param: xDialValues[i].touchBackParam,
        ),
      );
      //多段绘制
      sectionColors.forEach((element) {
        var starHeight = _startY - contentHeight * (min(element.endRate, 1.0));
        var endHeight = _startY - contentHeight * max(element.starRate, 0.0);
        var rect = Rect.fromLTRB(left, starHeight, right, endHeight);
        paint.shader = LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.mirror,
                colors: element.gradualColor ?? defaultColors)
            .createShader(rect);
        var borderRad = element.borderRadius;
        canvas.drawRRect(
            RRect.fromRectAndCorners(rect,
                topLeft: borderRad.topLeft,
                topRight: borderRad.topRight,
                bottomLeft: borderRad.bottomLeft,
                bottomRight: borderRad.bottomRight),
            paint);
      });
      //顶部文字
      var topText = '${xDialValues[i].rectTopText}';
      var numChange = double.tryParse(topText);
      if (numChange != null) {
        var valueNum = value ?? 1.0;
        if (valueNum < 1.0) {
          topText = '${(numChange * valueNum).toStringAsFixed(1)}';
        }
      }
      var rectTopTextStyle = xDialValues[i].rectTopTextStyle;
      var topTextPainter = TextPainter(
          textAlign: TextAlign.center,
          ellipsis: '.',
          maxLines: 1,
          text: TextSpan(text: topText, style: rectTopTextStyle),
          textDirection: TextDirection.ltr)
        ..layout();
      var xPoint = (left + right) / 2;
      topTextPainter.paint(
          canvas,
          Offset(xPoint - topTextPainter.width / 2,
              _startY - contentHeight - 3 - topTextPainter.height));
    }
  }

  //外部拖拽获取触摸点最近的点位, 点击坐标轴以外区域直接返回空offset，和取消一样的效果
  TouchBackModel getNearbyPoint(Offset localPosition,
      {bool defaultCancelTouchChoose = true}) {
    if (localPosition.dx <= _startX ||
        localPosition.dx >= _endX ||
        localPosition.dy >= _startY ||
        localPosition.dy <= _endY) {
      //不在坐标轴内部的点击
      if (defaultCancelTouchChoose) {
        return TouchBackModel(
          startOffset: null,
          size: Size.zero,
        );
      } else {
        return TouchBackModel(
            needRefresh: false, startOffset: null, size: Size.zero);
      }
    }
    _touchCellModels.sort((a, b) => a.centerX.compareTo(b.centerX));
    BarTouchCellModel? touchModel;
    for (var i = 0; i < _touchCellModels.length - 1; i++) {
      var currentX = _touchCellModels[i].centerX;
      var nextX = _touchCellModels[i + 1].centerX;
      if (i == 0 && localPosition.dx < currentX) {
        touchModel = _touchCellModels.first;
        break;
      }
      if (i == _touchCellModels.length - 2 && localPosition.dx >= nextX) {
        touchModel = _touchCellModels[i + 1];
        break;
      }
      if (localPosition.dx >= currentX && localPosition.dx < nextX) {
        var speaceWidth = nextX - currentX;
        if (localPosition.dx <= currentX + speaceWidth / 2) {
          touchModel = _touchCellModels[i];
        } else {
          touchModel = _touchCellModels[i + 1];
        }
        break;
      }
    }
    if (touchModel == null) {
      return TouchBackModel(
        startOffset: null,
        size: Size.zero,
      );
    } else {
      return TouchBackModel(
          startOffset: touchModel.begainPoint,
          size: touchModel.size,
          backParam: touchModel.param);
    }
  }
}
