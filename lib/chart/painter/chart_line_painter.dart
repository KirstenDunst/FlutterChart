import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_content.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_focus_content.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_line_content.dart';
import 'package:flutter_chart_csx/chart/painter/base_painter.dart';
import 'package:flutter_chart_csx/chart/painter/base_painter_tool.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class ChartLinePainter extends BasePainter {
  //起始和结束距离两端y轴的单侧间距。默认无间距
  double bothEndPitchX;
  //绘制线条的参数内容
  List<ChartBeanSystem> chartBeanSystems;
  //x轴刻度显示，不传则没有
  List<DialStyleX>? xDialValues;
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
      this.pointSet = CellPointSet.normal,
      this.paintEnd});

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    _init(canvas, size);
    var models = _initPath(canvas);
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
  List<LineCanvasModel> _initPath(Canvas canvas) {
    var _lineCanvasModels = <LineCanvasModel>[];
    _lineTouchCellModels = <LineTouchCellModel>[];
    if (chartBeanSystems.isNotEmpty) {
      for (var i = 0; i < chartBeanSystems.length; i++) {
        var item = chartBeanSystems[i];
        var length = item.chartBeans.length;
        if (length == 0) {
          continue;
        }
        if (item.enableTouch) {
          _lineTouchCellModels.clear();
        }
        double? preY, currentY;
        late double preX, currentX;
        var paths = <Path>[], shadowPaths = <Path>[];
        var pointModels = <LinePointModel>[];
        var widthEnable = (_fixedWidth - 2 * bothEndPitchX); //两个点之间的x方向距离
        var _path = Path();
        var _shadowPath = Path();
        var _shadowStartPoint = Point(_startX, _startY);
        var hasLine = false;
        for (var j = 0; j < length; j++) {
          var cellBean = item.chartBeans[j];
          currentX = _startX +
              bothEndPitchX +
              (cellBean.xPositionRetioy.clamp(0.0, 1.0) * widthEnable);
          if (j == 0) {
            preX = currentX;
          }
          if (cellBean.y == null) {
            pointModels.add(_getPointModel(currentX, cellBean));
            if (!hasLine) {
              //去除开始就是null的一系列点设置,这些对_shadowPath无意义，但是pointModels还有一种加锁状态是需要cellBean.y == null来判断的，故写在这里
              continue;
            }
            _shadowPath
              ..lineTo(preX, _startY)
              ..lineTo(_shadowStartPoint.x.toDouble(),
                  _shadowStartPoint.y.toDouble())
              ..close();
            shadowPaths.add(_shadowPath);
            _shadowPath = Path();
            paths.add(_path);
            _path = Path();
            hasLine = false;
            continue;
          }
          currentY = (_startY -
              ((item.chartBeans[j].y!.clamp(baseBean.yMin, baseBean.yMax) -
                          baseBean.yMin) /
                      baseBean.yAdmissSecValue) *
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
          if (j == 0 || (j > 0 && item.chartBeans[j - 1].y == null)) {
            hasLine = true;
            _path.moveTo(currentX, currentY);
            _shadowStartPoint = Point(currentX, _startY);
            _shadowPath
              ..moveTo(currentX, _startY)
              ..lineTo(currentX, currentY);
          }
          pointModels
              .add(_getPointModel(currentX, cellBean, currentY: currentY));
          if (item.isCurve) {
            _path.cubicTo((preX + currentX) / 2, preY!, (preX + currentX) / 2,
                currentY, currentX, currentY);
            _shadowPath.cubicTo((preX + currentX) / 2, preY,
                (preX + currentX) / 2, currentY, currentX, currentY);
          } else {
            _path.lineTo(currentX, currentY);
            _shadowPath.lineTo(currentX, currentY);
          }
          if (j == length - 1) {
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

        var lineModel = LineCanvasModel(
          paths: paths,
          pathColor: item.lineColor,
          pathWidth: item.lineWidth,
          lineGradient: item.lineGradient,
          shadowPaths: shadowPaths,
          shaderColors: item.shaderColors,
          points: pointModels,
        );
        _lineCanvasModels.add(lineModel);
      }
    }
    return _lineCanvasModels;
  }

  //点模型
  LinePointModel _getPointModel(
    double currentX,
    ChartLineBean cellBean, {
    double? currentY,
  }) {
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
      if (lineElement.shaderColors != null) {
        lineElement.shadowPaths.forEach((shadowPathElement) {
          var shader = LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  tileMode: TileMode.clamp,
                  colors: lineElement.shaderColors!)
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
        return LineTouchBackModel(
          startOffset: null,
        );
      } else {
        return LineTouchBackModel(needRefresh: false, startOffset: null);
      }
    }
    _lineTouchCellModels
        .sort((a, b) => a.begainPoint.dx.compareTo(b.begainPoint.dx));
    LineTouchCellModel? touchModel;
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
    if (touchModel == null) {
      return LineTouchBackModel(
        startOffset: null,
      );
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
