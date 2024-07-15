/*
 * @Author: your name
 * @Date: 2020-11-06 15:00:21
 * @LastEditTime: 2023-03-28 15:19:46
 * @LastEditors: Cao Shixin
 * @Description: In User Settings Edit
 * @FilePath: /flutter_chart/lib/chart/painter/chart_line_focus_painter_tool.dart
 */
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_content.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_focus.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_focus_content.dart';
import 'package:flutter_chart_csx/chart/enum/chart_pie_enum.dart';
import 'package:flutter_chart_csx/chart/enum/painter_const.dart';
import 'package:path_drawing/path_drawing.dart';

class LineFocusPainterTool {
  static List<BeanDealModel> dealValue(List<ChartBeanFocus>? chartBeans,
      bool isLinkBreak, double yMax, double yMin,
      {bool showLineSection = false, bool isPositiveSequence = true}) {
    var tempValueArr = <BeanDealModel>[];
    if (chartBeans != null && chartBeans.isNotEmpty) {
      var indexValue = chartBeans.first.second;
      var index = 0;
      var endSecond = chartBeans.last.second;
      for (var i = 0; i <= endSecond; i++) {
        if (i == indexValue) {
          var tempModel = chartBeans[index];
          var resultNumArr = LineFocusPainterTool.dealNumValue(
              tempModel, yMax, yMin,
              showLineSection: showLineSection);
          tempValueArr.add(BeanDealModel(
            value: resultNumArr.first,
            valueMax: resultNumArr[1],
            valueMin: resultNumArr.last,
            cellPointSet: tempModel.cellPointSet,
            tag: tempModel.tag,
            touchBackValue: tempModel.touchBackValue,
          ));
          indexValue = i == endSecond
              ? chartBeans.last.second
              : chartBeans[index + 1].second;
          index++;
        } else {
          if (!isLinkBreak) {
            if (index == 0) {
              tempValueArr
                  .add(BeanDealModel(value: null, valueMax: 0, valueMin: 0));
            } else {
              var resultNumArr = LineFocusPainterTool.dealNumValue(
                  chartBeans[index], yMax, yMin,
                  showLineSection: showLineSection);
              tempValueArr.add(BeanDealModel(
                value: resultNumArr.first,
                valueMax: resultNumArr[1],
                valueMin: resultNumArr.last,
              ));
            }
          } else {
            tempValueArr
                .add(BeanDealModel(value: null, valueMax: 0, valueMin: 0));
          }
        }
      }
    }
    return tempValueArr;
  }

  static List<double> dealNumValue(
      ChartBeanFocus tempModel, double maxNum, double minNum,
      {bool showLineSection = false}) {
    var value = (tempModel.focus.clamp(minNum, maxNum).toDouble()) - minNum;
    var valuemax = value;
    var valuemin = value;
    if (showLineSection) {
      if (tempModel.focusMax != null && tempModel.focusMin != null) {
        valuemax =
            (tempModel.focusMax!.clamp(minNum, maxNum).toDouble()) - minNum;
        valuemin =
            (tempModel.focusMin!.clamp(minNum, maxNum).toDouble()) - minNum;
      }
    }
    return [value, valuemax, valuemin];
  }
}

class PainterTool {
  //绘制一条线
  static void drawline(Canvas canvas, Offset startPoint, Offset endPoint,
      bool isDotteline, Color lineColor, double d,
      {double lineWidth = 1.0}) {
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round
      ..color = lineColor
      ..style = PaintingStyle.stroke;
    var path = Path()
      ..moveTo(startPoint.dx, startPoint.dy)
      ..lineTo(endPoint.dx, endPoint.dy);
    if (isDotteline) {
      canvas.drawPath(
        dashPath(
          path,
          dashArray: CircularIntervalList<double>(<double>[5.0, 4.0]),
        ),
        paint,
      );
    } else {
      canvas.drawPath(path, paint);
    }
  }

