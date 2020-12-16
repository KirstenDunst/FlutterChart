import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_focus.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_focus_content.dart';
import 'package:flutter_chart_csx/chart/enum/painter_const.dart';
import 'package:path_drawing/path_drawing.dart';
import 'base_painter.dart';
import 'base_painter_tool.dart';

class ChartLineFocusPainter extends BasePainter {
  List<FocusChartBeanMain> focusChartBeans;
  List<DialStyleX> xDialValues; //x轴刻度显示，不传则没有
  List<SectionBean> xSectionBeans; //x轴的区间带（不用的话不用设置）
  //x轴最大值（以秒为单位）
  int xMax = 60;
  //触摸参数设置
  bool isPressedHintDottedLine; //触摸辅助线是否为虚线
  double pressedPointRadius; //触摸点半径，大于两点间距一半的的时候会默认间距一半的宽度
  double pressedHintLineWidth; //触摸辅助线宽度
  Color pressedHintLineColor; //触摸辅助线颜色
  Offset touchLocalPosition;

  double _startX, _endX, _startY, _endY;
  double _fixedHeight, _fixedWidth, _xStepWidth; //坐标可容纳的宽高
  //y轴分布数值是否是正序，即小的在前大的在后
  bool _isPositiveSequence;
  Map<double, TouchModel> _points;

