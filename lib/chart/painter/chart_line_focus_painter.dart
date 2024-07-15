import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_content.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_focus.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_focus_content.dart';
import 'package:flutter_chart_csx/chart/enum/painter_const.dart';
import 'package:path_drawing/path_drawing.dart';
import '../bean/chart_bean_line_common.dart';
import 'base_painter.dart';
import 'base_painter_tool.dart';

class ChartLineFocusPainter extends BasePainter {
  List<FocusChartBeanMain> focusChartBeans;
  //x轴刻度显示，不传则没有
  List<DialStyleX>? xDialValues;
  //x轴的区间带（不用的话不用设置）
  List<SectionBean>? xSectionBeans;
  //y轴区间带（不用的话不用设置）
  List<SectionBeanY>? ySectionBeans;
  //x轴最大值（以秒为单位），默认60
  int xMax;
  //触摸点设置
  CellPointSet pointSet;
  Offset? touchLocalPosition;
  //内容绘制结束
  VoidCallback? paintEnd;

  late double _startX, _endX, _startY, _endY;
  //坐标可容纳的宽高
  late double _fixedHeight, _fixedWidth, _xStepWidth;
  //y轴分布数值是否是正序，即y轴向上为正方向，y轴的值也是从下往上为从小变大的
  late bool _isPositiveSequence;
  late Map<double, TouchModel> _points;
  late Map<String, TagModel> _tagPoints;

  ChartLineFocusPainter(
    this.focusChartBeans, {
    this.xDialValues,
    this.xSectionBeans,
    this.ySectionBeans,
    this.xMax = 60,
    this.pointSet = CellPointSet.normal,
    this.touchLocalPosition,
    this.paintEnd,
  });

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    _init(size);
    //坐标轴
    _drawXy(canvas);
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
    for (var bean in focusChartBeans) {
      //处理数据
      var valueArr = LineFocusPainterTool.dealValue(
          bean.chartBeans, bean.isLinkBreak, baseBean.yMax, baseBean.yMin,
          showLineSection: bean.sectionModel != null);
      //计算路径并绘制
      _calculatePath(size, valueArr, bean, canvas);
    }

    if (_points.isNotEmpty && touchLocalPosition != null) {
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
    paintEnd?.call();
  }

  /// 初始化
  void _init(Size size) {
    _points = <double, TouchModel>{};
    _tagPoints = <String, TagModel>{};
    try {
      _isPositiveSequence =
          baseBean.yDialValues.first.yValue > baseBean.yDialValues.last.yValue;
    } catch (e) {
      _isPositiveSequence = true;
    }
    _initBorder(size);
  }

  /// 计算边界
  void _initBorder(Size size) {
    _startX = baseBean.basePadding.left;
    _endX = size.width - baseBean.basePadding.right;
    _startY = size.height - baseBean.basePadding.bottom;
    _endY = baseBean.basePadding.top;
    _fixedHeight = _startY - _endY;
    _fixedWidth = _endX - _startX;
    //折线轨迹,每个元素都是1秒的存在期
    _xStepWidth = (1 / xMax) * _fixedWidth; //x轴距离
  }

  /// x,y轴
  void _drawXy(Canvas canvas) {
    PainterTool.drawCoordinateAxis(
        canvas,
        CoordinateAxisModel(
          _fixedHeight,
          _fixedWidth,
          baseBean: baseBean,
          xDialValues: xDialValues ?? [],
        ));
  }