  //绘制坐标轴以及坐标轴上面的刻度和辅助线，一般放在绘制线条之前做这一步操作，让这一层在最下面
  static void drawCoordinateAxis(
    Canvas canvas,
    CoordinateAxisModel coordinateAxisModel,
  ) {
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    var _startY = coordinateAxisModel.baseBean.basePadding.top +
        coordinateAxisModel.fixedHeight;
    var _endX = coordinateAxisModel.baseBean.basePadding.left +
        coordinateAxisModel.fixedWidth;
    //基准线距离xy区域底部的高度
    var baseLineYHeight = coordinateAxisModel.baseBean.xBaseLineY == null
        ? 0.0
        : ((coordinateAxisModel.baseBean.xBaseLineY!.clamp(
                    coordinateAxisModel.baseBean.yMin,
                    coordinateAxisModel.baseBean.yMax) -
                coordinateAxisModel.baseBean.yMin) /
            (coordinateAxisModel.baseBean.yMax -
                coordinateAxisModel.baseBean.yMin) *
            coordinateAxisModel.fixedHeight);
    var xLineY = _startY - baseLineYHeight;
    canvas.drawLine(
        Offset(coordinateAxisModel.baseBean.basePadding.left, xLineY),
        Offset(_endX + overPadding, xLineY),
        paint
          ..color = coordinateAxisModel.baseBean.xColor
          ..strokeWidth = coordinateAxisModel.baseBean.xyLineWidth); //x轴
    canvas.drawLine(
        Offset(coordinateAxisModel.baseBean.basePadding.left, _startY),
        Offset(coordinateAxisModel.baseBean.basePadding.left,
            coordinateAxisModel.baseBean.basePadding.top - overPadding),
        paint
          ..color = coordinateAxisModel.baseBean.yColor
          ..strokeWidth = coordinateAxisModel.baseBean.xyLineWidth); //y轴
    if (coordinateAxisModel.baseBean.units != null) {
      //绘制xy轴单位内容
      for (var model in coordinateAxisModel.baseBean.units!) {
        var tp = TextPainter(
            textAlign: TextAlign.center,
            ellipsis: '.',
            text: TextSpan(text: model.text, style: model.textStyle),
            textDirection: TextDirection.ltr)
          ..layout();
        var offset = Offset.zero;
        switch (model.baseOrientation) {
          case UnitOrientation.topLeft:
            offset = Offset(
                coordinateAxisModel.baseBean.basePadding.left -
                    model.spaceDif.dx -
                    tp.width,
                coordinateAxisModel.baseBean.basePadding.top -
                    overPadding -
                    model.spaceDif.dy -
                    tp.height);
            break;
          case UnitOrientation.topRight:
            offset = Offset(
                _endX + overPadding + model.spaceDif.dx,
                coordinateAxisModel.baseBean.basePadding.top -
                    overPadding -
                    model.spaceDif.dy -
                    tp.height);
            break;
          case UnitOrientation.bottomLeft:
            offset = Offset(
                coordinateAxisModel.baseBean.basePadding.left -
                    model.spaceDif.dx -
                    tp.width,
                _startY + model.spaceDif.dy);
            break;
          case UnitOrientation.bottomRight:
            offset = Offset(_endX + overPadding + model.spaceDif.dx,
                _startY + model.spaceDif.dy);
            break;
        }
        tp.paint(canvas, offset);
      }
    }
    var showX = true;
    var showY = true;
    switch (coordinateAxisModel.xyCoordinate) {
      case XYCoordinate.All:
        showX = true;
        showY = true;
        break;
      case XYCoordinate.OnlyX:
        showX = true;
        showY = false;
        break;
      case XYCoordinate.OnlyY:
        showX = false;
        showY = true;
        break;
      default:
    }
    if (showX) {
      if (coordinateAxisModel.baseBean.isShowBorderRight) {
        //最右侧垂直边界线
        canvas.drawLine(
            Offset(_endX, _startY),
            Offset(_endX, coordinateAxisModel.baseBean.basePadding.top),
            paint
              ..color = coordinateAxisModel.baseBean.yColor
              ..strokeWidth = coordinateAxisModel.baseBean.xyLineWidth);
      }
      for (var i = 0; i < coordinateAxisModel.xDialValues.length; i++) {
        var tempXDigalModel = coordinateAxisModel.xDialValues[i];
        var dw = 0.0;
        if (tempXDigalModel.positionRetioy != null) {
          dw = (coordinateAxisModel.fixedWidth -
                  2 * coordinateAxisModel.bothEndPitchX) *
              tempXDigalModel.positionRetioy!; //两个点之间的x方向距离
        }
        if (coordinateAxisModel.baseBean.isShowX) {
          //绘制x轴文本
          var tpx = TextPainter(
              textAlign: TextAlign.center,
              ellipsis: '.',
              text: TextSpan(
                  text: tempXDigalModel.title,
                  style: tempXDigalModel.titleStyle),
              textDirection: TextDirection.ltr)
            ..layout();
          //绘制文案在底部bottom内部居中显示
          var transitHeight = max(
              (coordinateAxisModel.baseBean.basePadding.bottom - tpx.height) /
                  2.0,
              0.0);
          tpx.paint(
              canvas,
              Offset(
                  coordinateAxisModel.baseBean.basePadding.left +
                      dw +
                      coordinateAxisModel.bothEndPitchX -
                      tpx.width / 2,
                  _startY + transitHeight));
        }
        if (coordinateAxisModel.baseBean.isShowHintY && i != 0) {
          var xStart = coordinateAxisModel.baseBean.basePadding.left +
              dw +
              coordinateAxisModel.bothEndPitchX;
          //y轴辅助线
          var hitYPath = Path();
          hitYPath
            ..moveTo(xStart, _startY)
            ..lineTo(xStart,
                coordinateAxisModel.baseBean.basePadding.top - overPadding);
          if (coordinateAxisModel.baseBean.isHintLineImaginary) {
            canvas.drawPath(
              dashPath(
                hitYPath,
                dashArray: CircularIntervalList<double>(<double>[5.0, 4.0]),
              ),
              paint
                ..color = coordinateAxisModel.baseBean.hintLineColor
                ..strokeWidth = coordinateAxisModel.baseBean.hintLineWidth,
            );
          } else {
            canvas.drawPath(
                hitYPath,
                paint
                  ..color = coordinateAxisModel.baseBean.hintLineColor
                  ..strokeWidth = coordinateAxisModel.baseBean.hintLineWidth);
          }
        }
        if (coordinateAxisModel.baseBean.isShowXScale) {
          //x轴刻度
          canvas.drawLine(
              Offset(
                  coordinateAxisModel.baseBean.basePadding.left +
                      dw +
                      coordinateAxisModel.bothEndPitchX,
                  xLineY +
                      (xLineY == _startY
                          ? 0
                          : coordinateAxisModel.baseBean.rulerWidth)),
              Offset(
                  coordinateAxisModel.baseBean.basePadding.left +
                      dw +
                      coordinateAxisModel.bothEndPitchX,
                  _startY - coordinateAxisModel.baseBean.rulerWidth),
              paint
                ..color = coordinateAxisModel.baseBean.xColor
                ..strokeWidth = coordinateAxisModel.baseBean.xyLineWidth);
        }
      }
    }

    if (showY) {
      if (coordinateAxisModel.baseBean.isShowBorderTop) {
        //最顶部水平边界线
        canvas.drawLine(
            Offset(coordinateAxisModel.baseBean.basePadding.left,
                coordinateAxisModel.baseBean.basePadding.top),
            Offset(_endX, coordinateAxisModel.baseBean.basePadding.top),
            paint
              ..color = coordinateAxisModel.baseBean.xColor
              ..strokeWidth = coordinateAxisModel.baseBean.xyLineWidth);
      }
      if (coordinateAxisModel.baseBean.yDialValues.isNotEmpty) {
        for (var i = 0;
            i < coordinateAxisModel.baseBean.yDialValues.length;
            i++) {
          var tempYModel = coordinateAxisModel.baseBean.yDialValues[i];
          var yLength =
              tempYModel.positionRetioy * coordinateAxisModel.fixedHeight;
          var nextLength =
              ((i == coordinateAxisModel.baseBean.yDialValues.length - 1)
                      ? 0.0
                      : coordinateAxisModel
                          .baseBean.yDialValues[i + 1].positionRetioy) *
                  coordinateAxisModel.fixedHeight;
          var subLength = (yLength + nextLength) / 2;
          if (tempYModel.leftSub != null) {
            _drawYText(
                tempYModel.leftSub!,
                true,
                coordinateAxisModel.baseBean.basePadding.left - 10,
                _startY,
                _endX,
                yLength,
                subLength,
                canvas);
          }
          if (tempYModel.rightSub != null) {
            _drawYText(
                tempYModel.rightSub!,
                false,
                coordinateAxisModel.baseBean.basePadding.left - 10,
                _startY,
                _endX,
                yLength,
                subLength,
                canvas);
          }
          if (coordinateAxisModel.baseBean.isShowHintX &&
              yLength != baseLineYHeight) {
            //x轴辅助线
            var hitXPath = Path();
            hitXPath
              ..moveTo(coordinateAxisModel.baseBean.basePadding.left,
                  _startY - yLength)
              ..lineTo(_endX + overPadding, _startY - yLength);
            if (coordinateAxisModel.baseBean.isHintLineImaginary) {
              canvas.drawPath(
                  dashPath(
                    hitXPath,
                    dashArray: CircularIntervalList<double>(<double>[5.0, 4.0]),
                  ),
                  paint
                    ..color = tempYModel.hintLineColor ??
                        coordinateAxisModel.baseBean.hintLineColor
                    ..strokeWidth = coordinateAxisModel.baseBean.hintLineWidth);
            } else {
              canvas.drawPath(
                  hitXPath,
                  paint
                    ..color = tempYModel.hintLineColor ??
                        coordinateAxisModel.baseBean.hintLineColor
                    ..strokeWidth = coordinateAxisModel.baseBean.hintLineWidth);
            }
          }
          if (coordinateAxisModel.baseBean.isShowYScale) {
            //y轴刻度
            canvas.drawLine(
                Offset(coordinateAxisModel.baseBean.basePadding.left,
                    _startY - yLength),
                Offset(
                    coordinateAxisModel.baseBean.basePadding.left +
                        coordinateAxisModel.baseBean.rulerWidth,
                    _startY - yLength),
                paint
                  ..color = coordinateAxisModel.baseBean.yColor
                  ..strokeWidth = coordinateAxisModel.baseBean.xyLineWidth);
          }
        }
      }
    }
  }

