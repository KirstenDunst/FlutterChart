import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_line.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_line_content.dart';
import 'package:flutter_chart_csx/chart/painter/base_painter.dart';
import 'package:flutter_chart_csx/chart/painter/base_painter_tool.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class ChartLinePainter extends BasePainter {
  List<ChartBeanSystem> chartBeanSystems; //绘制线条的参数内容

  double _startX, _endX, _startY, _endY, _fixedHeight, _fixedWidth;
  List<LineCanvasModel> _lineCanvasModels;

  ChartLinePainter(this.chartBeanSystems);

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    var xyPaint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = baseBean.xyLineWidth
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
    _initValue(size);
    _drawXy(canvas, xyPaint); //坐标轴
  }

  void _initValue(Size size) {
    _startX = baseBean.basePadding.left; //预留出y轴刻度值所占的空间
    _endX = size.width - baseBean.basePadding.right;
    _startY = size.height - baseBean.basePadding.bottom;
    _endY = baseBean.basePadding.top;
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
            var tempArr = <DialStyleX>[];
            for (var i = 0; i < item.chartBeans.length; i++) {
              tempArr.add(DialStyleX(
                  title: item.chartBeans[i].x,
                  titleStyle: item.xTitleStyle,
                  positionRetioy: item.chartBeans.length == 1
                      ? 0.0
                      : i / (item.chartBeans.length - 1)));
            }
            //绘制x轴的文字部分
            PainterTool.drawCoordinateAxis(
                canvas,
                CoordinateAxisModel(_fixedHeight, _fixedWidth,
                    baseBean: baseBean,
                    xDialValues: tempArr,
                    onlyYCoordinate: false));
          }
          double preX, preY, currentX, currentY;
          var length = item.chartBeans.length;
          var W = _fixedWidth / (length > 1 ? (length - 1) : 1); //两个点之间的x方向距离
          var _path = Path();
          var _shadowPath = Path();
          var _shadowStartPoint = Point(_startX, _startY);
          for (var i = 0; i < length; i++) {
            currentX = _startX + W * i;
            currentY = (_startY -
                (item.chartBeans[i].y / baseBean.yMax) * _fixedHeight);
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
                _shadowPath = Path();
                paths.add(_path);
                _path = Path();
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
            pointType: item.pointType ?? PointType.Circle,
            pointShaderColors:
                item.pointShaderColors ?? [item.lineColor, item.lineColor],
            pointRadius: item.pointRadius,
            placeImagePoints: placeImagepoints,
            placeImage: item.placehoderImage,
            placeImageRatio: item.placeImageRatio);
        _lineCanvasModels.add(lineModel);
      }
    }
  }

  ///x,y轴
  void _drawXy(Canvas canvas, Paint paint) {
    PainterTool.drawCoordinateAxis(
        canvas,
        CoordinateAxisModel(_fixedHeight, _fixedWidth,
            baseBean: baseBean, onlyYCoordinate: true));
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
                Paint()
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
        var pointPaint = Paint()
          ..isAntiAlias = true
          ..strokeWidth = 1
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.fill;

        var linerGradient = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.mirror,
            colors: element.pointShaderColors);
        var borderRaius = 0.0;
        switch (element.pointType) {
          case PointType.Circle:
            borderRaius = element.pointRadius;
            break;
          case PointType.Rectangle:
            borderRaius = 0;
            break;
          case PointType.RoundEdgeRectangle:
            borderRaius = element.pointRadius / 3 * 2;
            break;
          default:
        }
        //点
        element.points.forEach((pointElement) {
          var rect = Rect.fromLTRB(
              pointElement.x - element.pointRadius,
              pointElement.y - element.pointRadius,
              pointElement.x + element.pointRadius,
              pointElement.y + element.pointRadius);
          pointPaint.shader = linerGradient.createShader(rect);
          canvas.drawRRect(
              RRect.fromRectAndCorners(rect,
                  topLeft: Radius.circular(borderRaius),
                  topRight: Radius.circular(borderRaius),
                  bottomLeft: Radius.circular(borderRaius),
                  bottomRight: Radius.circular(borderRaius)),
              pointPaint);
        });
      }
      if (element.placeImagePoints != null && element.placeImage != null) {
        var ratio = element.placeImageRatio;
        if (element.placeImageRatio == null || element.placeImageRatio > 1.0) {
          ratio = 1.0;
        } else if (element.placeImageRatio < 0.0) {
          ratio = 0.0;
        }
        var tempImgWidth = element.placeImage.width * ratio;
        var tempImgHeight = element.placeImage.height * ratio;
        //占位图
        element.placeImagePoints.forEach((placehoderElement) {
          canvas.drawImageRect(
              element.placeImage,
              Rect.fromLTWH(0, 0, element.placeImage.width.toDouble(),
                  element.placeImage.height.toDouble()),
              Rect.fromLTWH(
                  placehoderElement.x - tempImgWidth / 2,
                  _startY - 10 * ratio - tempImgHeight,
                  tempImgWidth,
                  tempImgHeight),
              Paint());
        });
      }
    });
  }
}
