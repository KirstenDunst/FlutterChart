import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/bean/chart_bean.dart';
import 'package:flutter_chart/chart/painter/base_painter.dart';
import 'package:flutter_chart/flutter_chart.dart';
import 'package:path_drawing/path_drawing.dart';

class ChartLinePainter extends BasePainter {
  double xyLineWidth; //xy轴线条的宽度
  Color xColor; //x轴的颜色
  Color yColor; //y轴的颜色
  double rulerWidth; //刻度的宽度或者高度
  double yMax; //y轴最大值，用来计算内部绘制点的y轴位置
  List<DialStyle> yDialValues; //y轴左侧刻度显示，不传则没有
  bool isShowHintX, isShowHintY; //x、y轴的辅助线
  bool hintLineSolid; //辅助线是否为实线，在显示辅助线的时候才有效，false的话为虚线，默认实线
  Color hintLineColor; //辅助线颜色
  List<ChartBeanSystem> chartBeanSystems; //绘制线条的参数内容
  bool isShowBorderTop, isShowBorderRight; //顶部和右侧的辅助线

  static const double basePadding = 16; //默认的边距
  static const Color defaultColor = Colors.deepPurple;
  double _startX, _endX, _startY, _endY, _fixedHeight, _fixedWidth;
  List<LineCanvasModel> _lineCanvasModels;