  ChartLineFocusPainter(
    this.focusChartBeans, {
    this.xDialValues,
    this.xSectionBeans,
    this.xMax,
    this.isPressedHintDottedLine = true,
    this.pressedPointRadius = 4,
    this.pressedHintLineWidth = 1,
    this.pressedHintLineColor = defaultColor,
    this.touchLocalPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    _init(size);
    _drawXy(canvas); //坐标轴

    for (var bean in focusChartBeans) {
      //处理数据
      var valueArr = LineFocusPainterTool.dealValue(
          bean.chartBeans, bean.isLinkBreak, baseBean.yMax,
          showLineSection: bean.showLineSection);
      //计算路径并绘制
      _calculatePath(size, valueArr, bean, canvas);
    }

    //绘制区间带
    if (xSectionBeans != null && xSectionBeans.isNotEmpty) {
      PainterTool.drawXIntervalSegmentation(
          canvas, xSectionBeans, _startX, _endX, _startY, _endY);
    }
    if (_points.isNotEmpty) {
      //表示有设置可以触摸的线条
      PainterTool.drawSpecialPointHintLine(
          canvas,
          SpecialPointModel(
            offset: touchLocalPosition,
            hintEdgeInset: HintEdgeInset.all(
              PointHintParam(
                  hintColor: pressedHintLineColor,
                  isHintLineImaginary: isPressedHintDottedLine,
                  hintLineWidth: pressedHintLineWidth),
            ),
            specialPointColor: pressedHintLineColor,
            specialPointWidth: pressedPointRadius,
          ),
          _startX,
          _endX,
          _startY,
          _endY);
    }
  }

  @override
  bool shouldRepaint(ChartLineFocusPainter oldDelegate) {
    return true;
  }

  ///初始化
  void _init(Size size) {
    xMax ??= 60;
    isPressedHintDottedLine ??= true;
    pressedPointRadius ??= 4;
    pressedHintLineWidth ??= 1;
    pressedHintLineColor ??= defaultColor;
    _isPositiveSequence = true;
    _points = <double, TouchModel>{};
    try {
      _isPositiveSequence = baseBean.yDialValues.first.titleValue <
          baseBean.yDialValues.last.titleValue;
      // ignore: empty_catches
    } catch (e) {}
    _initBorder(size);
  }

  ///计算边界
  void _initBorder(Size size) {
    _startX = baseBean.basePadding.left;
    _endX = size.width - baseBean.basePadding.right;
    _startY = size.height - baseBean.basePadding.bottom;
    _endY = baseBean.basePadding.top;
    _fixedHeight = _startY - _endY;
    _fixedWidth = _endX - _startX;
    _xStepWidth = 0;
    try {
      //折线轨迹,每个元素都是1秒的存在期
      _xStepWidth = (1 / xMax) * _fixedWidth; //x轴距离
      // ignore: empty_catches
    } catch (e) {}
  }

  ///x,y轴
  void _drawXy(Canvas canvas) {
    PainterTool.drawCoordinateAxis(
        canvas,
        CoordinateAxisModel(
          _fixedHeight,
          _fixedWidth,
          baseBean: baseBean ?? BaseBean(),
          xDialValues: xDialValues,
        ));
  }

  ///计算Path
  void _calculatePath(Size size, List<BeanDealModel> tempValueArr,
      FocusChartBeanMain bean, Canvas canvas) {
    if (tempValueArr.isEmpty) return;
    double preX, preY, currentX = _startX, currentY, oldX = _startX;
    var oldShadowPath = Path();
    var path = Path();

    //线条区间带的记录上下连续
    var lineSections = <LineSection>[];
    var topPoints = <Offset>[];
    var bottomPoints = <Offset>[];

    //小区域渐变色显示操作
    var shadowPaths = <ShadowSub>[];
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
    var specialPointArr = <SpecialPointModel>[];
    for (var i = 0; i < tempValueArr.length; i++) {
      if (tempValueArr[i].value != null) {
        currentY = (_startY -
            ((tempValueArr[i].value / baseBean.yMax) * _fixedHeight));
        if (i == 0 || (i > 0 && (tempValueArr[i - 1].value == null))) {
          //初始化新起点
          var newPath = Path();
          path = newPath;
          path.moveTo(currentX, currentY);
          var shadowPath = Path();
          shadowPath.moveTo(currentX, _startY);
          shadowPath.lineTo(currentX, currentY);
          oldShadowPath = shadowPath;
          _dealLineSection(topPoints, bottomPoints, tempValueArr[i].valueMax,
              tempValueArr[i].valueMin, baseBean.yMax, currentX,
              lineSectionShow: bean.showLineSection);
          stepBegainX = currentX;
        }

        if (i > 0 &&
            (tempValueArr[i].value != null &&
                tempValueArr[i - 1].value != null)) {
          preX = oldX;
          preY = (_startY -
              tempValueArr[i - 1].value / baseBean.yMax * _fixedHeight);
          if (bean.isCurve) {
            //曲线连接轨迹
            path.cubicTo((preX + currentX) / 2, preY, (preX + currentX) / 2,
                currentY, currentX, currentY);
          } else {
            //直线连接轨迹
            path.lineTo(currentX, currentY);
          }

          //阴影轨迹(如果渐变色已经设定的话也走一次性绘制)
          if (bean.gradualColors != null ||
              _isSamePhase(tempValueArr[i - 1].value, tempValueArr[i].value)) {
            if (bean.isCurve) {
              oldShadowPath.cubicTo((preX + currentX) / 2, preY,
                  (preX + currentX) / 2, currentY, currentX, currentY);
            } else {
              oldShadowPath.lineTo(currentX, currentY);
            }
            _dealLineSection(topPoints, bottomPoints, tempValueArr[i].valueMax,
                tempValueArr[i].valueMin, baseBean.yMax, currentX,
                lineSectionShow: bean.showLineSection);
          } else {
            //暂时这里对于线条的曲线还是直线在跨域中不作处理，UI看起来会有点尴尬（即使是直线这里也是有弯曲过渡的），但是相邻点频繁跨域的话直线绘制还是需要有小柱显示（曲线的绘制方式），
            //处理比较麻烦暂时这个判断里面没有好的处理方式，其他的地方直线和曲线的处理已经做好了，只剩这里没有好的方案
            oldShadowPath.lineTo(preX + gradualStep, preY);
            var shadowPath = Path();
            if (tempValueArr[i - 1].value > tempValueArr[i].value) {
              oldShadowPath
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
              oldShadowPath
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
            shadowPaths.add(
              ShadowSub(
                focusPath: oldShadowPath,
                rectGradient: _shader(i - 1, stepBegainX, currentX,
                    tempValueArr, bean.gradualColors),
              ),
            );
            oldShadowPath = shadowPath;
            stepBegainX = currentX;
          }
        }

        if ((i < (tempValueArr.length - 1) &&
                tempValueArr[i + 1].value == null) ||
            (i == tempValueArr.length - 1)) {
          //结束点
          pathArr.add(
            PathModel(path: path, isHintLineImaginary: bean.isLineImaginary),
          );
          var isBeyond = (currentX + gradualStep) > _endX;
          var tempX = isBeyond
              ? _endX
              : bean.isCurve
                  ? (currentX + gradualStep)
                  : currentX;
          oldShadowPath
            ..lineTo(tempX, currentY)
            ..lineTo(tempX, _startY)
            ..lineTo(stepBegainX, _startY)
            ..close();
          shadowPaths.add(
            ShadowSub(
              focusPath: oldShadowPath,
              rectGradient: _shader(
                  i, stepBegainX, currentX, tempValueArr, bean.gradualColors),
            ),
          );
          if (topPoints.isNotEmpty || bottomPoints.isNotEmpty) {
            lineSections.add(
                LineSection(topPoints: topPoints, bottomPoints: bottomPoints));
            topPoints = <Offset>[];
            bottomPoints = <Offset>[];
          }
          path = null;
          oldShadowPath = null;
        }
        if (bean.showSite && tempValueArr[i].value != null) {
          tempPointArr.add(
            PointModel(
                offset: Offset(currentX, currentY),
                color: _getGradualColor(tempValueArr[i].value, null).first),
          );
        }
        var tempDealModel = tempValueArr[i];
        if (tempDealModel.hintEdgeInset != null ||
            tempDealModel.centerPoint != null) {
          specialPointArr.add(
            SpecialPointModel(
                offset: Offset(currentX, currentY),
                hintEdgeInset: tempDealModel.hintEdgeInset,
                centerPoint: tempDealModel.centerPoint,
                centerPointOffset: tempDealModel.centerPointOffset,
                centerPointOffsetLineColor:
                    tempDealModel.centerPointOffsetLineColor,
                placeImageSize: tempDealModel.placeImageSize),
          );
        }
        if (isPressPoints && currentY != null) {
          _points[currentX] = TouchModel(
              offset: Offset(currentX, currentY),
              touchBackValue: tempValueArr[i].touchBackValue);
        }
      }

      if ((currentX + gradualStep) > _endX) {
        // 绘制结束
        if (path != null && oldShadowPath != null) {
          pathArr.add(
            PathModel(path: path, isHintLineImaginary: bean.isLineImaginary),
          );
          oldShadowPath
            ..lineTo(_endX, _startY)
            ..lineTo(stepBegainX, _startY)
            ..close();
          shadowPaths.add(
            ShadowSub(
              focusPath: oldShadowPath,
              rectGradient: _shader(
                  i, stepBegainX, currentX, tempValueArr, bean.gradualColors),
            ),
          );
          if (topPoints.isNotEmpty || bottomPoints.isNotEmpty) {
            lineSections.add(
                LineSection(topPoints: topPoints, bottomPoints: bottomPoints));
            topPoints = <Offset>[];
            bottomPoints = <Offset>[];
          }
          path = null;
          oldShadowPath = null;
        }
        if (bean.showSite && tempValueArr[i].value != null) {
          tempPointArr.add(
            PointModel(
                offset: Offset(currentX, currentY),
                color: _getGradualColor(tempValueArr[i].value, null).first),
          );
        }
        var tempDealModel = tempValueArr[i];
        if (tempDealModel.hintEdgeInset != null ||
            tempDealModel.centerPoint != null) {
          specialPointArr.add(
            SpecialPointModel(
                offset: Offset(currentX, currentY),
                hintEdgeInset: tempDealModel.hintEdgeInset,
                centerPoint: tempDealModel.centerPoint,
                centerPointOffset: tempDealModel.centerPointOffset,
                centerPointOffsetLineColor:
                    tempDealModel.centerPointOffsetLineColor,
                placeImageSize: tempDealModel.placeImageSize),
          );
        }
        if (isPressPoints) {
          _points[currentX] = TouchModel(
              offset: Offset(currentX, currentY),
              touchBackValue: tempValueArr[i].touchBackValue);
        }
        if (bean.canvasEnd != null) {
          bean.canvasEnd();
        }
        break;
      }
      oldX = currentX;
      currentX += _xStepWidth;
    }
    if (lineSections.isNotEmpty) {
      //绘制线条区间带
      _drawLineSection(lineSections, canvas, bean);
      shadowPaths.clear();
    }
    _drawLine(canvas, size, tempValueArr, shadowPaths, pathArr, tempPointArr,
        specialPointArr, bean); //曲线或折线
  }

  void _dealLineSection(List<Offset> topOffset, List<Offset> bottomOffset,
      double yMax, double yMin, double baseBeanYMax, double currentX,
      {bool lineSectionShow = false}) {
    if (lineSectionShow) {
      var currentYMax = (_startY - ((yMax / baseBeanYMax) * _fixedHeight));
      topOffset.add(Offset(currentX, currentYMax));
      var currentYMin = (_startY - ((yMin / baseBeanYMax) * _fixedHeight));
      bottomOffset.add(Offset(currentX, currentYMin));
    }
  }

  bool _isSamePhase(double one, double other) {
    var same = false;
    var oneExtrem = _getExtremum(one, null);
    var otherExtrem = _getExtremum(other, null);
    same = oneExtrem == otherExtrem;
    return same;
  }

  double _getExtremum(double value, List<Color> gradualColors) {
    if (gradualColors != null) {
      return _fixedHeight;
    }
    var extremum = 0.0;
    if (_isPositiveSequence && value >= baseBean.yDialValues.last.titleValue) {
      extremum =
          baseBean.yDialValues.last.titleValue / baseBean.yMax * _fixedHeight;
    } else if (!_isPositiveSequence &&
        value >= baseBean.yDialValues.first.titleValue) {
      extremum =
          baseBean.yDialValues.first.titleValue / baseBean.yMax * _fixedHeight;
    } else {
      for (var i = 0; i < baseBean.yDialValues.length - 1; i++) {
        if (value > baseBean.yDialValues[i].titleValue &&
            value <= baseBean.yDialValues[i + 1].titleValue) {
          extremum = baseBean.yDialValues[i + 1].titleValue /
              baseBean.yMax *
              _fixedHeight;
        } else if (value <= baseBean.yDialValues[i].titleValue &&
            value > baseBean.yDialValues[i + 1].titleValue) {
          extremum =
              baseBean.yDialValues[i].titleValue / baseBean.yMax * _fixedHeight;
        }
      }
    }
    return extremum;
  }

  List<Color> _getGradualColor(double value, List<Color> gradualColors) {
    if (gradualColors != null) {
      return gradualColors;
    }
    var mainColor = defaultColor;
    if (_isPositiveSequence && value >= baseBean.yDialValues.last.titleValue) {
      mainColor = baseBean.yDialValues.last.centerSubTextStyle.color;
    } else if (!_isPositiveSequence &&
        value >= baseBean.yDialValues.first.titleValue) {
      mainColor = baseBean.yDialValues.first.centerSubTextStyle.color;
    } else {
      for (var i = 0; i < baseBean.yDialValues.length - 1; i++) {
        if (value <= baseBean.yDialValues[i].titleValue &&
            value > baseBean.yDialValues[i + 1].titleValue) {
          mainColor = baseBean.yDialValues[i].centerSubTextStyle.color;
        } else if (value > baseBean.yDialValues[i].titleValue &&
            value <= baseBean.yDialValues[i + 1].titleValue) {
          mainColor = baseBean.yDialValues[i + 1].centerSubTextStyle.color;
        }
      }
    }
    return [mainColor, mainColor.withOpacity(0.3)];
  }

  Shader _shader(int index, double preX, double currentX,
      List<BeanDealModel> tempValueArr, List<Color> gradualColors) {
    var height =
        _startY - _getExtremum(tempValueArr[index].value, gradualColors);
    //属于该专注力的固定小方块
    var rectFocus = Rect.fromLTRB(preX, height, currentX, _startY);
    return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.mirror,
            colors: _getGradualColor(tempValueArr[index].value, gradualColors))
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
        ..moveTo(element.topPoints.first.dx, element.topPoints.first.dy);
      var shadowPath = Path()
        ..moveTo(element.topPoints.first.dx, element.topPoints.first.dy);
      for (var i = 1; i < element.topPoints.length; i++) {
        var temp = element.topPoints[i];
        if (bean.isCurve) {
          var lastElement = element.topPoints[i - 1];
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
        ..moveTo(element.bottomPoints.last.dx, element.bottomPoints.last.dy);
      shadowPath.lineTo(
          element.bottomPoints.last.dx, element.bottomPoints.last.dy);
      for (var i = element.bottomPoints.length - 2; i >= 0; i--) {
        var temp = element.bottomPoints[i];
        if (bean.isCurve) {
          var lastElement = element.bottomPoints[i + 1];
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
        ..lineTo(element.topPoints.first.dx, element.topPoints.first.dy)
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
                  bean.sectionModel.fillColors ?? [defaultColor, defaultColor])
          .createShader(
              Rect.fromLTWH(_startX, _endY, _fixedWidth, _fixedHeight))
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    shadowPaths.forEach((sub) {
      canvas..drawPath(sub, shadowPaint);
    });

    ///先画阴影再画曲线
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = bean.sectionModel.borLineWidth ?? 1
      ..strokeCap = StrokeCap.round
      ..color = bean.sectionModel.lineSectionBorColor ?? defaultColor
      ..style = PaintingStyle.stroke;
    topPaths.forEach((path) {
      canvas.drawPath(
          bean.sectionModel.isBorLineImaginary
              ? dashPath(
                  path,
                  dashArray: CircularIntervalList<double>(<double>[5.0, 4.0]),
                )
              : path,
          paint);
    });
    bottomPaths.forEach((path) {
      canvas.drawPath(
          bean.sectionModel.isBorLineImaginary
              ? dashPath(
                  path,
                  dashArray: CircularIntervalList<double>(<double>[5.0, 4.0]),
                )
              : path,
          paint);
    });
  }

  ///曲线或折线
  void _drawLine(
      Canvas canvas,
      Size size,
      List<BeanDealModel> tempValueArr,
      List<ShadowSub> shadowPaths,
      List<PathModel> pathArr,
      List<PointModel> points,
      List<SpecialPointModel> specialPoints,
      FocusChartBeanMain bean) {
    if (tempValueArr.isEmpty || baseBean.yMax <= 0) return;
    shadowPaths.forEach((sub) {
      canvas
        ..drawPath(
            sub.focusPath,
            Paint()
              ..shader = sub.rectGradient
              ..isAntiAlias = true
              ..style = PaintingStyle.fill);
    });

    ///先画阴影再画曲线，目的是防止阴影覆盖曲线
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = bean.lineWidth
      ..strokeCap = StrokeCap.round
      ..color = bean.lineColor
      ..style = PaintingStyle.stroke;
    pathArr.forEach((pathModel) {
      canvas.drawPath(
          pathModel.isHintLineImaginary ?? false
              ? dashPath(
                  pathModel.path,
                  dashArray: CircularIntervalList<double>(<double>[5.0, 4.0]),
                )
              : pathModel.path,
          paint);
    });

    ///如果有点绘制需求，这里再绘制点位
    if (points != null && points.isNotEmpty) {
      var radius =
          pressedPointRadius > _xStepWidth ? _xStepWidth : pressedPointRadius;
      var pointPaint = Paint()
        ..isAntiAlias = true
        ..strokeWidth = radius / 2
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      points.forEach((model) {
        canvas.drawCircle(
            model.offset, radius / 2, pointPaint..color = model.color);
      });
    }

    ///如果有特殊点绘制需求，这里再绘制特殊点
    if (specialPoints != null && specialPoints.isNotEmpty) {
      specialPoints.forEach((element) {
        PainterTool.drawSpecialPointHintLine(
            canvas, element, _startX, _endX, _startY, _endY);
      });
    }
  }

  TouchModel getNearbyPoint(Offset localPosition) {
    var pointer = localPosition;
    var poinArr = _points.keys.toList();
    poinArr.sort((num1, num2) => num1 - num2 > 0 ? 1 : -1);

    ///默认第一个
    var touchModel;
    if (localPosition == null) {
      touchModel = _points[poinArr.first];
    } else {
      ///修复x轴越界
      if (pointer.dx < poinArr.first) {
        touchModel = _points[poinArr.first];
      } else if (pointer.dx > poinArr.last) {
        touchModel = _points[poinArr.last];
      } else {
        for (var i = 0; i < poinArr.length - 1; i++) {
          var currentX = poinArr[i];
          var nextX = poinArr[i + 1];
          if (pointer.dx >= currentX && pointer.dx < nextX) {
            var speaceWidth = nextX - currentX;
            if (pointer.dx <= currentX + speaceWidth / 2) {
              touchModel = _points[currentX];
            } else {
              touchModel = _points[nextX];
            }
            break;
          }
        }
      }
    }
    return touchModel;
  }
}
