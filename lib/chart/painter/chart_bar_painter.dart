import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/base/chart_bean.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_bar.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_bar_content.dart';
import 'package:flutter_chart_csx/chart/base/base_painter.dart';
import 'package:flutter_chart_csx/chart/util/base_painter_tool.dart';

import '../base/painter_const.dart';

class ChartBarPainter extends BasePainter {
  //当前动画值
  double? value;
  //x轴刻度显示，不传则没有
  List<ChartBarBeanX> xDialValues;
  //柱状图的宽度,如果小的话按照这个显示，如果过于宽，则按照平均宽度减去柱体之间间距得出的宽度
  double? rectWidth;
  //柱体之间的间距,默认5
  double rectSpace;
  //选中的index,用于特殊显示当前选中添加区间蒙层处理
  int? selectIndex;
  SelectModelSet? selectModelSet;
  //基准y值(影响柱体正向增长(大于基准线)还是反向增长(小于基准线))，
  //不设置表示从x轴向上增长
  final double? baseLineY;

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
    this.baseLineY,
    this.rectSpace = 5,
    this.selectIndex,
    this.selectModelSet,
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
    _rectPadding = rectSpace;
    _rectWidth = rectWidth ?? 20.0;
    _cellWidth = _fixedWidth / (xDialValues.isEmpty ? 1 : xDialValues.length);
    if (_rectPadding > (_cellWidth - _rectWidth)) {
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
      var cellModel = xDialValues[i];
      var tempBottomModel = cellModel.xBottomTextModel;
      var positionRetioy = i / xDialValues.length + halfCellRetioy;
      if (tempBottomModel != null && tempBottomModel.title.isNotEmpty) {
        tempXArr.add(DialStyleX(
            title: tempBottomModel.title,
            titleStyle: tempBottomModel.titleStyle,
            positionRetioy: positionRetioy));
      }

      //区间顶部内容绘制
      var xOffset = _startX + _fixedWidth * positionRetioy;
      var topTextModel = cellModel.xTopTextModel;
      if (topTextModel != null) {
        var tpx = TextPainter(
            textAlign: TextAlign.center,
            ellipsis: '.',
            text: TextSpan(
                text: topTextModel.title, style: topTextModel.titleStyle),
            textDirection: TextDirection.ltr)
          ..layout();
        tpx.paint(
            canvas,
            Offset(xOffset - tpx.width / 2,
                _endY - cellModel.xTopSpace - tpx.height));
      }
      var topImgModel = cellModel.xTopImgModel;
      if (topImgModel != null) {
        canvas.drawImageRect(
          topImgModel.img,
          Rect.fromLTWH(0, 0, topImgModel.img.width.toDouble(),
              topImgModel.img.height.toDouble()),
          Rect.fromLTWH(
              xOffset - topImgModel.imgSize.width / 2,
              _endY - topImgModel.imgSize.height - cellModel.xTopSpace,
              topImgModel.imgSize.width,
              topImgModel.imgSize.height),
          Paint(),
        );
      }
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
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    if (baseBean.yAdmissSecValue <= 0) return;
    //基准线距离x轴的高度
    var baseLineYHeight = baseLineY == null
        ? 0.0
        : ((baseLineY!.clamp(baseBean.yMin, baseBean.yMax) - baseBean.yMin) /
            (baseBean.yMax - baseBean.yMin) *
            _fixedHeight);
    for (var i = 0; i < xDialValues.length; i++) {
      var defaultColors = [defaultColor.withOpacity(0.1), defaultColor];
      var ele = xDialValues[i];
      var rectLeft = _startX + (_rectPadding + _rectWidth) * i;
      var left = rectLeft + _cellWidth / 2 - _rectWidth / 2;
      var dealLength = max(1.0, ele.beanXModels.length);
      var stepWidth =
          (_rectWidth - (dealLength - 1) * ele.cellBarSpace) / dealLength;
      var stepSpace = stepWidth + ele.cellBarSpace;
      num maxValue = 0;
      for (var j = 0; j < ele.beanXModels.length; j++) {
        var startLeft = left + stepSpace * j;
        var element = ele.beanXModels[j];
        if (element.value != null) {
          maxValue = max(maxValue, element.value!);
        }
        _barCellDraw(
            canvas,
            element,
            defaultColors,
            paint,
            //选中的绘制,只绘制第一个即可
            j == 0 && i == selectIndex && selectModelSet != null,
            rectLeft,
            startLeft,
            startLeft + stepWidth,
            baseLineYHeight);
      }
      if (ele.beanXModels.isNotEmpty) {
        var contentHeight =
            ((maxValue.clamp(baseBean.yMin, baseBean.yMax) - baseBean.yMin) /
                    baseBean.yAdmissSecValue *
                    _fixedHeight) *
                (value ?? 1.0);
        _touchCellModels.add(
          BarTouchCellModel(
            begainPoint: Offset(left, _startY - contentHeight),
            size: Size(_rectWidth, contentHeight),
            param: ele.touchBackParam,
            index: i,
          ),
        );
      }
    }
  }

