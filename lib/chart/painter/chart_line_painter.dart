import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_content.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_focus_content.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_line_content.dart';
import 'package:flutter_chart_csx/chart/base/base_painter.dart';
import 'package:flutter_chart_csx/chart/util/base_painter_tool.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class ChartLinePainter extends BasePainter {
  //起始和结束距离两端y轴的单侧间距。默认无间距
  double bothEndPitchX;
  //绘制线条的参数内容
  List<ChartBeanSystem> chartBeanSystems;
  //x轴刻度显示，不传则没有
  List<DialStyleX>? xDialValues;
  //x轴的区间带（不用的话不用设置）
  List<SectionBean>? xSectionBeans;
  //y轴区间带（不用的话不用设置）
  List<SectionBeanY>? ySectionBeans;
  //触摸选中点
  Offset? touchLocalPosition;
  //触摸点设置
  CellPointSet pointSet;
  //内容绘制结束
  VoidCallback? paintEnd;

  late double _startX, _endX, _startY, _endY, _fixedHeight, _fixedWidth;
  late List<LineTouchCellModel> _lineTouchCellModels;
  late Map<String, TagModel> _tagPoints;

  ChartLinePainter(this.chartBeanSystems,
      {this.bothEndPitchX = 0,
      this.touchLocalPosition,
      this.xDialValues,
      this.xSectionBeans,
      this.ySectionBeans,
      this.pointSet = CellPointSet.normal,
      this.paintEnd});

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    _init(canvas, size);
    //绘制x轴区间带
    if (xSectionBeans != null && xSectionBeans!.isNotEmpty) {
      PainterTool.drawXIntervalSegmentation(
          canvas, xSectionBeans!, _startX, _endX, _startY, _endY);
    }
    //绘制y轴区间带
    if (ySectionBeans != null && ySectionBeans!.isNotEmpty) {
      PainterTool.drawYIntervalSegmentation(
          canvas, ySectionBeans!, _startX, _endX, _startY, _endY);
    }
    var models = _initPath();
    _drawLine(canvas, models, size); //曲线或折线
    _drawTouchSpecialPointAndHitLine(canvas); //拖拽+点击的特殊点显示
    paintEnd?.call();
  }

  /// 初始化
  void _init(Canvas canvas, Size size) {
    _tagPoints = <String, TagModel>{};
    _initValue(size);
    _drawXY(canvas); //坐标轴
  }

  /// 初始化数据
  void _initValue(Size size) {
    _startX = baseBean.basePadding.left; //预留出y轴刻度值所占的空间
    _endX = size.width - baseBean.basePadding.right;
    _startY = size.height - baseBean.basePadding.bottom;
    _endY = baseBean.basePadding.top;
    _fixedHeight = _startY - _endY;
    _fixedWidth = _endX - _startX;
  }

  /// x,y轴
  void _drawXY(Canvas canvas) {
    PainterTool.drawCoordinateAxis(
        canvas,
        CoordinateAxisModel(_fixedHeight, _fixedWidth,
            baseBean: baseBean,
            xDialValues: xDialValues ?? [],
            xyCoordinate: XYCoordinate.All,
            bothEndPitchX: bothEndPitchX));
  }

  /// 计算Path
  List<LineCanvasModel> _initPath() {
    var _lineCanvasModels = <LineCanvasModel>[];
    _lineTouchCellModels = <LineTouchCellModel>[];
    if (chartBeanSystems.isNotEmpty) {
      for (var i = 0; i < chartBeanSystems.length; i++) {
        var item = chartBeanSystems[i];
        var shaderModel = item.lineShader;
        var shaderIsContentFill = item.lineShader?.shaderIsContentFill ?? true;
        //基准线距离x轴的高度
        var baseLineYHeight = shaderModel?.baseLineY == null
            ? 0
            : ((shaderModel!.baseLineY! - baseBean.yMin) /
                (baseBean.yMax - baseBean.yMin) *
                _fixedHeight);
        var length = item.chartBeans.length;
        if (length == 0) {
          continue;
        }
        if (item.enableTouch) {
          _lineTouchCellModels.clear();
        }
        double? preY, currentY;
        late double preX, currentX;
        var paths = <Path>[],
            shadowTopPaths = <Path>[],
            shadowBottomPaths = <Path>[];
        var pointModels = <LinePointModel>[];
        Offset? lastPoint, lastlastPoint;
        var widthEnable = (_fixedWidth - 2 * bothEndPitchX); //两个点之间的x方向距离
        var _path = Path(), _shadowTopPath = Path(), _shadowBottomPath = Path();
        //渐变上层最大值点距离顶部最小距离
        var _shadowTopSpaceMin =
            shaderIsContentFill ? 0.0 : (_fixedHeight - baseLineYHeight);
        //渐变下层最小值点距离x轴最小距离
        var _shadowBottomSpaceMin = shaderIsContentFill ? 0.0 : baseLineYHeight;
        //顶部曲线向下封
        var _shadowTopStartPoint = Point(_startX, _startY);
        //底部曲线向上封
        var _shadowBottomStartPoint = Point(_startX, _endY);
        var hasLine = false;
        for (var j = 0; j < length; j++) {
          var cellBean = item.chartBeans[j];
          var pointIsSpecial = cellBean.yShowText.isNotEmpty ||
              cellBean.cellPointSet != CellPointSet.normal;
          currentX = _startX +
              bothEndPitchX +
              (cellBean.xPositionRetioy.clamp(0.0, 1.0) * widthEnable);
          if (j == 0) {
            preX = currentX;
          }
          if (cellBean.y == null) {
            if (pointIsSpecial) {
              pointModels.add(_getPointModel(currentX, cellBean));
            }
            if (hasLine == true) {
              //去除开始就是null的一系列点设置,这些对_shadowPath无意义，但是pointModels还有一种加锁状态是需要cellBean.y == null来判断的，故写在这里
              _shadowTopPath
                ..lineTo(preX, _startY)
                ..lineTo(_shadowTopStartPoint.x.toDouble(),
                    _shadowTopStartPoint.y.toDouble())
                ..close();
              shadowTopPaths.add(_shadowTopPath);
              _shadowBottomPath
                ..lineTo(preX, _endY)
                ..lineTo(_shadowBottomStartPoint.x.toDouble(),
                    _shadowBottomStartPoint.y.toDouble())
                ..close();
              shadowBottomPaths.add(_shadowBottomPath);
              _shadowTopPath = Path();
              _shadowBottomPath = Path();
              paths.add(_path);
              _path = Path();
              hasLine = false;
            }
            preX = currentX;
            preY = currentY;
            if (lastlastPoint == null &&
                lastPoint != null &&
                item.alonePointSet != CellPointSet.normal) {
              pointModels.add(LinePointModel(
                  x: lastPoint.dx,
                  y: lastPoint.dy,
                  cellPointSet: item.alonePointSet));
            }
            lastlastPoint = lastlastPoint;
            lastPoint = null;
            continue;
          }
          currentY = (_startY -
              ((item.chartBeans[j].y!.clamp(baseBean.yMin, baseBean.yMax) -
                          baseBean.yMin) /
                      (baseBean.yAdmissSecValue == 0
                          ? 1
                          : baseBean.yAdmissSecValue)) *
                  _fixedHeight);
          //这里记录tag标记map,前面已经处理原始有值的数据才有真实的tag，其他的tag都是默认的空字符串
          _tagPoints[cellBean.tag] = TagModel(
              offset: Offset(currentX, currentY),
              backValue: cellBean.touchBackParam);
          if (j == 0) {
            preY = currentY;
          }
          if (item.enableTouch) {
            _lineTouchCellModels.add(LineTouchCellModel(
                begainPoint: Offset(currentX, currentY),
                param: cellBean.touchBackParam));
          }
          if (pointIsSpecial) {
            pointModels
                .add(_getPointModel(currentX, cellBean, currentY: currentY));
          } else if (lastPoint == null &&
              cellBean.y != null &&
              j == length - 1 &&
              item.alonePointSet != CellPointSet.normal) {
            //这条线最后一点有值，前面没数值，也做孤独点处理
            pointModels.add(LinePointModel(
                x: currentX, y: currentY, cellPointSet: item.alonePointSet));
          }
          if (j == 0 || (j > 0 && item.chartBeans[j - 1].y == null)) {
            _path.moveTo(currentX, currentY);
            _shadowTopStartPoint = Point(currentX, _startY);
            _shadowTopPath
              ..moveTo(currentX, _startY)
              ..lineTo(currentX, currentY);
            _shadowBottomStartPoint = Point(currentX, _endY);
            _shadowBottomPath
              ..moveTo(currentX, _endY)
              ..lineTo(currentX, currentY);
            hasLine = true;
          } else {
            if (item.isCurve) {
              var x1 = (preX + currentX) / 2;
              var y1 = preY!;
              var x2 = (preX + currentX) / 2;
              var y2 = currentY;
              var x3 = currentX;
              var y3 = currentY;
              _path.cubicTo(x1, y1, x2, y2, x3, y3);
              _shadowTopPath.cubicTo(x1, y1, x2, y2, x3, y3);
              _shadowBottomPath.cubicTo(x1, y1, x2, y2, x3, y3);
            } else {
              _path.lineTo(currentX, currentY);
              _shadowTopPath.lineTo(currentX, currentY);
              _shadowBottomPath.lineTo(currentX, currentY);
            }
          }
          if ((_startY - currentY) > baseLineYHeight) {
            _shadowTopSpaceMin = min(_shadowTopSpaceMin, (currentY - _endY));
          } else {
            _shadowBottomSpaceMin =
                min(_shadowBottomSpaceMin, (_startY - currentY));
          }

          if (j == length - 1) {
            _shadowTopPath
              ..lineTo(currentX, _startY)
              ..lineTo(_shadowTopStartPoint.x.toDouble(),
                  _shadowTopStartPoint.y.toDouble())
              ..close();
            _shadowBottomPath
              ..lineTo(currentX, _endY)
              ..lineTo(_shadowBottomStartPoint.x.toDouble(),
                  _shadowBottomStartPoint.y.toDouble())
              ..close();
          }
          preX = currentX;
          preY = currentY;
          lastlastPoint = lastPoint;
          lastPoint = Offset(currentX, currentY);
        }
        paths.add(_path);
        shadowTopPaths.add(_shadowTopPath);
        shadowBottomPaths.add(_shadowBottomPath);

        var lineModel = LineCanvasModel(
            paths: paths,
            pathColor: item.lineColor,
            pathWidth: item.lineWidth,
            lineGradient: item.lineGradient,
            baseLineTopShadow: shadowTopPaths.isEmpty || item.lineShader == null
                ? null
                : LineShadowModel(
                    shadowPaths: shadowTopPaths,
                    linearGradient: item.lineShader!.baseLineTopGradient,
                    shadowTopHeight: _endY + _shadowTopSpaceMin,
                    shadowBottomHeight: _startY - baseLineYHeight),
            baseLineBottomShadow: shadowBottomPaths.isEmpty ||
                    item.lineShader == null ||
                    item.lineShader!.baseLineBottomGradient == null
                ? null
                : LineShadowModel(
                    shadowPaths: shadowBottomPaths,
                    linearGradient: item.lineShader!.baseLineBottomGradient!,
                    shadowTopHeight: _startY - baseLineYHeight,
                    shadowBottomHeight: _startY - _shadowBottomSpaceMin),
            points: pointModels);
        _lineCanvasModels.add(lineModel);
      }
    }
    return _lineCanvasModels;
  }

  //点模型
  LinePointModel _getPointModel(double currentX, ChartLineBean cellBean,
      {double? currentY}) {
    return LinePointModel(
      x: currentX,
      y: currentY,
      text: cellBean.yShowText,
      textStyle: cellBean.yShowTextStyle,
      pointToTextSpace: cellBean.pointToTextSpace,
      cellPointSet: cellBean.cellPointSet,
    );
  }

  /// 曲线或折线
  void _drawLine(
      Canvas canvas, List<LineCanvasModel> lineCanvasModels, Size size) {
    lineCanvasModels.forEach((lineElement) {
      //阴影区域
      if (lineElement.baseLineTopShadow != null) {
        canvas.save();
        //设置裁切区域（在区域内的路径才会被绘制）
        canvas.clipPath(Path()
          ..moveTo(_startX, lineElement.baseLineTopShadow!.shadowTopHeight)
          ..lineTo(_endX, lineElement.baseLineTopShadow!.shadowTopHeight)
          ..lineTo(_endX, lineElement.baseLineTopShadow!.shadowBottomHeight)
          ..lineTo(_startX, lineElement.baseLineTopShadow!.shadowBottomHeight)
          ..lineTo(_startX, lineElement.baseLineTopShadow!.shadowTopHeight)
          ..close());
        lineElement.baseLineTopShadow!.shadowPaths.forEach((shadowPathElement) {
          var shader = LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  tileMode: TileMode.clamp,
                  colors: lineElement
                      .baseLineTopShadow!.linearGradient.shaderColors,
                  stops: lineElement
                      .baseLineTopShadow!.linearGradient.shadowColorsStops)
              .createShader(Rect.fromLTWH(
                  _startX,
                  lineElement.baseLineTopShadow!.shadowTopHeight,
                  _fixedWidth,
                  lineElement.baseLineTopShadow!.shadowHeigth));
          canvas
            ..drawPath(
                shadowPathElement,
                Paint()
                  ..shader = shader
                  ..isAntiAlias = true
                  ..style = PaintingStyle.fill);
        });
        canvas.restore();
      }
      if (lineElement.baseLineBottomShadow != null) {
        canvas.save();
        //设置裁切区域（在区域内的路径才会被绘制）
        canvas.clipPath(Path()
          ..moveTo(_startX, lineElement.baseLineBottomShadow!.shadowTopHeight)
          ..lineTo(_endX, lineElement.baseLineBottomShadow!.shadowTopHeight)
          ..lineTo(_endX, lineElement.baseLineBottomShadow!.shadowBottomHeight)
          ..lineTo(
              _startX, lineElement.baseLineBottomShadow!.shadowBottomHeight)
          ..lineTo(_startX, lineElement.baseLineBottomShadow!.shadowTopHeight)
          ..close());

        lineElement.baseLineBottomShadow!.shadowPaths
            .forEach((shadowPathElement) {
          var shader = LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  tileMode: TileMode.clamp,
                  colors: lineElement
                      .baseLineBottomShadow!.linearGradient.shaderColors,
                  stops: lineElement
                      .baseLineBottomShadow!.linearGradient.shadowColorsStops)
              .createShader(Rect.fromLTWH(
                  _startX,
                  lineElement.baseLineBottomShadow!.shadowTopHeight,
                  _fixedWidth,
                  lineElement.baseLineBottomShadow!.shadowHeigth));
          canvas
            ..drawPath(
                shadowPathElement,
                Paint()
                  ..shader = shader
                  ..isAntiAlias = true
                  ..style = PaintingStyle.fill);
        });
        canvas.restore();
      }

      //路径
      lineElement.paths.forEach((pathElement) {
        var pathPaint = Paint()
          ..isAntiAlias = true
          ..strokeWidth = lineElement.pathWidth
          ..strokeCap = StrokeCap.round
          ..color = lineElement.pathColor
          ..style = PaintingStyle.stroke;
        if (lineElement.lineGradient != null) {
          pathPaint.shader = lineElement.lineGradient!.createShader(
              Rect.fromLTWH(
                  baseBean.basePadding.left,
                  baseBean.basePadding.top,
                  size.width - baseBean.basePadding.horizontal,
                  size.height - baseBean.basePadding.vertical));
        }
        canvas.drawPath(pathElement, pathPaint);
      });

      for (var i = 0; i < lineElement.points.length; i++) {
        var tempElement = lineElement.points[i];
        // 点绘制
        PainterTool.drawSpecialPointHintLine(
            canvas,
            PointModel(
                offset: Offset(tempElement.x, tempElement.y ?? _startY - 10),
                cellPointSet: tempElement.cellPointSet),
            _startX,
            _endX,
            _startY,
            _endY);
        if (tempElement.y == null) {
          continue;
        }
        //文字
        var tpx = TextPainter(
            textAlign: TextAlign.center,
            ellipsis: '.',
            text:
                TextSpan(text: tempElement.text, style: tempElement.textStyle),
            textDirection: TextDirection.ltr)
          ..layout();
        tpx.paint(
          canvas,
          Offset(tempElement.x - tpx.width / 2,
              tempElement.y! - tempElement.pointToTextSpace - tpx.height),
        );
      }
    });
  }

  //绘制特殊点
  void _drawTouchSpecialPointAndHitLine(Canvas canvas) {
    if (_lineTouchCellModels.isNotEmpty && touchLocalPosition != null) {
      //表示有设置可以触摸的线条
      PainterTool.drawSpecialPointHintLine(
          canvas,
          PointModel(
            offset: touchLocalPosition!,
            cellPointSet: pointSet,
          ),
          _startX,
          _endX,
          _startY,
          _endY);
    }
  }

  //外部拖拽获取触摸点最近的点位, 点击坐标轴以外区域直接返回空offset，和取消一样的效果
  LineTouchBackModel getNearbyPoint(Offset localPosition,
      {bool outsidePointClear = true}) {
    if (localPosition.dx < _startX ||
        localPosition.dx > _endX ||
        localPosition.dy > _startY ||
        localPosition.dy < _endY) {
      //不在坐标轴内部的点击
      if (outsidePointClear) {
        return LineTouchBackModel(startOffset: null);
      } else {
        return LineTouchBackModel(needRefresh: false, startOffset: null);
      }
    }
    _lineTouchCellModels
        .sort((a, b) => a.begainPoint.dx.compareTo(b.begainPoint.dx));
    LineTouchCellModel? touchModel;
    if (_lineTouchCellModels.length == 1) {
      touchModel = _lineTouchCellModels.first;
    } else {
      for (var i = 0; i < _lineTouchCellModels.length - 1; i++) {
        var currentX = _lineTouchCellModels[i].begainPoint.dx;
        var nextX = _lineTouchCellModels[i + 1].begainPoint.dx;
        if (i == 0 && localPosition.dx < currentX) {
          touchModel = _lineTouchCellModels.first;
          break;
        }
        if (i == _lineTouchCellModels.length - 2 && localPosition.dx >= nextX) {
          touchModel = _lineTouchCellModels[i + 1];
          break;
        }
        if (localPosition.dx >= currentX && localPosition.dx < nextX) {
          var speaceWidth = nextX - currentX;
          if (localPosition.dx <= currentX + speaceWidth / 2) {
            touchModel = _lineTouchCellModels[i];
          } else {
            touchModel = _lineTouchCellModels[i + 1];
          }
          break;
        }
      }
    }
    if (touchModel == null) {
      return LineTouchBackModel(startOffset: null);
    } else {
      return LineTouchBackModel(
          startOffset: touchModel.begainPoint, backParam: touchModel.param);
    }
  }

  //外部根据tag获取点偏移信息
  TagSearchedModel? getDetailWithTag(String tag) {
    if (_tagPoints.containsKey(tag)) {
      var tempModel = _tagPoints[tag]!;
      return TagSearchedModel(
          xyTopLeftOffset: Offset(_startX, _endY),
          pointOffset: tempModel.offset,
          backValue: tempModel.backValue);
    }
    return null;
  }
}