  static void _drawYText(
    DialStyleYSub model,
    bool isLeft,
    double leftStart,
    double startY,
    double endX,
    double yLength,
    double subLength,
    Canvas canvas,
  ) {
    //绘制y轴文本
    var tpY = TextPainter(
        textAlign: TextAlign.right,
        ellipsis: '.',
        maxLines: 1,
        text: TextSpan(text: '${model.title}', style: model.titleStyle),
        textDirection: TextDirection.ltr)
      ..layout();
    tpY.paint(
        canvas,
        Offset(isLeft ? (leftStart - tpY.width) : endX + 8,
            startY - yLength - tpY.height / 2));
    var tpSub = TextPainter(
        textAlign: TextAlign.center,
        ellipsis: '.',
        maxLines: 5,
        text: TextSpan(
            text: model.centerSubTitle, style: model.centerSubTextStyle),
        textDirection: TextDirection.ltr)
      ..layout();
    tpSub.paint(
        canvas,
        Offset(isLeft ? (leftStart - tpSub.width) : (endX + 8),
            startY - subLength - tpSub.height / 2));
  }

  //绘制隔离带，x轴
  static void drawXIntervalSegmentation(
      Canvas canvas,
      List<SectionBean> xSectionBeans,
      double startX,
      double endX,
      double startY,
      double endY) {
    var _fixedWidth = endX - startX;
    for (var item in xSectionBeans) {
      var tempStartX = _fixedWidth * item.startRatio + startX;
      var tempWidth = _fixedWidth * item.widthRatio;
      var tempPath = Path()
        ..moveTo(tempStartX, endY)
        ..lineTo(tempStartX + tempWidth, endY)
        ..lineTo(tempStartX + tempWidth, startY)
        ..lineTo(tempStartX, startY)
        ..lineTo(tempStartX, endY)
        ..close();
      var tempPaint = Paint()
        ..isAntiAlias = true
        ..strokeWidth = item.borderWidth ?? 1
        ..color = item.fillColor ?? Colors.transparent
        ..style = PaintingStyle.fill;
      canvas.drawPath(tempPath, tempPaint);
      //边缘线
      var borderLinePaint = Paint()
        ..isAntiAlias = true
        ..strokeWidth = item.borderWidth ?? 1
        ..color = item.borderColor ?? Colors.transparent
        ..style = PaintingStyle.stroke;
      var borderLinePath1 = Path()
        ..moveTo(tempStartX, endY)
        ..lineTo(tempStartX, startY);
      var borderLinePath2 = Path()
        ..moveTo(tempStartX + tempWidth, endY)
        ..lineTo(tempStartX + tempWidth, startY);
      if (item.isBorderSolid) {
        canvas.drawPath(borderLinePath1, borderLinePaint);
        canvas.drawPath(borderLinePath2, borderLinePaint);
      } else {
        canvas.drawPath(
          dashPath(
            borderLinePath1,
            dashArray: CircularIntervalList<double>(<double>[5.0, 4.0]),
          ),
          borderLinePaint,
        );
        canvas.drawPath(
          dashPath(
            borderLinePath2,
            dashArray: CircularIntervalList<double>(<double>[5.0, 4.0]),
          ),
          borderLinePaint,
        );
      }
      if (item.textTitle != null) {
        //文字显示
        var tempText = TextPainter(
            textAlign: TextAlign.center,
            ellipsis: '.',
            maxLines: 1,
            text: TextSpan(
                text: item.textTitle!.title, style: item.textTitle!.titleStyle),
            textDirection: TextDirection.ltr)
          ..layout();
        //定义在图表上层显示
        tempText.paint(
            canvas,
            Offset(tempStartX + tempWidth / 2 - tempText.width / 2,
                endY - tempText.height - item.titleBottomSpace));
      }

      if (item.imgTitle != null) {
        //图片显示
        canvas.drawImageRect(
          item.imgTitle!.img,
          Rect.fromLTWH(0, 0, item.imgTitle!.img.width.toDouble(),
              item.imgTitle!.img.height.toDouble()),
          Rect.fromLTWH(
              tempStartX + tempWidth / 2 - item.imgTitle!.imgSize.width / 2,
              endY - item.imgTitle!.imgSize.height - item.titleBottomSpace,
              item.imgTitle!.imgSize.width,
              item.imgTitle!.imgSize.height),
          Paint(),
        );
      }
    }
  }