  /// 计算Path
  void _calculatePath(Size size, List<BeanDealModel> tempValueArr,
      FocusChartBeanMain bean, Canvas canvas) {
    if (tempValueArr.isEmpty) return;
    double? preX, preY, currentY;
    var currentX = _startX, oldX = _startX;
    Path? oldShadowTopPath = Path(),
        oldShadowBottomPath = Path(),
        path = Path();
    var shaderModel = bean.lineShader;
    var shaderIsContentFill = bean.lineShader?.shaderIsContentFill ?? true;
    //基准线距离x轴的高度
    var baseLineYHeight = shaderModel?.baseLineY == null
        ? 0
        : ((shaderModel!.baseLineY! - baseBean.yMin) /
            (baseBean.yMax - baseBean.yMin) *
            _fixedHeight);
    //渐变上层最大值点距离顶部最小距离
    var _shadowTopSpaceMin =
        shaderIsContentFill ? 0.0 : (_fixedHeight - baseLineYHeight);
    //渐变下层最小值点距离x轴最小距离
    var _shadowBottomSpaceMin = shaderIsContentFill ? 0.0 : baseLineYHeight;
    //线条区间带的记录上下连续
    var lineSections = <LineSection>[];
    var topPoints = <Offset>[], bottomPoints = <Offset>[];
    //小区域渐变色显示操作
    var shadowTopPaths = <ShadowSub>[];
    List<ShadowSub>? shadowBottomPaths =
        bean.lineShader?.baseLineBottomGradient == null ? null : <ShadowSub>[];
    //线条数组
    var pathArr = <PathModel>[];
    //用来控制中间过度线条的大小。
    var gradualStep = _xStepWidth / 4;
    var stepBegainX = _startX;
    //是否是触摸点位集合
    var isPressPoints = false;
    if (bean.touchEnable && _points.isEmpty) {
      isPressPoints = true;
    }
    var tempPointArr = <PointModel>[];
    for (var i = 0; i < tempValueArr.length; i++) {
      if (tempValueArr[i].value != null) {
        var tempNowLength =
            (tempValueArr[i].value! / baseBean.yAdmissSecValue) * _fixedHeight;
        currentY = _startY -
            (_isPositiveSequence
                ? tempNowLength
                : (_fixedHeight - tempNowLength));
        if ((_startY - currentY) > baseLineYHeight) {
          _shadowTopSpaceMin = min(_shadowTopSpaceMin, (currentY - _endY));
        } else {
          _shadowBottomSpaceMin =
              min(_shadowBottomSpaceMin, (_startY - currentY));
        }
        if (i == 0 || (i > 0 && (tempValueArr[i - 1].value == null))) {
          //初始化新起点
          path = Path()..moveTo(currentX, currentY);
          //顶部曲线向下封
          oldShadowTopPath = Path()
            ..moveTo(currentX, _startY)
            ..lineTo(currentX, currentY);
          //底部曲线向上封
          oldShadowBottomPath = Path()
            ..moveTo(currentX, _endY)
            ..lineTo(currentX, currentY);
          _dealLineSection(topPoints, bottomPoints, tempValueArr[i].valueMax,
              tempValueArr[i].valueMin, baseBean.yAdmissSecValue, currentX,
              lineSectionShow: bean.sectionModel != null);
          stepBegainX = currentX;
        }

        if (i > 0 &&
            (tempValueArr[i].value != null &&
                tempValueArr[i - 1].value != null)) {
          preX = oldX;
          var tempLastLength = tempValueArr[i - 1].value! /
              baseBean.yAdmissSecValue *
              _fixedHeight;
          preY = _startY -
              (_isPositiveSequence
                  ? tempLastLength
                  : (_fixedHeight - tempLastLength));
          if (bean.isCurve) {
            //曲线连接轨迹
            path!.cubicTo((preX + currentX) / 2, preY, (preX + currentX) / 2,
                currentY, currentX, currentY);
          } else {
            //直线连接轨迹
            path!.lineTo(currentX, currentY);
          }

          //阴影轨迹(如果渐变色已经设定的话也走一次性绘制)
          if (bean.lineShader != null ||
              _isSamePhase(
                  tempValueArr[i - 1].value!, tempValueArr[i].value!)) {
            if (bean.isCurve) {
              var x1 = (preX + currentX) / 2;
              var y1 = preY;
              var x2 = (preX + currentX) / 2;
              var y2 = currentY;
              var x3 = currentX;
              var y3 = currentY;
              oldShadowTopPath!.cubicTo(x1, y1, x2, y2, x3, y3);
              oldShadowBottomPath!.cubicTo(x1, y1, x2, y2, x3, y3);
            } else {
              oldShadowTopPath!.lineTo(currentX, currentY);
              oldShadowBottomPath!.lineTo(currentX, currentY);
            }
            _dealLineSection(topPoints, bottomPoints, tempValueArr[i].valueMax,
                tempValueArr[i].valueMin, baseBean.yAdmissSecValue, currentX,
                lineSectionShow: bean.sectionModel != null);
          } else {
            //这里lineShader为null,则没有oldShadowBottomPath以及相关的东西
            //暂时这里对于线条的曲线还是直线在跨域中不作处理，UI看起来会有点尴尬（即使是直线这里也是有弯曲过渡的），但是相邻点频繁跨域的话直线绘制还是需要有小柱显示（曲线的绘制方式），
            //处理比较麻烦暂时这个判断里面没有好的处理方式，其他的地方直线和曲线的处理已经做好了，只剩这里没有好的方案
            oldShadowTopPath!.lineTo(preX + gradualStep, preY);
            var shadowPath = Path();
            if ((_isPositiveSequence &&
                    tempValueArr[i - 1].value! > tempValueArr[i].value!) ||
                (!_isPositiveSequence &&
                    tempValueArr[i - 1].value! < tempValueArr[i].value!)) {
              oldShadowTopPath
                ..cubicTo((preX + currentX) / 2, preY, (preX + currentX) / 2,
                    currentY, currentX - gradualStep, currentY)
                ..lineTo(currentX - gradualStep, _startY)
                ..lineTo(stepBegainX, _startY)
                ..close();

              shadowPath
                ..moveTo(currentX, _startY)
                ..lineTo(currentX - gradualStep, _startY)
                ..lineTo(currentX - gradualStep, currentY);
            } else {
              oldShadowTopPath
                ..lineTo(preX + gradualStep, _startY)
                ..lineTo(stepBegainX, _startY)
                ..close();

              shadowPath
                ..moveTo(currentX, _startY)
                ..lineTo(preX + gradualStep, _startY)
                ..lineTo(preX + gradualStep, preY)
                ..cubicTo((preX + currentX) / 2, preY, (preX + currentX) / 2,
                    currentY, currentX - gradualStep, currentY);
            }
            shadowPath.lineTo(currentX, currentY);
            shadowTopPaths.add(
              ShadowSub(
                focusPath: oldShadowTopPath,
                rectGradient:
                    _shader(i - 1, stepBegainX, currentX, tempValueArr),
              ),
            );
            oldShadowTopPath = shadowPath;
            stepBegainX = currentX;
          }
        }

        if ((i < (tempValueArr.length - 1) &&
                tempValueArr[i + 1].value == null) ||
            (i == tempValueArr.length - 1)) {
          //结束点
          pathArr.add(
              PathModel(path: path, isHintLineImaginary: bean.isLineImaginary));
          var isBeyond = (currentX + gradualStep) > _endX;
          var tempX = isBeyond
              ? _endX
              : bean.isCurve
                  ? (currentX + gradualStep)
                  : currentX;
          oldShadowTopPath!
            ..lineTo(tempX, currentY)
            ..lineTo(tempX, _startY)
            ..lineTo(stepBegainX, _startY)
            ..close();
          oldShadowBottomPath!
            ..lineTo(tempX, currentY)
            ..lineTo(tempX, _endY)
            ..lineTo(stepBegainX, _endY)
            ..close();
          shadowTopPaths.add(ShadowSub(
              focusPath: oldShadowTopPath,
              rectGradient: bean.lineShader != null
                  ? null
                  : _shader(i, stepBegainX, currentX, tempValueArr)));
          shadowBottomPaths?.add(ShadowSub(
              focusPath: oldShadowBottomPath,
              rectGradient: bean.lineShader != null
                  ? null
                  : _shader(i, stepBegainX, currentX, tempValueArr)));
          if (topPoints.isNotEmpty || bottomPoints.isNotEmpty) {
            lineSections.add(
                LineSection(topPoints: topPoints, bottomPoints: bottomPoints));
            topPoints = <Offset>[];
            bottomPoints = <Offset>[];
          }
          path = null;
          oldShadowTopPath = null;
          oldShadowBottomPath = null;
        }
        if (tempValueArr[i].value != null) {
          tempPointArr.add(
            PointModel(
                offset: Offset(currentX, currentY),
                cellPointSet: tempValueArr[i].cellPointSet,
                sectionColor:
                    _getGradualColor(tempValueArr[i].value!, isPoint: true)
                        .first),
          );
        }
        if (isPressPoints) {
          var model = TouchModel(
              offset: Offset(currentX, currentY),
              touchBackValue: tempValueArr[i].touchBackValue);
          _points[currentX] = model;
        }
        //这里记录tag标记map,前面已经处理原始有值的数据才有真实的tag，其他的tag都是默认的空字符串
        _tagPoints[tempValueArr[i].tag] = TagModel(
            offset: Offset(currentX, currentY),
            backValue: tempValueArr[i].touchBackValue);
      }

      if ((currentX + gradualStep) > _endX) {
        // 绘制结束
        if (path != null &&
            oldShadowTopPath != null &&
            oldShadowBottomPath != null) {
          pathArr.add(
              PathModel(path: path, isHintLineImaginary: bean.isLineImaginary));
          oldShadowTopPath
            ..lineTo(_endX, _startY)
            ..lineTo(stepBegainX, _startY)
            ..close();
          oldShadowBottomPath
            ..lineTo(_endX, _endY)
            ..lineTo(stepBegainX, _endY)
            ..close();
          shadowTopPaths.add(ShadowSub(
              focusPath: oldShadowTopPath,
              rectGradient: bean.lineShader != null
                  ? null
                  : _shader(i, stepBegainX, currentX, tempValueArr)));
          shadowBottomPaths?.add(ShadowSub(
              focusPath: oldShadowBottomPath,
              rectGradient: bean.lineShader != null
                  ? null
                  : _shader(i, stepBegainX, currentX, tempValueArr)));
          if (topPoints.isNotEmpty || bottomPoints.isNotEmpty) {
            lineSections.add(
                LineSection(topPoints: topPoints, bottomPoints: bottomPoints));
            topPoints = <Offset>[];
            bottomPoints = <Offset>[];
          }
          path = null;
          oldShadowTopPath = null;
          oldShadowBottomPath = null;
        }
        if (tempValueArr[i].value != null) {
          tempPointArr.add(
            PointModel(
                offset: Offset(currentX, currentY!),
                cellPointSet: tempValueArr[i].cellPointSet,
                sectionColor:
                    _getGradualColor(tempValueArr[i].value!, isPoint: true)
                        .first),
          );
        }
        if (isPressPoints) {
          var model = TouchModel(
              offset: Offset(currentX, currentY!),
              touchBackValue: tempValueArr[i].touchBackValue);
          _points[currentX] = model;
        }
        if (bean.canvasEnd != null) {
          bean.canvasEnd!();
        }
        break;
      }
      oldX = currentX;
      currentX += _xStepWidth;
    }
    if (lineSections.isNotEmpty) {
      //绘制线条区间带
      _drawLineSection(lineSections, canvas, bean);
      shadowTopPaths.clear();
      shadowBottomPaths?.clear();
    }
    if (tempValueArr.isEmpty || baseBean.yAdmissSecValue <= 0) return;
    //先画阴影再画曲线，目的是防止阴影覆盖曲线
    if (bean.lineShader != null) {
      _drawShader(
          canvas,
          shadowTopPaths,
          shadowBottomPaths,
          _endY + _shadowTopSpaceMin,
          bean.lineShader!.baseLineTopGradient,
          _startY - baseLineYHeight,
          _startY - _shadowBottomSpaceMin,
          bean.lineShader!.baseLineBottomGradient);
    } else {
      _drawBulkShader(canvas, shadowTopPaths);
    }

    _drawLine(canvas, size, tempValueArr, pathArr, tempPointArr, bean); //曲线或折线
  }

