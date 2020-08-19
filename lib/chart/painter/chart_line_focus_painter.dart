import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/bean/chart_bean_focus.dart';
import 'package:path_drawing/path_drawing.dart';
import 'base_painter.dart';

class ChartLineFocusPainter extends BasePainter {
  List<FocusChartBeanMain> focusChartBeans;
  Color xyColor = defaultColor; //xy轴的颜色
  List<DialStyle> xDialValues; //x轴刻度显示，不传则没有
  List<DialStyle> yDialValues; //y轴左侧刻度显示，不传则没有
  bool isLeftYDialSub = true; //y轴显示副刻度是在左侧还是在右侧，默认左侧
  List<SectionBean> xSectionBeans; //x轴的区间带（不用的话不用设置）
  int xMax = 60; //x轴最大值（以秒为单位）
  double yMax = 100; //y轴最大值
  double basePadding = 16; //默认的边距16

  bool isShowHintX = false, isShowHintY = false; //x、y轴的辅助线
  Color hintLineColor = defaultColor; //辅助线颜色
  bool isHintLineImaginary = false; //辅助线是否为虚线

  double _startX, _endX, _startY, _endY;
  double _fixedHeight, _fixedWidth; //坐标可容纳的宽高
  //y轴分布数值是否是正序，即小的在前大的在后
  bool _isPositiveSequence;

  static const double overPadding = 0; //多出最大的极值额外的线长
  static const Color defaultColor = Colors.deepPurple; //默认颜色

  ChartLineFocusPainter(
    this.focusChartBeans, {
    this.xyColor,
    this.xDialValues,
    this.yDialValues,
    this.isLeftYDialSub,
    this.xSectionBeans,
    this.yMax,
    this.xMax,
    this.basePadding,
    this.isShowHintX,
    this.isShowHintY,
    this.hintLineColor,
    this.isHintLineImaginary,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _init(size);
    _drawXy(canvas, size); //坐标轴

    for (FocusChartBeanMain bean in focusChartBeans) {
      //y轴显示数据，如果index值为null表示这里断开
      List<double> valueArr = [];
      //处理数据
      _dealValue(valueArr, bean.chartBeans, bean.isLinkBreak);
      _calculatePath(size, valueArr, bean, canvas);
    }

    //绘制区间带
    if (xSectionBeans != null && xSectionBeans.length > 0) {
      _drawIntervalSegmentation(canvas);
    }
  }

  @override
  bool shouldRepaint(ChartLineFocusPainter oldDelegate) {
    return true;
  }

  ///初始化
  void _init(Size size) {
    if (xyColor == null) {
      xyColor = defaultColor;
    }
    if (hintLineColor == null) {
      hintLineColor = defaultColor;
    }
    if (basePadding == null) {
      basePadding = 16;
    }
    _isPositiveSequence = true;
    try {
      _isPositiveSequence =
          yDialValues.first.titleValue < yDialValues.last.titleValue;
    } catch (e) {}
    _initBorder(size);
  }

  ///计算边界
  void _initBorder(Size size) {
    _startX = basePadding * 2.5;
    // yNum > 0 ? basePadding * 2.5 : basePadding * 2; //预留出y轴刻度值所占的空间
    _endX = size.width - basePadding * 2;
    _startY = size.height - basePadding * 3;
    _endY = basePadding * 2;
    _fixedHeight = _startY - _endY;
    _fixedWidth = _endX - _startX;
  }

  ///x,y轴
  void _drawXy(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..color = xyColor
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(_startX, _startY),
        Offset(_endX + overPadding, _startY), paint); //x轴
    canvas.drawLine(Offset(_startX, _startY),
        Offset(_startX, _endY - overPadding), paint); //y轴

    _drawRuler(canvas, paint); //刻度
  }

