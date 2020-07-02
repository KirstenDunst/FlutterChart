import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/bean/chart_bean_focus.dart';
import 'package:path_drawing/path_drawing.dart';
import 'base_painter.dart';

class ChartLineFocusPainter extends BasePainter {
  List<ChartBeanFocus> chartBeans;
  //双曲线，比对的beans
  List<ChartBeanFocus> contrastChartBeans;
  //双曲线，对比线条的颜色
  Color contrastLineColor;
  //双曲线，对比的数据在用户当前位置的头像显示
  Widget centerContrastPoint;
  //用户进行位置的头像显示
  Widget centerPoint;
  bool isLinkBreak; //beans的时间轴如果断开，true： 是继续上一个有数值的值绘制，还是 false：断开。按照多条绘制
  Color xyColor; //xy轴的颜色
  double basePadding; //默认的边距16
  static const double overPadding = 0; //多出最大的极值额外的线长
  bool isShowHintX, isShowHintY; //x、y轴的辅助线
  Color hintLineColor;
  bool isHintLineImaginary; //辅助线是否为虚线
  Color lineColor; //曲线或折线的颜色
  double lineWidth; //绘制的线宽
  List<DialStyle> xDialValues; //x轴刻度显示，不传则没有
  CenterSubTitlePosition centerSubTitlePosition; //解释文案的显示与否及位置
  List<DialStyle> yDialValues; //y轴左侧刻度显示，不传则没有
  int xMax; //x轴最大值（以秒为单位）
  double yMax; //y轴最大值
  List<Color> gradualColors; //渐变颜色。不设置的话默认按照解释文案的分层显示，如果设置，即为整体颜色渐变显示
  VoidCallback canvasEnd; //结束回调

  double _startX, _endX, _startY, _endY;
  double _fixedHeight, _fixedWidth; //坐标可容纳的宽高
  List<ShadowSub> _shadowPaths = []; //小区域渐变色显示操作
  List<Path> _pathArr = []; //线条数组
  //y轴显示数据，如果index值为null表示这里断开
  List<double> _valueArr = [];

  static const Color defaultColor = Colors.deepPurple;