  //绘制隔离带，y轴
  static void drawYIntervalSegmentation(
      Canvas canvas,
      List<SectionBeanY> ySectionBeans,
      double startX,
      double endX,
      double startY,
      double endY) {
    var _fixedHeight = startY - endY;
    for (var item in ySectionBeans) {
      var tempStartY = endY + (_fixedHeight - _fixedHeight * item.startRatio);
      var tempHeight = _fixedHeight * item.widthRatio;
      var tempPath = Path()
        ..moveTo(startX, tempStartY)
        ..lineTo(endX, tempStartY)
        ..lineTo(endX, tempStartY - tempHeight)
        ..lineTo(startX, tempStartY - tempHeight)
        ..lineTo(startX, tempStartY)
        ..close();
      var tempPaint = Paint()
        ..isAntiAlias = true
        ..strokeWidth = 0
        ..color = item.fillColor!
        ..style = PaintingStyle.fill;
      canvas.drawPath(tempPath, tempPaint);
      //边缘线
      var borderLinePaint = Paint()
        ..isAntiAlias = true
        ..strokeWidth = item.borderWidth ?? 1
        ..color = item.borderColor ?? Colors.transparent
        ..style = PaintingStyle.stroke;
      var borderLinePath1 = Path()
        ..moveTo(startX, tempStartY)
        ..lineTo(endX, tempStartY);
      var borderLinePath2 = Path()
        ..moveTo(startX, tempStartY - tempHeight)
        ..lineTo(endX, tempStartY - tempHeight);
      if (item.isBorderSolid) {
        canvas.drawPath(borderLinePath1, borderLinePaint);
        canvas.drawPath(borderLinePath2, borderLinePaint);
      } else {
        canvas.drawPath(
          dashPath(
            borderLinePath1,
            dashArray: CircularIntervalList<double>(<double>[5.0, 4.0]),
          ),
          borderLinePaint,
        );
        canvas.drawPath(
          dashPath(
            borderLinePath2,
            dashArray: CircularIntervalList<double>(<double>[5.0, 4.0]),
          ),
          borderLinePaint,
        );
      }
    }
  }

