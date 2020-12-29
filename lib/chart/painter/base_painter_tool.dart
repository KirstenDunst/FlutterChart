/*
 * @Author: your name
 * @Date: 2020-11-06 15:00:21
 * @LastEditTime: 2020-12-29 11:38:26
 * @LastEditors: Cao Shixin
 * @Description: In User Settings Edit
 * @FilePath: /flutter_chart/lib/chart/painter/chart_line_focus_painter_tool.dart
 */
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_focus.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_focus_content.dart';
import 'package:flutter_chart_csx/chart/enum/painter_const.dart';
import 'package:path_drawing/path_drawing.dart';

class LineFocusPainterTool {
  /// 数据处理
  /// chartBeans：数据源
  /// isLinkBreak：线条是否是断开的设置
  /// yMax：y轴的最大值
  /// showLineSection：是否展示线条区间带
  static List<BeanDealModel> dealValue(
      List<ChartBeanFocus> chartBeans, bool isLinkBreak, double yMax,
      {bool showLineSection = false}) {
    var tempValueArr = <BeanDealModel>[];
    if (chartBeans != null && chartBeans.isNotEmpty) {
      var indexValue = chartBeans.first.second;
      var index = 0;
      var endSecond = chartBeans.last.second;
      for (var i = 0; i <= endSecond; i++) {
        if (i == indexValue) {
          var tempModel = chartBeans[index];
          var resultNumArr = LineFocusPainterTool.dealNumValue(tempModel, yMax,
              showLineSection: showLineSection);
          tempValueArr.add(BeanDealModel(
            value: resultNumArr.first,
            valueMax: resultNumArr[1],
            valueMin: resultNumArr.last,
            hintEdgeInset: tempModel.hintEdgeInset,
            centerPoint: tempModel.centerPoint,
            centerPointOffset: tempModel.centerPointOffset,
            centerPointOffsetLineColor:
                tempModel.centerPointOffsetLineColor ?? defaultColor,
            placeImageSize: tempModel.centerPointSize,
            touchBackValue: tempModel.touchBackValue,
          ));
          indexValue = i == endSecond
              ? chartBeans.last.second
              : chartBeans[index + 1].second;
          index++;
        } else {
          if (!isLinkBreak) {
            if (index == 0) {
              tempValueArr.add(
                  BeanDealModel(value: null, valueMax: null, valueMin: null));
            } else {
              var resultNumArr = LineFocusPainterTool.dealNumValue(
                  chartBeans[index], yMax,
                  showLineSection: showLineSection);
              tempValueArr.add(BeanDealModel(
                value: resultNumArr.first,
                valueMax: resultNumArr[1],
                valueMin: resultNumArr.last,
              ));
            }
          } else {
            tempValueArr.add(
                BeanDealModel(value: null, valueMax: null, valueMin: null));
          }
        }
      }
    }
    return tempValueArr;
  }

  /// 计算数值
  static List<num> dealNumValue(ChartBeanFocus tempModel, double maxNum,
      {bool showLineSection = false}) {
    var value = min(tempModel.focus, maxNum);
    value = max(value, 0.0);
    var valuemax = value;
    var valuemin = value;
    if (showLineSection) {
      if (tempModel.focusMax != null && tempModel.focusMin != null) {
        valuemax = min(tempModel.focusMax, maxNum);
        valuemin = min(tempModel.focusMin, maxNum);
        valuemax = max(valuemax, 0.0);
        valuemin = max(valuemin, 0.0);
      }
    } else {
      valuemax = null;
      valuemin = null;
    }
    return [value, valuemax, valuemin];
  }
}