  ChartLineFocusPainter(
    this.chartBeans,
    this.isLinkBreak,
    this.lineColor, {
    this.contrastChartBeans,
    this.contrastLineColor,
    this.centerPoint,
    this.centerContrastPoint,
    this.isShowHintX = false,
    this.isShowHintY = false,
    this.xyColor = defaultColor,
    this.lineWidth = 4,
    this.canvasEnd,
    this.xDialValues,
    this.centerSubTitlePosition = CenterSubTitlePosition.None,
    this.yDialValues,
    this.yMax,
    this.xMax,
    this.gradualColors,
    this.isHintLineImaginary,
    this.hintLineColor,
    this.basePadding,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _init(size);
    _drawXy(canvas, size); //坐标轴
    _dealValue(); //处理数据
    _calculatePath(size);
    _drawLine(canvas, size); //曲线或折线
  }

  @override
  bool shouldRepaint(ChartLineFocusPainter oldDelegate) {
    return true;
  }

  ///初始化
  void _init(Size size) {
    initValue();
    initBorder(size);
  }

  void initValue() {
    if (xyColor == null) {
      xyColor = defaultColor;
    }
    if (hintLineColor == null) {
      hintLineColor = defaultColor;
    }
    if (basePadding == null) {
      basePadding = 16;
    }
  }

  ///计算边界
  void initBorder(Size size) {
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

    canvas.drawLine(
        Offset(_startX, _startY), Offset(_endX + overPadding, _startY), paint); //x轴
    canvas.drawLine(
        Offset(_startX, _startY), Offset(_startX, _endY - overPadding), paint); //y轴

    drawRuler(canvas, paint); //刻度
  }

  ///x,y轴刻度 & 辅助线
  void drawRuler(Canvas canvas, Paint paint) {
    for (int i = 0; i < xDialValues.length; i++) {
      var tempXDigalModel = xDialValues[i];
      double dw = 0;
      if (tempXDigalModel.positionRetioy != null) {
        dw = _fixedWidth * tempXDigalModel.positionRetioy; //两个点之间的x方向距离
      }

      ///绘制x轴文本
      TextPainter(
          textAlign: TextAlign.center,
          ellipsis: '.',
          text: TextSpan(
              text: tempXDigalModel.title, style: tempXDigalModel.titleStyle),
          textDirection: TextDirection.ltr)
        ..layout(minWidth: 40, maxWidth: 40)
        ..paint(canvas, Offset(_startX + dw - 20, _startY + basePadding));

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
    bool isShowSub = true;
    double xSub = _startX - 40;
    double subWidth = 40;
    int maxLength = 1;
    TextDirection textDirection = TextDirection.rtl;
    switch (centerSubTitlePosition) {
      case CenterSubTitlePosition.None:
        isShowSub = false;
        break;
      case CenterSubTitlePosition.Right:
        xSub = _endX + 8;
        subWidth = 11;
        maxLength = 2;
        textDirection = TextDirection.ltr;
        break;
      default:
    }
    for (int i = 0; i < yDialValues.length; i++) {
      var tempYModel = yDialValues[i];

      ///绘制y轴文本
      var yValue = tempYModel.title;
      var yLength = tempYModel.positionRetioy * _fixedHeight;
      TextPainter(
          textAlign: TextAlign.right,
          ellipsis: '.',
          maxLines: 1,
          text: TextSpan(text: '$yValue', style: tempYModel.titleStyle),
          textDirection: TextDirection.rtl)
        ..layout(minWidth: 30, maxWidth: 30)
        ..paint(
            canvas,
            Offset(_startX - 40,
                _startY - yLength - tempYModel.titleStyle.fontSize / 2));
      if (isShowSub) {
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
            maxLines: maxLength,
            text: TextSpan(
                text: tempYModel.centerSubTitle,
                style: tempYModel.centerSubTextStyle),
            textDirection: textDirection)
          ..layout(minWidth: subWidth, maxWidth: subWidth);
        tp.paint(canvas,
            Offset(xSub, _startY - yLength + subLength.abs() - tp.height / 2));
      }

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

  void _dealValue() {
    _valueArr.clear();
    if (chartBeans == null || chartBeans.length == 0) {
      return;
    }
    int indexValue = chartBeans.first.second;
    int index = 0;
    for (var i = 0; i < chartBeans.last.second; i++) {
      if (i == indexValue) {
        _valueArr.add(chartBeans[index].focus);
        indexValue = chartBeans[index + 1].second;
        index++;
      } else {
        if (!isLinkBreak) {
          _valueArr.add(chartBeans[index].focus);
        } else {
          _valueArr.add(null);
        }
      }
    }
  }

  ///计算Path
  void _calculatePath(Size size) {
    if (_valueArr.length > 0) {
      _shadowPaths.clear();
      _pathArr.clear();
      double preX, preY, currentX = _startX, currentY, oldX = _startX;
      Path oldShadowPath = Path();
      Path path = Path();

      //折线轨迹,每个元素都是1秒的存在期
      double W = (1 / xMax) * _fixedWidth; //x轴距离
      //用来控制中间过度线条的大小。
      double gradualStep = W / 4;
      double stepBegainX = _startX;
      for (int i = 0; i < _valueArr.length; i++) {
        if (_valueArr[i] != null) {
          if (i == 0 || (i > 0 && (_valueArr[i - 1] == null))) {
            //初始化新起点
            Path newPath = Path();
            path = newPath;
            var value = (_startY - _valueArr[i] / yMax * _fixedHeight);
            path.moveTo(currentX, value);
            Path shadowPath = new Path();
            shadowPath.moveTo(currentX, _startY);
            shadowPath.lineTo(currentX, value);
            oldShadowPath = shadowPath;
            stepBegainX = currentX;
          }

          if (i > 0 && (_valueArr[i] != null && _valueArr[i - 1] != null)) {
            preX = oldX;
            preY = (_startY - _valueArr[i - 1] / yMax * _fixedHeight);
            currentY = (_startY - _valueArr[i] / yMax * _fixedHeight);

            //曲线连接轨迹
            path.cubicTo((preX + currentX) / 2, preY, (preX + currentX) / 2,
                currentY, currentX, currentY);
            //直线连接轨迹
            // path.lineTo(currentX, currentY);

            //阴影轨迹(如果渐变色已经设定的话也走一次性绘制)
            if (isSamePhase(_valueArr[i - 1], _valueArr[i]) ||
                gradualColors != null) {
              oldShadowPath.cubicTo(
                  (preX + currentX) / 2,
                  preY,
                  (preX + currentX) / 2,
                  currentY,
                  currentX - gradualStep,
                  currentY);
              double tempX = (currentX + gradualStep) < _endX
                  ? (currentX + gradualStep)
                  : _endX;
              oldShadowPath.lineTo(tempX, currentY);
            } else {
              Path shadowPath = new Path();
              if (_valueArr[i - 1] > _valueArr[i]) {
                oldShadowPath.cubicTo(
                    (preX + currentX) / 2,
                    preY,
                    (preX + currentX) / 2,
                    currentY,
                    currentX - gradualStep,
                    currentY);
                oldShadowPath
                  ..lineTo(currentX - gradualStep, _startY)
                  ..lineTo(stepBegainX, _startY)
                  ..close();

                shadowPath.moveTo(currentX, _startY);
                shadowPath.lineTo(currentX - gradualStep, _startY);
                shadowPath.lineTo(currentX - gradualStep, currentY);
              } else {
                oldShadowPath
                  ..lineTo(preX + gradualStep, _startY)
                  ..lineTo(stepBegainX, _startY)
                  ..close();

                shadowPath.moveTo(currentX, _startY);
                shadowPath.lineTo(preX + gradualStep, _startY);
                shadowPath.lineTo(preX + gradualStep, preY);
                shadowPath.cubicTo(
                    (preX + currentX) / 2,
                    preY,
                    (preX + currentX) / 2,
                    currentY,
                    currentX - gradualStep,
                    currentY);
              }
              double tempX = (currentX + gradualStep) < _endX
                  ? (currentX + gradualStep)
                  : _endX;
              shadowPath.lineTo(tempX, currentY);
              _shadowPaths.add(new ShadowSub(
                  focusPath: oldShadowPath,
                  rectGradient: _shader(i - 1, stepBegainX, currentX)));
              oldShadowPath = shadowPath;
              stepBegainX = currentX;
            }
          }

          if ((i < (_valueArr.length - 1) && _valueArr[i + 1] == null) ||
              (i == _valueArr.length - 1)) {
            //结束点
            _pathArr.add(path);
            oldShadowPath
              ..lineTo(currentX + gradualStep, _startY)
              ..lineTo(stepBegainX, _startY)
              ..close();
            _shadowPaths.add(new ShadowSub(
                focusPath: oldShadowPath,
                rectGradient: _shader(i, stepBegainX, currentX)));
            path = null;
            oldShadowPath = null;
          }
        }

        if (currentX + gradualStep > (_fixedWidth + _startX)) {
          // 绘制结束
          if (path != null && oldShadowPath != null) {
            _pathArr.add(path);
            oldShadowPath
              ..lineTo(_fixedWidth + _startX, _startY)
              ..lineTo(stepBegainX, _startY)
              ..close();
            _shadowPaths.add(new ShadowSub(
                focusPath: oldShadowPath,
                rectGradient: _shader(i, stepBegainX, currentX)));
            path = null;
            oldShadowPath = null;
          }
          if (this.canvasEnd != null) {
            this.canvasEnd();
          }
          return;
        }
        oldX = currentX;
        currentX += W;
      }
    }
  }

  bool isSamePhase(double one, double other) {
    bool same = false;
    for (var i = 0; i < yDialValues.length - 1; i++) {
      if (one > yDialValues[i].titleValue &&
          one < yDialValues[i + 1].titleValue) {
        same = (other > yDialValues[i].titleValue &&
            other < yDialValues[i + 1].titleValue);
      }
    }
    return same;
  }

  double getExtremum(double value) {
    if (gradualColors != null) {
      return _fixedHeight;
    }
    double extremum = 0;
    for (var i = 0; i < yDialValues.length - 1; i++) {
      if (value > yDialValues[i].titleValue &&
          value < yDialValues[i + 1].titleValue) {
        extremum = yDialValues[i + 1].titleValue / yMax * _fixedHeight;
      }
    }
    return extremum;
  }

  List<Color> getGradualColor(double value) {
    if (gradualColors != null) {
      return gradualColors;
    }
    Color mainColor = defaultColor;
    for (var i = 0; i < yDialValues.length - 1; i++) {
      if (value > yDialValues[i].titleValue &&
          value < yDialValues[i + 1].titleValue) {
        mainColor = yDialValues[i + 1].centerSubTextStyle.color;
      }
    }
    return [mainColor, mainColor.withOpacity(0.3)];
  }

  Shader _shader(int index, double preX, double currentX) {
    double height = _startY - getExtremum(_valueArr[index]);
    //属于该专注力的固定小方块
    Rect rectFocus = Rect.fromLTRB(preX, height, currentX, _startY);
    return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.mirror,
            colors: getGradualColor(_valueArr[index]))
        .createShader(rectFocus);
  }

  ///曲线或折线
  void _drawLine(Canvas canvas, Size size) {
    if (_valueArr.length == 0 || yMax <= 0) return;
    _shadowPaths.forEach((sub) {
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
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round
      ..color = lineColor
      ..style = PaintingStyle.stroke;
    _pathArr.forEach((path) {
      canvas.drawPath(path, paint);
    });
  }
}

class ShadowSub {
  //标准小专注矩形
  Path focusPath;
  //矩形的渐变色
  Shader rectGradient;

  ShadowSub({this.focusPath, this.rectGradient});
}