  void _barCellDraw(
      Canvas canvas,
      ChartBarBeanXCell model,
      List<Color> defaultColors,
      Paint paint,
      bool showSelect,
      double rectLeft,
      double left,
      double right,
      //基准线距离x轴的高度
      double baseLineYHeight) {
    var sectionColors = [
      SectionColor(
          starRate: 0,
          endRate: 1,
          gradualColor: defaultColors,
          borderRadius: BorderRadius.zero)
    ];
    if (model.sectionColors != null && model.sectionColors!.isNotEmpty) {
      sectionColors.clear();
      model.sectionColors!.forEach((element) {
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
    var contentHeight = 0.0;
    if (model.value != null) {
      var valueClamp = model.value!.clamp(baseBean.yMin, baseBean.yMax);
      if (baseLineY == null) {
        contentHeight = (((valueClamp - baseBean.yMin) /
                baseBean.yAdmissSecValue *
                _fixedHeight) *
            (value ?? 1.0));
      } else {
        contentHeight =
            (((valueClamp - baseLineY!.clamp(baseBean.yMin, baseBean.yMax)) /
                    baseBean.yAdmissSecValue *
                    _fixedHeight) *
                (value ?? 1.0));
      }
    }

    //多段绘制
    if (contentHeight > 0) {
      //向上
      sectionColors.forEach((element) {
        var starHeight = _startY -
            baseLineYHeight -
            contentHeight * min(element.endRate, 1.0);
        var endHeight = _startY -
            baseLineYHeight -
            contentHeight * max(element.starRate, 0.0);
        var rect = Rect.fromLTRB(left, starHeight, right, endHeight);
        paint.shader = LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.clamp,
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
    } else if (contentHeight < 0) {
      //向下 (颜色和边角弧度都镜像取)
      sectionColors.forEach((element) {
        var starHeight = _startY -
            baseLineYHeight +
            contentHeight.abs() * max(element.starRate, 0.0);
        var endHeight = _startY -
            baseLineYHeight +
            contentHeight.abs() * min(element.endRate, 1.0);
        var rect = Rect.fromLTRB(left, starHeight, right, endHeight);
        paint.shader = LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                tileMode: TileMode.clamp,
                colors: element.gradualColor ?? defaultColors)
            .createShader(rect);
        var borderRad = element.borderRadius;
        canvas.drawRRect(
            RRect.fromRectAndCorners(rect,
                topLeft: borderRad.bottomLeft,
                topRight: borderRad.bottomRight,
                bottomLeft: borderRad.topLeft,
                bottomRight: borderRad.topRight),
            paint);
      });
    }

    // 如果选中,则特殊显示此区间
    if (showSelect) {
      canvas.drawRect(
          Rect.fromLTWH(rectLeft, _endY, _cellWidth, _fixedHeight),
          Paint()
            ..isAntiAlias = true
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.fill
            ..color = selectModelSet!.highLightColor);
    }
    //顶部文字
    var topText = '${model.rectTopText}';
    var numChange = double.tryParse(topText);
    if (numChange != null) {
      var valueNum = value ?? 1.0;
      if (valueNum < 1.0) {
        topText = '${(numChange * valueNum).toStringAsFixed(1)}';
      }
    }
    var topTextPainter = TextPainter(
        textAlign: TextAlign.center,
        ellipsis: '.',
        maxLines: 1,
        text: TextSpan(text: topText, style: model.rectTopTextStyle),
        textDirection: TextDirection.ltr)
      ..layout();
    var xPoint = (left + right) / 2;
    topTextPainter.paint(
        canvas,
        Offset(
            xPoint - topTextPainter.width / 2,
            _startY -
                baseLineYHeight -
                contentHeight -
                (contentHeight >= 0 ? (3 + topTextPainter.height) : -3)));
  }

  //外部拖拽获取触摸点最近的点位, 点击坐标轴以外区域直接返回空offset，和取消一样的效果
  TouchBackModel getNearbyPoint(Offset localPosition,
      {bool defaultCancelTouchChoose = true}) {
    if (value != null && value! < 1.0) {
      return TouchBackModel(startOffset: null, size: Size.zero);
    }
    if (localPosition.dx <= _startX ||
        localPosition.dx >= _endX ||
        localPosition.dy >= _startY ||
        localPosition.dy <= _endY) {
      //不在坐标轴内部的点击
      if (defaultCancelTouchChoose) {
        return TouchBackModel(startOffset: null, size: Size.zero);
      } else {
        return TouchBackModel(
            needRefresh: false, startOffset: null, size: Size.zero);
      }
    }
    _touchCellModels.sort((a, b) => a.centerX.compareTo(b.centerX));
    BarTouchCellModel? _touchModel;
    if (_touchCellModels.length <= 1) {
      _touchModel = _touchCellModels.isEmpty ? null : _touchCellModels.first;
    } else {
      for (var i = 0; i < _touchCellModels.length - 1; i++) {
        var currentX = _touchCellModels[i].centerX;
        var nextX = _touchCellModels[i + 1].centerX;
        if (i == 0 && localPosition.dx < currentX) {
          _touchModel = _touchCellModels.first;
          break;
        }
        if (i == _touchCellModels.length - 2 && localPosition.dx >= nextX) {
          _touchModel = _touchCellModels.last;
          break;
        }
        if (localPosition.dx >= currentX && localPosition.dx < nextX) {
          var speaceWidth = nextX - currentX;
          if (localPosition.dx <= currentX + speaceWidth / 2) {
            _touchModel = _touchCellModels[i];
          } else {
            _touchModel = _touchCellModels[i + 1];
          }
          break;
        }
      }
    }
    if (_touchModel == null) {
      return TouchBackModel(startOffset: null, size: Size.zero);
    } else {
      return TouchBackModel(
          startOffset: _touchModel.begainPoint,
          size: _touchModel.size,
          backParam: _touchModel.param,
          index: _touchModel.index);
    }
  }
}
