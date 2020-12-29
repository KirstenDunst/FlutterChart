/*
 * @Author: Cao Shixin
 * @Date: 2020-07-17 17:38:37
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-12-29 10:41:49
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_dimensionality.dart';
import 'package:flutter_chart_csx/chart/enum/painter_const.dart';
import 'package:flutter_chart_csx/chart/painter/base_painter.dart';
import 'package:path_drawing/path_drawing.dart';

class ChartDimensionalityPainter extends BasePainter {
  //维度划分的重要参数(决定有几个内容就是几个维度，从正上方顺时针方向绘制)
  List<ChartBeanDimensionality> dimensionalityDivisions;
  //维度填充数据的重要内容
  List<DimensionalityBean> dimensionalityTags;
  //线宽
  double lineWidth;
  //背景网是否为虚线
  bool isDotted;
  //线条颜色
  Color lineColor;
  //圆半径
  double centerR;
  //阶层：维度图从中心到最外层有几圈
  int dimensionalityNumber;
  //圆心
  double _centerX, _centerY, _averageAngle;

  ChartDimensionalityPainter(
    this.dimensionalityDivisions, {
    this.dimensionalityTags,
    this.lineWidth,
    this.isDotted,
    this.lineColor,
    this.centerR,
    this.dimensionalityNumber,
  });

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    //初始化数据
    _init(size);
    // 绘制基础网状结构
    _createBase(canvas, size);
    //绘制内部多边形彩色区域
    _createPaintShadowPath(canvas, size);
  }

  @override
  bool shouldRepaint(ChartDimensionalityPainter oldDelegate) {
    return true;
  }

  /// 初始化
  void _init(Size size) {
    _initValue();
    _initlizeData(size);
  }

  /// 初始化数据
  void _initValue() {
    lineColor ??= defaultColor;
    isDotted ??= false;
    lineWidth ??= 1;
    if (dimensionalityNumber == null || dimensionalityNumber == 0) {
      dimensionalityNumber = 4;
    }
  }

  /// 初始化角度
  void _initlizeData(Size size) {
    var startX = baseBean.basePadding.left;
    var endX = size.width - baseBean.basePadding.right;
    var tp = TextPainter(
        textAlign: TextAlign.center,
        ellipsis: '.',
        maxLines: 1,
        text: TextSpan(
          text: dimensionalityDivisions?.first?.tip ?? '',
          style: dimensionalityDivisions?.first?.tipStyle ??
              TextStyle(fontSize: 10),
        ),
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: size.width);
    var endY = max(baseBean.basePadding.top, tp.height + 10);
    var startY = size.height - endY;

    _centerX = startX + (endX - startX) / 2;
    _centerY = endY + (startY - endY) / 2;
    var xR = endX - _centerX;
    var yR = startY - _centerY;
    var tempCenterR = xR.compareTo(yR) > 0 ? yR : xR;
    if (centerR == null || centerR > tempCenterR) {
      centerR = tempCenterR;
    }

    _averageAngle = 2 * pi / dimensionalityDivisions.length;
  }

  /// 绘制基本角
  void _createBase(Canvas canvas, Size size) {
    var speaceIndex = centerR / dimensionalityNumber;
    for (var i = 0; i < dimensionalityNumber; i++) {
      var tempLength = centerR - speaceIndex * i;
      var basePoints = <Point>[];
      for (var j = 0; j < dimensionalityDivisions.length; j++) {
        basePoints
            .add(_getBaseCenterLengthAnglePoint(tempLength, _averageAngle * j));
        if (i == 0) {
          var model = dimensionalityDivisions[j];
          _createTextWithPara(
              model.tip, model.tipStyle, _averageAngle * j, canvas, size);
        }
      }
      var baseLinePath = Path()..moveTo(basePoints.first.x, basePoints.first.y);
      for (var k = 1; k < basePoints.length; k++) {
        var tempPoint = basePoints[k];
        baseLinePath..lineTo(tempPoint.x, tempPoint.y);
      }
      baseLinePath
        ..lineTo(basePoints.first.x, basePoints.first.y)
        ..close();
      var basePaint = Paint()
        ..strokeWidth = lineWidth
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true;
      canvas.drawPath(
          isDotted
              ? dashPath(
                  baseLinePath,
                  dashArray: CircularIntervalList<double>(<double>[5.0, 4.0]),
                )
              : baseLinePath,
          basePaint);
    }
  }

  /// 获取对应弧度在圆边角的对应点
  /// length：长度
  /// angle：角度
  Point _getBaseCenterLengthAnglePoint(double length, double angle) {
    return Point(
        _centerX + sin(angle) * length, _centerY - cos(angle) * length);
  }

  /// 绘制维度文字
  /// text：文案
  /// textStyle：文案样式
  /// angle：角度
  /// canvas：
  /// size：
  void _createTextWithPara(String text, TextStyle textStyle, double angle,
      Canvas canvas, Size size) {
    var tp = TextPainter(
        textAlign: TextAlign.center,
        ellipsis: '.',
        maxLines: 1,
        text: TextSpan(
          text: text,
          style: textStyle,
        ),
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: size.width);
    var temPoint = _getBaseCenterLengthAnglePoint(centerR + 10, angle);
    var tempOffset = Offset(0, 0);
    var sinAngle = sin(angle), cosAngle = cos(angle);
    //double的精度处理问题，这里给一定的伸缩范围
    if ((sinAngle * 100000000).floor() == 0) {
      if (cosAngle > 0) {
        //顶角
        tempOffset =
            Offset(temPoint.x - tp.size.width / 2, temPoint.y - tp.size.height);
      } else {
        //底角
        tempOffset = Offset(temPoint.x - tp.size.width / 2, temPoint.y);
      }
    } else if (sinAngle > 0) {
      //右侧
      tempOffset = Offset(temPoint.x, temPoint.y - tp.size.height / 2);
    } else {
      //左侧
      tempOffset =
          Offset(temPoint.x - tp.size.width, temPoint.y - tp.size.height / 2);
    }
    tp.paint(canvas, tempOffset);
  }

//绘制内部阴影区域
  void _createPaintShadowPath(Canvas canvas, Size size) {
    var begainDy = divisionConst;
    for (var i = 0; i < dimensionalityTags.length; i++) {
      var tempBean = dimensionalityTags[i];

      var basePoints = <Point>[];
      for (var j = 0; j < dimensionalityDivisions.length; j++) {
        var length = 0.0;
        if (j < tempBean.tagContents.length) {
          length = centerR * tempBean.tagContents[j];
        }
        basePoints
            .add(_getBaseCenterLengthAnglePoint(length, _averageAngle * j));
      }
      var shadowPath = Path()..moveTo(basePoints.first.x, basePoints.first.y);
      for (var k = 1; k < basePoints.length; k++) {
        var tempPoint = basePoints[k];
        shadowPath..lineTo(tempPoint.x, tempPoint.y);
      }
      shadowPath
        ..lineTo(basePoints.first.x, basePoints.first.y)
        ..close();
      var shadowPaint = Paint()
        ..strokeWidth = 1
        ..color = tempBean.tagColor
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
      canvas.drawPath(shadowPath, shadowPaint);

      var tp = TextPainter(
          textAlign: TextAlign.center,
          ellipsis: '.',
          maxLines: 1,
          text: TextSpan(
            text: tempBean.tagTitle,
            style: tempBean.tagTitleStyle,
          ),
          textDirection: TextDirection.ltr)
        ..layout(minWidth: 0, maxWidth: size.width);
      tp.paint(canvas,
          Offset(size.width - tp.width - baseBean.basePadding.right, begainDy));
      //绘制标记小椭圆
      var rightBegainCenterX =
          size.width - tp.width - baseBean.basePadding.right - 5;
      var tipPath = Path()
        ..moveTo(rightBegainCenterX,
            begainDy + tp.height / 2 - tempBean.tagTipHeight / 2)
        ..addArc(
            Rect.fromCircle(
                center: Offset(rightBegainCenterX, begainDy + tp.height / 2),
                radius: tempBean.tagTipHeight / 2),
            -pi / 2,
            pi)
        ..lineTo(rightBegainCenterX - tempBean.tagTipWidth,
            begainDy + tp.height / 2 + tempBean.tagTipHeight / 2)
        ..addArc(
            Rect.fromCircle(
                center: Offset(rightBegainCenterX - tempBean.tagTipWidth,
                    begainDy + tp.height / 2),
                radius: tempBean.tagTipHeight / 2),
            pi / 2,
            pi)
        ..lineTo(rightBegainCenterX,
            begainDy + tp.height / 2 - tempBean.tagTipHeight / 2)
        ..close();
      canvas.drawPath(tipPath, shadowPaint);

      begainDy += (tp.height + 7);
    }
  }
}