  ///x,y轴刻度 & 辅助线
  void _drawRuler(Canvas canvas, Paint paint) {
    for (int i = 0; i < xDialValues.length; i++) {
      var tempXDigalModel = xDialValues[i];
      double dw = 0;
      if (tempXDigalModel.positionRetioy != null) {
        dw = _fixedWidth * tempXDigalModel.positionRetioy; //两个点之间的x方向距离
      }

      ///绘制x轴文本
      TextPainter tpx = TextPainter(
          textAlign: TextAlign.center,
          ellipsis: '.',
          text: TextSpan(
              text: tempXDigalModel.title, style: tempXDigalModel.titleStyle),
          textDirection: TextDirection.ltr)
        ..layout();
      tpx.paint(
          canvas, Offset(_startX + dw - tpx.width / 2, _startY + basePadding));

      if (isShowHintY && i != 0) {
        //y轴辅助线
        Path hitYPath = Path();
        hitYPath
          ..moveTo(_startX + dw, _startY)
          ..lineTo(_startX + dw, _endY - overPadding);
        if (isHintLineImaginary) {
          canvas.drawPath(
            dashPath(
              hitYPath,
              dashArray: CircularIntervalList<double>(<double>[5.0, 4.0]),
            ),
            paint..color = hintLineColor,
          );
        } else {
          canvas.drawPath(hitYPath, paint..color = hintLineColor);
        }
      }
      // ///x轴刻度
      // canvas.drawLine(Offset(startX + dw, startY),
      //     Offset(startX + dw, startY - rulerWidth), paint..color = xyColor);
    }

    for (int i = 0; i < yDialValues.length; i++) {
      var tempYModel = yDialValues[i];

      ///绘制y轴文本
      var yValue = tempYModel.title;
      var yLength = tempYModel.positionRetioy * _fixedHeight;
      TextPainter tpY = TextPainter(
          textAlign: TextAlign.right,
          ellipsis: '.',
          maxLines: 1,
          text: TextSpan(text: '$yValue', style: tempYModel.titleStyle),
          textDirection: TextDirection.rtl)
        ..layout();
      tpY.paint(canvas,
          Offset(_startX - 10 - tpY.width, _startY - yLength - tpY.height / 2));
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
          maxLines: 5,
          text: TextSpan(
              text: tempYModel.centerSubTitle,
              style: tempYModel.centerSubTextStyle),
          textDirection: TextDirection.ltr)
        ..layout();
      tp.paint(
          canvas,
          Offset(isLeftYDialSub ? (_startX - tp.width - 10) : (_endX + 8),
              _startY - yLength + subLength.abs() - tp.height / 2));

      if (isShowHintX && yLength != 0) {
        //x轴辅助线
        Path hitXPath = Path();
        hitXPath
          ..moveTo(_startX, _startY - yLength)
          ..lineTo(_endX + overPadding, _startY - yLength);
        if (isHintLineImaginary) {
          canvas.drawPath(
            dashPath(
              hitXPath,
              dashArray: CircularIntervalList<double>(<double>[5.0, 4.0]),
            ),
            paint..color = hintLineColor,
          );
        } else {
          canvas.drawPath(hitXPath, paint..color = hintLineColor);
        }
      }
      // ///y轴刻度
      // canvas.drawLine(Offset(startX, startY - yLength),
      //   Offset(startX + rulerWidth, startY - yLength), paint..color = xyColor);
    }
  }

  void _dealValue(List<double> tempValueArr, List<ChartBeanFocus> chartBeans,
      bool isLinkBreak) {
    if (chartBeans == null || chartBeans.length == 0) return;
    int indexValue = chartBeans.first.second;
    int index = 0;
    int endSecond = chartBeans.last.second;
    for (var i = 0; i < endSecond; i++) {
      if (i == indexValue) {
        tempValueArr.add(min(chartBeans[index].focus, yMax));
        indexValue = chartBeans[index + 1].second;
        index++;
      } else {
        if (!isLinkBreak) {
          tempValueArr.add(min(chartBeans[index].focus, yMax));
        } else {
          tempValueArr.add(null);
        }
      }
    }
  }

  ///计算Path
  void _calculatePath(Size size, List<double> tempValueArr,
      FocusChartBeanMain bean, Canvas canvas) {
    if (tempValueArr.length <= 0) return;
    double preX, preY, currentX = _startX, currentY, oldX = _startX;
    Path oldShadowPath = Path();
    Path path = Path();
    //最后一个点的位置，用来记录绘制头像的显示
    Point lastPoint = Point(0, 0);
    //小区域渐变色显示操作
    List<ShadowSub> shadowPaths = [];
    //线条数组
    List<Path> pathArr = [];

    //折线轨迹,每个元素都是1秒的存在期
    double W = (1 / xMax) * _fixedWidth; //x轴距离
    //用来控制中间过度线条的大小。
    double gradualStep = W / 4;
    double stepBegainX = _startX;
    for (int i = 0; i < tempValueArr.length; i++) {
      if (tempValueArr[i] != null) {
        currentY = (_startY - ((tempValueArr[i] / yMax) * _fixedHeight));
        if (i == 0 || (i > 0 && (tempValueArr[i - 1] == null))) {
          //初始化新起点
          Path newPath = Path();
          path = newPath;
          path.moveTo(currentX, currentY);
          lastPoint = Point(currentX, currentY);
          Path shadowPath = new Path();
          shadowPath.moveTo(currentX, _startY);
          shadowPath.lineTo(currentX, currentY);
          oldShadowPath = shadowPath;
          stepBegainX = currentX;
        }

        if (i > 0 && (tempValueArr[i] != null && tempValueArr[i - 1] != null)) {
          preX = oldX;
          preY = (_startY - tempValueArr[i - 1] / yMax * _fixedHeight);
          //曲线连接轨迹
          path.cubicTo((preX + currentX) / 2, preY, (preX + currentX) / 2,
              currentY, currentX, currentY);
          lastPoint = Point(currentX, currentY);
          //直线连接轨迹
          // path.lineTo(currentX, currentY);

          //阴影轨迹(如果渐变色已经设定的话也走一次性绘制)
          if (bean.gradualColors != null ||
              isSamePhase(tempValueArr[i - 1], tempValueArr[i])) {
            oldShadowPath.cubicTo((preX + currentX) / 2, preY,
                (preX + currentX) / 2, currentY, currentX, currentY);
          } else {
            oldShadowPath.lineTo(preX + gradualStep, preY);
            Path shadowPath = new Path();
            if (tempValueArr[i - 1] > tempValueArr[i]) {
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
            shadowPaths.add(new ShadowSub(
                focusPath: oldShadowPath,
                rectGradient: _shader(i - 1, stepBegainX, currentX,
                    tempValueArr, bean.gradualColors)));
            oldShadowPath = shadowPath;
            stepBegainX = currentX;
          }
        }

        if ((i < (tempValueArr.length - 1) && tempValueArr[i + 1] == null) ||
            (i == tempValueArr.length - 1)) {
          //结束点
          pathArr.add(path);
          bool isBeyond = (currentX + gradualStep) > _endX;
          double tempX = isBeyond ? _endX : (currentX + gradualStep);
          oldShadowPath
            ..lineTo(tempX, currentY)
            ..lineTo(tempX, _startY)
            ..lineTo(stepBegainX, _startY)
            ..close();
          shadowPaths.add(new ShadowSub(
              focusPath: oldShadowPath,
              rectGradient: _shader(
                  i, stepBegainX, currentX, tempValueArr, bean.gradualColors)));
          path = null;
          oldShadowPath = null;
        }
      }

      if ((currentX + gradualStep) > _endX) {
        // 绘制结束
        if (path != null && oldShadowPath != null) {
          pathArr.add(path);
          oldShadowPath
            ..lineTo(_endX, _startY)
            ..lineTo(stepBegainX, _startY)
            ..close();
          shadowPaths.add(new ShadowSub(
              focusPath: oldShadowPath,
              rectGradient: _shader(
                  i, stepBegainX, currentX, tempValueArr, bean.gradualColors)));
          path = null;
          oldShadowPath = null;
        }
        if (bean.canvasEnd != null) {
          bean.canvasEnd();
        }
        break;
      }
      oldX = currentX;
      currentX += W;
    }
    _drawLine(canvas, size, tempValueArr, shadowPaths, pathArr, bean,
        lastPoint); //曲线或折线
  }

  bool isSamePhase(double one, double other) {
    bool same = false;
    double oneExtrem = getExtremum(one, null);
    double otherExtrem = getExtremum(other, null);
    same = oneExtrem == otherExtrem;
    return same;
  }

  double getExtremum(double value, List<Color> gradualColors) {
    if (gradualColors != null) {
      return _fixedHeight;
    }
    double extremum = 0;
    if (_isPositiveSequence && value >= yDialValues.last.titleValue) {
      extremum = yDialValues.last.titleValue / yMax * _fixedHeight;
    } else if (!_isPositiveSequence && value >= yDialValues.first.titleValue) {
      extremum = yDialValues.first.titleValue / yMax * _fixedHeight;
    } else {
      for (var i = 0; i < yDialValues.length - 1; i++) {
        if (value > yDialValues[i].titleValue &&
            value <= yDialValues[i + 1].titleValue) {
          extremum = yDialValues[i + 1].titleValue / yMax * _fixedHeight;
        } else if (value <= yDialValues[i].titleValue &&
            value > yDialValues[i + 1].titleValue) {
          extremum = yDialValues[i].titleValue / yMax * _fixedHeight;
        }
      }
    }
    return extremum;
  }

  List<Color> getGradualColor(double value, List<Color> gradualColors) {
    if (gradualColors != null) {
      return gradualColors;
    }
    Color mainColor = defaultColor;
    if (_isPositiveSequence && value >= yDialValues.last.titleValue) {
      mainColor = yDialValues.last.centerSubTextStyle.color;
    } else if (!_isPositiveSequence && value >= yDialValues.first.titleValue) {
      mainColor = yDialValues.first.centerSubTextStyle.color;
    } else {
      for (var i = 0; i < yDialValues.length - 1; i++) {
        if (value <= yDialValues[i].titleValue &&
            value > yDialValues[i + 1].titleValue) {
          mainColor = yDialValues[i].centerSubTextStyle.color;
        } else if (value > yDialValues[i].titleValue &&
            value <= yDialValues[i + 1].titleValue) {
          mainColor = yDialValues[i + 1].centerSubTextStyle.color;
        }
      }
    }

    return [mainColor, mainColor.withOpacity(0.3)];
  }

  Shader _shader(int index, double preX, double currentX,
      List<double> tempValueArr, List<Color> gradualColors) {
    double height = _startY - getExtremum(tempValueArr[index], gradualColors);
    //属于该专注力的固定小方块
    Rect rectFocus = Rect.fromLTRB(preX, height, currentX, _startY);
    return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.mirror,
            colors: getGradualColor(tempValueArr[index], gradualColors))
        .createShader(rectFocus);
  }

  ///曲线或折线
  void _drawLine(
      Canvas canvas,
      Size size,
      List<double> tempValueArr,
      List<ShadowSub> shadowPaths,
      List<Path> pathArr,
      FocusChartBeanMain bean,
      Point lastPoint) {
    if (tempValueArr.length <= 0 || yMax <= 0) return;
    shadowPaths.forEach((sub) {
      canvas
        ..drawPath(
            sub.focusPath,
            new Paint()
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
    pathArr.forEach((path) {
      canvas.drawPath(path, paint);
    });

    if (bean.centerPoint != null) {
      // canvas.drawImageRect(bean.centerPoint, src, dst, paint)
      canvas.drawImage(bean.centerPoint,
          Offset(lastPoint.x - 10.0, lastPoint.y - 10.0), paint);
    }
  }

//绘制隔离带，暂时只有x轴，后面需要再扩展y轴
  void _drawIntervalSegmentation(Canvas canvas) {
    for (var item in xSectionBeans) {
      double tempStartX = _fixedWidth * item.startRatio + _startX;
      double tempWidth = _fixedWidth * item.widthRatio;
      Path tempPath = Path()
        ..moveTo(tempStartX, _endY)
        ..lineTo(tempStartX + tempWidth, _endY)
        ..lineTo(tempStartX + tempWidth, _startY)
        ..lineTo(tempStartX, _startY)
        ..lineTo(tempStartX, _endY)
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
      Path borderLinePath1 = Path()
        ..moveTo(tempStartX, _endY)
        ..lineTo(tempStartX, _startY);
      Path borderLinePath2 = Path()
        ..moveTo(tempStartX + tempWidth, _endY)
        ..lineTo(tempStartX + tempWidth, _startY);
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
      TextPainter tempText = TextPainter(
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
              _endY - tempText.height));
    }
  }
}

class ShadowSub {
  //标准小专注矩形
  Path focusPath;
  //矩形的渐变色
  Shader rectGradient;

  ShadowSub({this.focusPath, this.rectGradient});
}