  ///绘制某点处的辅助线，并特殊点高亮处理
  static void drawSpecialPointHintLine(Canvas canvas, PointModel pointModel,
      double startX, double endX, double startY, double endY) {
    if (pointModel.cellPointSet.hintEdgeInset != HintEdgeInset.none) {
      var hintEdgeInset = pointModel.cellPointSet.hintEdgeInset;
      if (hintEdgeInset.left != null) {
        drawline(
            canvas,
            pointModel.offset,
            Offset(startX, pointModel.offset.dy),
            hintEdgeInset.left!.isHintLineImaginary,
            hintEdgeInset.left!.hintColor,
            hintEdgeInset.left!.hintLineWidth);
      }
      if (hintEdgeInset.right != null) {
        drawline(
            canvas,
            pointModel.offset,
            Offset(endX, pointModel.offset.dy),
            hintEdgeInset.right!.isHintLineImaginary,
            hintEdgeInset.right!.hintColor,
            hintEdgeInset.right!.hintLineWidth);
      }
      if (hintEdgeInset.top != null) {
        drawline(
            canvas,
            pointModel.offset,
            Offset(pointModel.offset.dx, endY),
            hintEdgeInset.top!.isHintLineImaginary,
            hintEdgeInset.top!.hintColor,
            hintEdgeInset.top!.hintLineWidth);
      }
      if (hintEdgeInset.bottom != null) {
        drawline(
            canvas,
            pointModel.offset,
            Offset(pointModel.offset.dx, startY),
            hintEdgeInset.bottom!.isHintLineImaginary,
            hintEdgeInset.bottom!.hintColor,
            hintEdgeInset.bottom!.hintLineWidth);
      }
    }
    var centerPointOffset = pointModel.cellPointSet.centerPointOffset;
    if (centerPointOffset != Offset.zero) {
      drawline(
          canvas,
          pointModel.offset,
          Offset(pointModel.offset.dx + centerPointOffset.dx,
              pointModel.offset.dy + centerPointOffset.dy),
          true,
          pointModel.cellPointSet.centerPointOffsetLineColor,
          2);
    }
    drawSpecialPoint(canvas, pointModel, centerPointOffset);
  }