  /// 处理线条区间
  void _dealLineSection(List<Offset> topOffset, List<Offset> bottomOffset,
      double yMax, double yMin, double baseBeanYMax, double currentX,
      {bool lineSectionShow = false}) {
    if (lineSectionShow) {
      var tempYMaxRate = (yMax / baseBeanYMax);
      var currentYMax = (_startY -
          ((_isPositiveSequence ? tempYMaxRate : (1 - tempYMaxRate)) *
              _fixedHeight));
      topOffset.add(Offset(currentX, currentYMax));
      var tempYMinRate = (yMin / baseBeanYMax);
      var currentYMin = (_startY -
          ((_isPositiveSequence ? tempYMinRate : (1 - tempYMinRate)) *
              _fixedHeight));
      bottomOffset.add(Offset(currentX, currentYMin));
    }
  }

  /// 是否属于同一区间
  bool _isSamePhase(double one, double other) {
    var oneExtrem = _getExtremum(one);
    var otherExtrem = _getExtremum(other);
    return oneExtrem == otherExtrem;
  }

  /// 获取可承载的阴影所在的最大高度
  double _getExtremum(double value) {
    var extremum = (_getCommonDealValueRelyOn(value)?.positionRetioy ?? 0.0) *
        _fixedHeight;
    return extremum;
  }