class PainterTool {
  /// 绘制一条线
  /// canvas：
  /// startPoint：开始的点
  /// endPoint：结束点
  /// isDotteline：连线是否是虚线
  /// lineColor：线条颜色
  /// lineWidth：线条宽度
  static void drawline(Canvas canvas, Offset startPoint, endPoint,
      bool isDotteline, Color lineColor, double lineWidth) {
    lineWidth ??= 1.0;
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

  /// 绘制坐标轴以及坐标轴上面的刻度和辅助线，一般放在绘制线条之前做这一步操作，让这一层在最下面
  /// canvas：
  /// coordinateAxisModel：坐标轴上面的刻度和辅助线参数
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
    canvas.drawLine(
        Offset(coordinateAxisModel.baseBean.basePadding.left, _startY),
        Offset(_endX + overPadding, _startY),
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

    var showX = true;
    var showY = true;
    if (coordinateAxisModel.onlyYCoordinate != null) {
      if (coordinateAxisModel.onlyYCoordinate) {
        showX = false;
        showY = true;
      } else {
        showX = true;
        showY = false;
      }
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
      if (coordinateAxisModel.xDialValues != null &&
          coordinateAxisModel.xDialValues.isNotEmpty) {
        for (var i = 0; i < coordinateAxisModel.xDialValues.length; i++) {
          var tempXDigalModel = coordinateAxisModel.xDialValues[i];
          var dw = 0.0;
          if (tempXDigalModel.positionRetioy != null) {
            dw = coordinateAxisModel.fixedWidth *
                tempXDigalModel.positionRetioy; //两个点之间的x方向距离
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
                        dw -
                        tpx.width / 2,
                    _startY + transitHeight));
          }
          if (coordinateAxisModel.baseBean.isShowHintY && i != 0) {
            //y轴辅助线
            var hitYPath = Path();
            hitYPath
              ..moveTo(
                  coordinateAxisModel.baseBean.basePadding.left + dw, _startY)
              ..lineTo(coordinateAxisModel.baseBean.basePadding.left + dw,
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
                Offset(coordinateAxisModel.baseBean.basePadding.left + dw,
                    _startY),
                Offset(coordinateAxisModel.baseBean.basePadding.left + dw,
                    _startY - coordinateAxisModel.baseBean.rulerWidth),
                paint
                  ..color = coordinateAxisModel.baseBean.xColor
                  ..strokeWidth = coordinateAxisModel.baseBean.xyLineWidth);
          }
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
      if (coordinateAxisModel.baseBean.yDialValues != null &&
          coordinateAxisModel.baseBean.yDialValues.isNotEmpty) {
        for (var i = 0;
            i < coordinateAxisModel.baseBean.yDialValues.length;
            i++) {
          var tempYModel = coordinateAxisModel.baseBean.yDialValues[i];

          //绘制y轴文本
          var yValue = tempYModel.title;
          var yLength =
              tempYModel.positionRetioy * coordinateAxisModel.fixedHeight;
          var tpY = TextPainter(
              textAlign: TextAlign.right,
              ellipsis: '.',
              maxLines: 1,
              text: TextSpan(text: '$yValue', style: tempYModel.titleStyle),
              textDirection: TextDirection.rtl)
            ..layout();
          tpY.paint(
              canvas,
              Offset(
                  coordinateAxisModel.baseBean.basePadding.left -
                      10 -
                      tpY.width,
                  _startY - yLength - tpY.height / 2));
          var nextLength = ((i ==
                      coordinateAxisModel.baseBean.yDialValues.length - 1)
                  ? coordinateAxisModel.baseBean.yDialValues.last.positionRetioy
                  : coordinateAxisModel
                      .baseBean.yDialValues[i + 1].positionRetioy) *
              coordinateAxisModel.fixedHeight;
          var subLength = (yLength + nextLength) / 2;
          var tpSub = TextPainter(
              textAlign: TextAlign.center,
              ellipsis: '.',
              maxLines: 5,
              text: TextSpan(
                  text: tempYModel.centerSubTitle,
                  style: tempYModel.centerSubTextStyle),
              textDirection: TextDirection.ltr)
            ..layout();
          tpSub.paint(
              canvas,
              Offset(
                  coordinateAxisModel.baseBean.isLeftYDialSub
                      ? (coordinateAxisModel.baseBean.basePadding.left -
                          tpSub.width -
                          10)
                      : (_endX + 8),
                  _startY - subLength - tpSub.height / 2));

          if (coordinateAxisModel.baseBean.isShowHintX && yLength != 0) {
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
                    ..color = coordinateAxisModel.baseBean.hintLineColor
                    ..strokeWidth = coordinateAxisModel.baseBean.hintLineWidth);
            } else {
              canvas.drawPath(
                  hitXPath,
                  paint
                    ..color = coordinateAxisModel.baseBean.hintLineColor
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

  /// 绘制隔离带，x轴
  /// canvas：
  /// xSectionBeans：x区间带参数
  /// startX：x轴的开始位置
  /// endX：x轴的结束位置
  /// startY：y轴的开始位置
  /// endY：y轴的结束位置
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
        ..color = item.fillColor
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
//文字显示
      var tempText = TextPainter(
          textAlign: TextAlign.center,
          ellipsis: '.',
          maxLines: 1,
          text: TextSpan(text: item.title, style: item.titleStyle),
          textDirection: TextDirection.ltr)
        ..layout();
      //定义在图表上层显示
      tempText.paint(
          canvas,
          Offset(tempStartX + tempWidth / 2 - tempText.width / 2,
              endY - tempText.height));
    }
  }

  /// 绘制某点处的辅助线，并特殊点高亮处理
  /// canvas：
  /// specialPointModel：特殊点参数模型
  /// startX：x轴的开始位置
  /// endX：x轴的结束位置
  /// startY：y轴的开始位置
  /// endY：y轴的结束位置
  static void drawSpecialPointHintLine(
      Canvas canvas,
      SpecialPointModel specialPointModel,
      double startX,
      double endX,
      double startY,
      double endY) {
    if (specialPointModel == null || specialPointModel.offset == null) {
      return;
    }
    if (specialPointModel.hintEdgeInset != null) {
      var hintEdgeInset = specialPointModel.hintEdgeInset;
      if (hintEdgeInset.left != null) {
        drawline(
            canvas,
            specialPointModel.offset,
            Offset(startX, specialPointModel.offset.dy),
            hintEdgeInset.left.isHintLineImaginary,
            hintEdgeInset.left.hintColor,
            hintEdgeInset.left.hintLineWidth);
      }
      if (hintEdgeInset.right != null) {
        drawline(
            canvas,
            specialPointModel.offset,
            Offset(endX, specialPointModel.offset.dy),
            hintEdgeInset.right.isHintLineImaginary,
            hintEdgeInset.right.hintColor,
            hintEdgeInset.right.hintLineWidth);
      }
      if (hintEdgeInset.top != null) {
        drawline(
            canvas,
            specialPointModel.offset,
            Offset(specialPointModel.offset.dx, endY),
            hintEdgeInset.top.isHintLineImaginary,
            hintEdgeInset.top.hintColor,
            hintEdgeInset.top.hintLineWidth);
      }
      if (hintEdgeInset.bottom != null) {
        drawline(
            canvas,
            specialPointModel.offset,
            Offset(specialPointModel.offset.dx, startY),
            hintEdgeInset.bottom.isHintLineImaginary,
            hintEdgeInset.bottom.hintColor,
            hintEdgeInset.bottom.hintLineWidth);
      }
    }
    if (specialPointModel.centerPoint != null) {
      // var ratio = specialPointModel.placeImageRatio;

      if (specialPointModel.centerPointOffset != null &&
          specialPointModel.centerPointOffset != Offset.zero) {
        drawline(
            canvas,
            specialPointModel.offset,
            Offset(
                specialPointModel.offset.dx +
                    specialPointModel.centerPointOffset.dx,
                specialPointModel.offset.dy +
                    specialPointModel.centerPointOffset.dy),
            true,
            specialPointModel.centerPointOffsetLineColor,
            2);
      }
      canvas.drawImageRect(
        specialPointModel.centerPoint,
        Rect.fromLTWH(0, 0, specialPointModel.centerPoint.width.toDouble(),
            specialPointModel.centerPoint.height.toDouble()),
        Rect.fromLTWH(
            specialPointModel.offset.dx -
                specialPointModel.placeImageSize.width / 2 +
                specialPointModel.centerPointOffset.dx,
            specialPointModel.offset.dy -
                specialPointModel.placeImageSize.height / 2 +
                specialPointModel.centerPointOffset.dy,
            specialPointModel.placeImageSize.width,
            specialPointModel.placeImageSize.height),
        Paint(),
      );
    } else {
      canvas
        ..drawCircle(
            specialPointModel.offset,
            specialPointModel.specialPointWidth,
            Paint()
              ..isAntiAlias = true
              ..strokeWidth = specialPointModel.specialPointWidth
              ..strokeCap = StrokeCap.round
              ..color = specialPointModel.specialPointColor
              ..style = PaintingStyle.fill);
    }
  }
}

/// 绘制xy轴的额所需参数设置
class CoordinateAxisModel {
  final BaseBean baseBean;
  final double fixedWidth;
  final double fixedHeight;
  // true：只绘制Y轴，false：只绘制x轴，null：则xy轴都绘制。
  final bool onlyYCoordinate;
  //X轴数据
  final List<DialStyleX> xDialValues;

  CoordinateAxisModel(this.fixedHeight, this.fixedWidth,
      {this.baseBean, this.xDialValues, this.onlyYCoordinate});
}