  ChartLinePainter(
    this.chartBeanSystems, {
    this.xyLineWidth = 2,
    this.xColor,
    this.yColor,
    this.rulerWidth = 8,
    this.yMax,
    this.yDialValues,
    this.isShowHintX = false,
    this.isShowHintY = false,
    this.hintLineSolid = true,
    this.hintLineColor,
    this.isShowBorderTop = false,
    this.isShowBorderRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var xyPaint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = xyLineWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    _init(canvas, size, xyPaint);
    _initPath(canvas, xyPaint);
    _drawLine(canvas); //曲线或折线
  }

  @override
  bool shouldRepaint(ChartLinePainter oldDelegate) {
    return true;
  }

  ///初始化
  void _init(Canvas canvas, Size size, Paint xyPaint) {
    _initValue();
    _initBorder(size);
    _drawXy(canvas, xyPaint); //坐标轴
  }

  void _initValue() {
    if (xColor == null) {
      xColor = defaultColor;
    }
    if (yColor == null) {
      yColor = defaultColor;
    }
    if (hintLineSolid == null) {
      hintLineSolid = true;
    }
    if (xyLineWidth == null) {
      xyLineWidth = 2;
    }
    if (hintLineColor == null) {
      hintLineColor = defaultColor;
    }
    if (yMax == null) {
      yMax = 1;
    }
  }

  ///计算边界
  void _initBorder(Size size) {
    _startX = basePadding * 2.5; //预留出y轴刻度值所占的空间
    _endX = size.width - basePadding * 2;
    _startY = size.height - basePadding * 2;
    _endY = basePadding * 2;
    _fixedHeight = _startY - _endY;
    _fixedWidth = _endX - _startX;
  }

  ///计算Path
  void _initPath(Canvas canvas, Paint xyPaint) {
    _lineCanvasModels = [];
    if (chartBeanSystems != null && chartBeanSystems.isNotEmpty) {
      for (var item in chartBeanSystems) {
        var paths = <Path>[], shadowPaths = <Path>[];
        var placeImagepoints = <Point>[], pointArr = <Point>[];
        if (item.chartBeans != null && item.chartBeans.isNotEmpty) {
          if (item.isDrawX) {
            //绘制x轴的文字部分
            _drawXRuler(canvas, xyPaint..color = xColor, item.chartBeans,
                item.xTitleStyle);
          }
          double preX, preY, currentX, currentY;
          int length = item.chartBeans.length;
          double W =
              _fixedWidth / (length > 1 ? (length - 1) : 1); //两个点之间的x方向距离
          Path _path = new Path();
          Path _shadowPath = new Path();
          Point _shadowStartPoint = Point(_startX, _startY);
          for (int i = 0; i < length; i++) {
            currentX = _startX + W * i;
            currentY = (_startY - (item.chartBeans[i].y / yMax) * _fixedHeight);
            if (i == 0) {
              preX = currentX;
              preY = currentY;
            }

            if (i == 0 ||
                (i > 0 &&
                    item.chartBeans[i - 1].isShowPlaceImage &&
                    item.placehoderImageBreak)) {
              _path.moveTo(currentX, currentY);
              _shadowStartPoint = Point(currentX, _startY);
              _shadowPath
                ..moveTo(currentX, _startY)
                ..lineTo(currentX, currentY);
            }

            if (item.chartBeans[i].isShowPlaceImage) {
              placeImagepoints.add(Point(currentX, currentY));

              if (item.placehoderImageBreak) {
                _shadowPath
                  ..lineTo(
                      (i > 0 && item.chartBeans[i - 1].isShowPlaceImage)
                          ? currentX
                          : preX,
                      _startY)
                  ..lineTo(_shadowStartPoint.x.toDouble(),
                      _shadowStartPoint.y.toDouble())
                  ..close();
                shadowPaths.add(_shadowPath);
                _shadowPath = new Path();
                paths.add(_path);
                _path = new Path();
                continue;
              }
            }

            // preX = _startX + W * (i - 1);
            // preY = (_startY - item.chartBeans[i - 1].y / yMax * _fixedHeight);

            pointArr.add(Point(currentX, currentY));
            if (item.isCurve) {
              _path.cubicTo((preX + currentX) / 2, preY, (preX + currentX) / 2,
                  currentY, currentX, currentY);
              _shadowPath.cubicTo((preX + currentX) / 2, preY,
                  (preX + currentX) / 2, currentY, currentX, currentY);
            } else {
              _path.lineTo(currentX, currentY);
              _shadowPath.lineTo(currentX, currentY);
            }
            if (i == length - 1) {
              _shadowPath
                ..lineTo(currentX, _startY)
                ..lineTo(_shadowStartPoint.x.toDouble(),
                    _shadowStartPoint.y.toDouble())
                ..close();
            }
            preX = currentX;
            preY = currentY;
          }
          paths.add(_path);

          shadowPaths.add(_shadowPath);
        }

        var lineModel = LineCanvasModel(
            paths: paths,
            pathColor: item.lineColor,
            pathWidth: item.lineWidth,
            shadowPaths: shadowPaths,
            shaderColors: item.shaderColors,
            points: pointArr,
            pointColor: item.lineColor,
            pointRadius: item.pointRadius,
            placeImagePoints: placeImagepoints,
            placeImage: item.placehoderImage);
        _lineCanvasModels.add(lineModel);
      }
    }
  }

  ///x,y轴
  void _drawXy(Canvas canvas, Paint paint) {
    canvas.drawLine(Offset(_startX, _startY),
        Offset(_endX + basePadding, _startY), paint..color = xColor); //x轴
    canvas.drawLine(Offset(_startX, _startY),
        Offset(_startX, _endY - basePadding), paint..color = yColor); //y轴
    if (isShowBorderTop) {
      ///最顶部水平边界线
      canvas.drawLine(
          Offset(_startX, _endY - basePadding),
          Offset(_endX + basePadding, _endY - basePadding),
          paint..color = xColor);
    }
    if (isShowBorderRight) {
      ///最右侧垂直边界线
      canvas.drawLine(
          Offset(_endX + basePadding, _startY),
          Offset(_endX + basePadding, _endY - basePadding),
          paint..color = yColor);
    }
    _drawYRuler(canvas, paint);
  }

//绘制y轴 & 辅助线
  void _drawYRuler(Canvas canvas, Paint paint) {
    if (yDialValues == null) {
      return;
    }
    for (int i = 0; i < yDialValues.length; i++) {
      var tempYModel = yDialValues[i];

      ///绘制y轴文本
      var yValue = tempYModel.title;
      var yLength = tempYModel.positionRetioy * _fixedHeight;
      TextPainter texty = TextPainter(
          textAlign: TextAlign.right,
          ellipsis: '.',
          maxLines: 1,
          text: TextSpan(text: '$yValue', style: tempYModel.titleStyle),
          textDirection: TextDirection.rtl)
        ..layout();
      texty.paint(
          canvas,
          Offset(
              _startX - texty.width - 8, _startY - yLength - texty.height / 2));
      var subLength = (yDialValues[i].titleValue -
              (i == yDialValues.length - 1
                  ? 0
                  : yDialValues[i + 1].titleValue)) /
          2 /
          yMax *
          _fixedHeight;
      TextPainter tp = TextPainter(
          textAlign: TextAlign.center,
          ellipsis: '.',
          maxLines: 1,
          text: TextSpan(
              text: tempYModel.centerSubTitle,
              style: tempYModel.centerSubTextStyle),
          textDirection: TextDirection.ltr)
        ..layout();
      tp.paint(
          canvas,
          Offset(tempYModel.isLeft ? (_startX - tp.width - 8) : (_endX + 5),
              _startY - yLength + subLength.abs() - tp.height / 2));

      if (isShowHintX && yLength != 0) {
        //x轴辅助线
        Path hitXPath = Path();
        hitXPath
          ..moveTo(_startX, _startY - yLength)
          ..lineTo(_endX + basePadding, _startY - yLength);
        if (hintLineSolid) {
          canvas.drawPath(hitXPath, paint..color = hintLineColor);
        } else {
          canvas.drawPath(
            dashPath(
              hitXPath,
              dashArray: CircularIntervalList<double>(<double>[5.0, 4.0]),
            ),
            paint..color = hintLineColor,
          );
        }
      }

      ///y轴刻度
      canvas.drawLine(
          Offset(_startX, _startY - yLength),
          Offset(_startX + rulerWidth, _startY - yLength),
          paint..color = yColor);
    }
  }

  ///x轴刻度 & 辅助线
  void _drawXRuler(Canvas canvas, Paint paint, List<ChartBean> chartBeans,
      TextStyle textStyle) {
    if (chartBeans != null && chartBeans.length > 0) {
      int length = chartBeans.length;
      double dw = _fixedWidth / (length > 1 ? (length - 1) : 1); //两个点之间的x方向距离
      for (int i = 0; i < length; i++) {
        ///绘制x轴文本
        TextPainter tpX = TextPainter(
            textAlign: TextAlign.center,
            ellipsis: '.',
            text: TextSpan(text: chartBeans[i].x, style: textStyle),
            textDirection: TextDirection.ltr)
          ..layout();
        tpX.paint(canvas,
            Offset(_startX + dw * i - tpX.width / 2, _startY + basePadding));

        if (isShowHintY) {
          //y轴辅助线
          Path tempPath = Path()
            ..moveTo(_startX + dw * i, _startY)
            ..lineTo(_startX + dw * i, _endY - basePadding);
          if (hintLineSolid) {
            canvas.drawPath(tempPath, paint..color = hintLineColor);
          } else {
            canvas.drawPath(
              dashPath(
                tempPath,
                dashArray: CircularIntervalList<double>(<double>[5.0, 4.0]),
              ),
              paint..color = hintLineColor,
            );
          }
        }

        ///x轴刻度
        canvas.drawLine(
            Offset(_startX + dw * i, _startY),
            Offset(_startX + dw * i, _startY - rulerWidth),
            paint..color = xColor);
      }
    }
  }

  ///曲线或折线
  void _drawLine(Canvas canvas) {
    _lineCanvasModels.forEach((element) {
      //阴影区域
      if (element.shadowPaths != null && element.shaderColors != null) {
        element.shadowPaths.forEach((shadowPathElement) {
          var shader = LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  tileMode: TileMode.clamp,
                  colors: element.shaderColors)
              .createShader(
                  Rect.fromLTWH(_startX, _endY, _fixedWidth, _fixedHeight));
          canvas
            ..drawPath(
                shadowPathElement,
                new Paint()
                  ..shader = shader
                  ..isAntiAlias = true
                  ..style = PaintingStyle.fill);
        });
      }
      if (element.paths != null) {
        //路径
        element.paths.forEach((pathElement) {
          var pathPaint = Paint()
            ..isAntiAlias = true
            ..strokeWidth = element.pathWidth
            ..strokeCap = StrokeCap.round
            ..color = element.pathColor
            ..style = PaintingStyle.stroke;
          canvas.drawPath(pathElement, pathPaint);
        });
      }
      if (element.points != null) {
        //点
        element.points.forEach((pointElement) {
          var pointPaint = Paint()
            ..isAntiAlias = true
            ..strokeCap = StrokeCap.round
            ..color = element.pointColor
            ..style = PaintingStyle.fill;
          canvas.drawCircle(Offset(pointElement.x, pointElement.y),
              element.pointRadius, pointPaint);
        });
      }
      if (element.placeImagePoints != null && element.placeImage != null) {
        //占位图
        element.placeImagePoints.forEach((placehoderElement) {
          canvas.drawImage(
              element.placeImage,
              Offset(placehoderElement.x - element.placeImage.width / 2,
                  _startY - 10 - element.placeImage.height),
              Paint());
        });
      }
    });
  }
}

//绘制图表的计算之后的结果模型集
class LineCanvasModel {
  List<Path> paths;
  Color pathColor;
  double pathWidth;

  List<Path> shadowPaths;
  List<Color> shaderColors;

  List<Point> points;
  Color pointColor;
  double pointRadius;

//占位图的底部中心点
  List<Point> placeImagePoints;
  ui.Image placeImage;
  LineCanvasModel(
      {this.paths,
      this.pathColor,
      this.pathWidth,
      this.shadowPaths,
      this.shaderColors,
      this.points,
      this.pointColor,
      this.pointRadius,
      this.placeImagePoints,
      this.placeImage});
}