  /// 获取渐变色, [isPoint]应该是之前calm的时候定制的可渐变的点显示使用，后面优化可以以此参考
  List<Color> _getGradualColor(double value, {bool isPoint = false}) {
    var tempModel = _getCommonDealValueRelyOn(value);
    var defaultMainColor = (baseBean.yDialLeftMain
            ? tempModel?.leftSub?.centerSubTextStyle.color
            : tempModel?.rightSub?.centerSubTextStyle.color) ??
        defaultColor;
    if (isPoint) {
      return [defaultMainColor, defaultMainColor.withOpacity(0.3)];
    }
    //区间渐变颜色可自定义外抛
    return tempModel?.fillColors ??
        [defaultMainColor, defaultMainColor.withOpacity(0.3)];
  }

  DialStyleY? _getCommonDealValueRelyOn(double value) {
    DialStyleY? _tempDialStyleY;
    if (_isPositiveSequence) {
      if (value >= baseBean.yDialValues.first.yValue) {
        _tempDialStyleY = baseBean.yDialValues.first;
      } else if (value <= baseBean.yDialValues.last.yValue) {
        _tempDialStyleY = baseBean.yDialValues.last;
      } else {
        for (var i = 0; i < baseBean.yDialValues.length - 1; i++) {
          if (value <= baseBean.yDialValues[i].yValue &&
              value > baseBean.yDialValues[i + 1].yValue) {
            _tempDialStyleY = baseBean.yDialValues[i];
          }
        }
      }
    } else {
      if (value >= baseBean.yDialValues.last.yValue) {
        _tempDialStyleY = baseBean.yDialValues.last;
      } else if (value <= baseBean.yDialValues.first.yValue) {
        _tempDialStyleY = baseBean.yDialValues.first;
      } else {
        for (var i = 0; i < baseBean.yDialValues.length - 1; i++) {
          if (value > baseBean.yDialValues[i].yValue &&
              value <= baseBean.yDialValues[i + 1].yValue) {
            _tempDialStyleY = baseBean.yDialValues[i];
          }
        }
      }
    }
    return _tempDialStyleY;
  }