  static void drawSpecialPoint(
      Canvas canvas, PointModel pointModel, Offset centerPointOffset) {
    if (pointModel.cellPointSet.pointType == PointType.PlacehoderImage) {
      if (pointModel.cellPointSet.placehoderImage == null) {
        return;
      }

      var placeImageSize = pointModel.cellPointSet.placeImageSize;
      canvas.drawImageRect(
        pointModel.cellPointSet.placehoderImage!,
        Rect.fromLTWH(
            0,
            0,
            pointModel.cellPointSet.placehoderImage!.width.toDouble(),
            pointModel.cellPointSet.placehoderImage!.height.toDouble()),
        Rect.fromLTWH(
            pointModel.offset.dx -
                placeImageSize.width / 2 +
                centerPointOffset.dx,
            pointModel.offset.dy -
                placeImageSize.height / 2 +
                centerPointOffset.dy,
            placeImageSize.width,
            placeImageSize.height),
        Paint(),
      );
    } else {
      var centerOffset = Offset(pointModel.offset.dx + centerPointOffset.dx,
          pointModel.offset.dy + centerPointOffset.dy);
      var rect = Rect.fromLTRB(
        centerOffset.dx - pointModel.cellPointSet.pointSize.width / 2,
        centerOffset.dy - pointModel.cellPointSet.pointSize.height / 2,
        centerOffset.dx + pointModel.cellPointSet.pointSize.width / 2,
        centerOffset.dy + pointModel.cellPointSet.pointSize.height / 2,
      );
      var paint = Paint()
        ..isAntiAlias = true
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.fill
        ..shader = LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.mirror,
                colors: pointModel.cellPointSet.pointShaderColors ??
                    [defaultColor, defaultColor.withOpacity(0.3)])
            .createShader(rect);
      canvas
        ..drawDRRect(
            RRect.fromRectAndCorners(rect,
                topLeft: pointModel.cellPointSet.pointRadius,
                topRight: pointModel.cellPointSet.pointRadius,
                bottomLeft: pointModel.cellPointSet.pointRadius,
                bottomRight: pointModel.cellPointSet.pointRadius),
            RRect.zero,
            paint);
    }
  }
}

//绘制xy轴情况
enum XYCoordinate {
  //只绘制x轴
  OnlyX,
  //只绘制y轴
  OnlyY,
  //x轴y轴都绘制
  All,
}

///绘制xy轴的额所需参数设置
class CoordinateAxisModel {
  BaseBean baseBean;
  double fixedWidth;
  //起始和结束距离两端y轴的单侧间距。默认无间距
  double bothEndPitchX;
  double fixedHeight;
  XYCoordinate xyCoordinate;
  //X轴数据
  List<DialStyleX> xDialValues;

  CoordinateAxisModel(this.fixedHeight, this.fixedWidth,
      {required this.baseBean,
      required this.xDialValues,
      this.xyCoordinate = XYCoordinate.All,
      this.bothEndPitchX = 0});
}