  /// 计算渐变的shader
  Shader _shader(int index, double preX, double currentX,
      List<BeanDealModel> tempValueArr) {
    var height = _startY - _getExtremum(tempValueArr[index].value ?? 0);
    //属于该专注力的固定小方块
    var rectFocus = Rect.fromLTRB(preX, height, currentX, _startY);
    var colors = _getGradualColor(tempValueArr[index].value ?? 0);
    return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.mirror,
            colors: colors)
        .createShader(rectFocus);
  }

  /// 线条区间带
  void _drawLineSection(
      List<LineSection> lineSections, Canvas canvas, FocusChartBeanMain bean) {
    if (lineSections.isEmpty) {
      return;
    }
    var topPaths = <Path>[];
    var bottomPaths = <Path>[];
    var shadowPaths = <Path>[];
    lineSections.forEach((element) {
      var topPath = Path()
        ..moveTo(element.topPoints!.first.dx, element.topPoints!.first.dy);
      var shadowPath = Path()
        ..moveTo(element.topPoints!.first.dx, element.topPoints!.first.dy);
      for (var i = 1; i < element.topPoints!.length; i++) {
        var temp = element.topPoints![i];
        if (bean.isCurve) {
          var lastElement = element.topPoints![i - 1];
          var tempDx = (lastElement.dx + temp.dx) / 2;
          topPath.cubicTo(
              tempDx, lastElement.dy, tempDx, temp.dy, temp.dx, temp.dy);
          shadowPath.cubicTo(
              tempDx, lastElement.dy, tempDx, temp.dy, temp.dx, temp.dy);
        } else {
          topPath.lineTo(temp.dx, temp.dy);
          shadowPath.lineTo(temp.dx, temp.dy);
        }
      }
      var bottomPath = Path()
        ..moveTo(element.bottomPoints!.last.dx, element.bottomPoints!.last.dy);
      shadowPath.lineTo(
          element.bottomPoints!.last.dx, element.bottomPoints!.last.dy);
      for (var i = element.bottomPoints!.length - 2; i >= 0; i--) {
        var temp = element.bottomPoints![i];
        if (bean.isCurve) {
          var lastElement = element.bottomPoints![i + 1];
          var tempDx = (lastElement.dx + temp.dx) / 2;
          bottomPath.cubicTo(
              tempDx, lastElement.dy, tempDx, temp.dy, temp.dx, temp.dy);
          shadowPath.cubicTo(
              tempDx, lastElement.dy, tempDx, temp.dy, temp.dx, temp.dy);
        } else {
          bottomPath.lineTo(temp.dx, temp.dy);
          shadowPath.lineTo(temp.dx, temp.dy);
        }
      }
      shadowPath
        ..lineTo(element.topPoints!.first.dx, element.topPoints!.first.dy)
        ..close();
      topPaths.add(topPath);
      bottomPaths.add(bottomPath);
      shadowPaths.add(shadowPath);
    });
    var shadowPaint = Paint()
      ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.mirror,
              colors:
                  bean.sectionModel!.fillColors ?? [defaultColor, defaultColor])
          .createShader(
              Rect.fromLTWH(_startX, _endY, _fixedWidth, _fixedHeight))
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    shadowPaths.forEach((sub) {
      canvas..drawPath(sub, shadowPaint);
    });

    //先画阴影再画曲线
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = bean.sectionModel!.borLineWidth
      ..strokeCap = StrokeCap.round
      ..color = bean.sectionModel!.lineSectionBorColor
      ..style = PaintingStyle.stroke;
    topPaths.forEach((path) {
      canvas.drawPath(
          bean.sectionModel!.isBorLineImaginary
              ? dashPath(
                  path,
                  dashArray: CircularIntervalList<double>(<double>[5.0, 4.0]),
                )
              : path,
          paint);
    });
    bottomPaths.forEach((path) {
      canvas.drawPath(
          bean.sectionModel!.isBorLineImaginary
              ? dashPath(
                  path,
                  dashArray: CircularIntervalList<double>(<double>[5.0, 4.0]),
                )
              : path,
          paint);
    });
  }

  // 绘制块状shader闭合渐变色
  void _drawBulkShader(Canvas canvas, List<ShadowSub> shadowTopPaths) {
    shadowTopPaths.forEach((sub) {
      canvas
        ..drawPath(
            sub.focusPath!,
            Paint()
              ..shader = sub.rectGradient
              ..isAntiAlias = true
              ..style = PaintingStyle.fill);
    });
  }

  // 绘制整体渐变shader闭合渐变色
  void _drawShader(
      Canvas canvas,
      List<ShadowSub> shadowTopPaths,
      List<ShadowSub>? shadowBottomPaths,
      double topShaderHeight,
      LinearGradientModel topGradient,
      double baseShaderHeight,
      double bottomShaderHeight,
      LinearGradientModel? bottomGradient) {
    canvas.save();
    //设置裁切区域（在区域内的路径才会被绘制）
    canvas.clipPath(Path()
      ..moveTo(_startX, topShaderHeight)
      ..lineTo(_endX, topShaderHeight)
      ..lineTo(_endX, baseShaderHeight)
      ..lineTo(_startX, baseShaderHeight)
      ..lineTo(_startX, topShaderHeight)
      ..close());
    shadowTopPaths.forEach((sub) {
      canvas
        ..drawPath(
            sub.focusPath!,
            Paint()
              ..shader = LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      tileMode: TileMode.clamp,
                      colors: topGradient.shaderColors,
                      stops: topGradient.shadowColorsStops)
                  .createShader(Rect.fromLTWH(_startX, topShaderHeight,
                      _fixedWidth, baseShaderHeight - topShaderHeight))
              ..isAntiAlias = true
              ..style = PaintingStyle.fill);
    });
    canvas.restore();
    if (shadowBottomPaths != null &&
        shadowBottomPaths.isNotEmpty &&
        bottomGradient != null) {
      canvas.save();
      //设置裁切区域（在区域内的路径才会被绘制）
      canvas.clipPath(Path()
        ..moveTo(_startX, baseShaderHeight)
        ..lineTo(_endX, baseShaderHeight)
        ..lineTo(_endX, bottomShaderHeight)
        ..lineTo(_startX, bottomShaderHeight)
        ..lineTo(_startX, baseShaderHeight)
        ..close());
      shadowBottomPaths.forEach((sub) {
        canvas
          ..drawPath(
              sub.focusPath!,
              Paint()
                ..shader = LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        tileMode: TileMode.clamp,
                        colors: bottomGradient.shaderColors,
                        stops: bottomGradient.shadowColorsStops)
                    .createShader(Rect.fromLTWH(_startX, baseShaderHeight,
                        _fixedWidth, bottomShaderHeight - baseShaderHeight))
                ..isAntiAlias = true
                ..style = PaintingStyle.fill);
      });
      canvas.restore();
    }
  }

  /// 曲线或折线
  void _drawLine(
      Canvas canvas,
      Size size,
      List<BeanDealModel> tempValueArr,
      List<PathModel> pathArr,
      List<PointModel> points,
      FocusChartBeanMain bean) {
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = bean.lineWidth
      ..strokeCap = StrokeCap.round
      ..color = bean.lineColor
      ..style = PaintingStyle.stroke;
    if (bean.lineGradient != null) {
      paint.shader = bean.lineGradient!.createShader(Rect.fromLTWH(
          baseBean.basePadding.left,
          baseBean.basePadding.top,
          size.width - baseBean.basePadding.horizontal,
          size.height - baseBean.basePadding.vertical));
    }
    pathArr.forEach((pathModel) {
      canvas.drawPath(
          pathModel.isHintLineImaginary
              ? dashPath(
                  pathModel.path!,
                  dashArray: CircularIntervalList<double>(<double>[5.0, 4.0]),
                )
              : pathModel.path!,
          paint);
    });

    //如果有点绘制需求，这里再绘制点位
    if (points.isNotEmpty) {
      points.forEach((model) {
        PainterTool.drawSpecialPointHintLine(
            canvas, model, _startX, _endX, _startY, _endY);
      });
    }
  }

  /// 外部拖拽获取触摸点最近的点位
  TouchModel getNearbyPoint(Offset localPosition,
      {bool outsidePointClear = true}) {
    if (localPosition.dx < _startX ||
        localPosition.dx > _endX ||
        localPosition.dy > _startY ||
        localPosition.dy < _endY) {
      //不在坐标轴内部的点击
      if (outsidePointClear) {
        return TouchModel(offset: null);
      } else {
        return TouchModel(needRefresh: false, offset: null);
      }
    }

    var poinArr = _points.keys.toList();
    poinArr.sort((num1, num2) => num1.compareTo(num2));
    if (poinArr.isEmpty) {
      return TouchModel(offset: null);
    }

    TouchModel? touchModel;
    //修复x轴越界
    if (localPosition.dx < poinArr.first) {
      touchModel = _points[poinArr.first];
    } else if (localPosition.dx > poinArr.last) {
      touchModel = _points[poinArr.last];
    } else {
      for (var i = 0; i < poinArr.length - 1; i++) {
        var currentX = poinArr[i];
        var nextX = poinArr[i + 1];
        if (localPosition.dx >= currentX && localPosition.dx < nextX) {
          var speaceWidth = nextX - currentX;
          if (localPosition.dx <= currentX + speaceWidth / 2) {
            touchModel = _points[currentX];
          } else {
            touchModel = _points[nextX];
          }
          break;
        }
      }
    }
    if (touchModel == null) {
      return TouchModel(
        offset: null,
      );
    } else {
      return touchModel;
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
