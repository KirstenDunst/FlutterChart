import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/bean/chart_bean_focus.dart';
import 'package:path_drawing/path_drawing.dart';
import 'base_painter.dart';

class ChartLineFocusPainter extends BasePainter {
  List<ChartBeanFocus> chartBeans;
  bool isLinkBreak; //beans的时间轴如果断开，true： 是继续上一个有数值的值绘制，还是 false：断开。按照多条绘制
  Color xyColor; //xy轴的颜色
  double basePadding; //默认的边距16
  static const double overPadding = 0; //多出最大的极值额外的线长
  bool isShowHintX, isShowHintY; //x、y轴的辅助线
  Color hintLineColor;
  bool isHintLineImaginary; //辅助线是否为虚线
  Color lineColor; //曲线或折线的颜色
  double lineWidth; //绘制的线宽
  double startX, endX, startY, endY;
  double fixedHeight, fixedWidth; //坐标可容纳的宽高
  List<DialStyle> xDialValues; //x轴刻度显示，不传则没有
  CenterSubTitlePosition centerSubTitlePosition; //解释文案的显示与否即位置
  List<DialStyle> yDialValues; //y轴左侧刻度显示，不传则没有
  int xMax; //x轴最大值（以秒为单位）
  double yMax; //y轴最大值
  List<Color> gradualColors; //渐变颜色。不设置的话默认按照解释文案的分层显示，如果设置，即为整体颜色渐变显示

  List<ShadowSub> shadowPaths = []; //小区域渐变色显示操作
  List<Path> pathArr = []; //线条数组
  VoidCallback canvasEnd;
  //y轴显示数据，如果index值为null表示这里断开
  List<double> valueArr = [];

  static const Color defaultColor = Colors.deepPurple;

  ChartLineFocusPainter(
    this.chartBeans,
    this.isLinkBreak,
    this.lineColor, {
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
    startX = basePadding * 2.5;
    // yNum > 0 ? basePadding * 2.5 : basePadding * 2; //预留出y轴刻度值所占的空间
    endX = size.width - basePadding * 2;
    startY = size.height - basePadding * 3;
    endY = basePadding * 2;
    fixedHeight = startY - endY;
    fixedWidth = endX - startX;
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
        Offset(startX, startY), Offset(endX + overPadding, startY), paint); //x轴
    canvas.drawLine(
        Offset(startX, startY), Offset(startX, endY - overPadding), paint); //y轴

    drawRuler(canvas, paint); //刻度
  }

  ///x,y轴刻度 & 辅助线
  void drawRuler(Canvas canvas, Paint paint) {
    for (int i = 0; i < xDialValues.length; i++) {
      var tempXDigalModel = xDialValues[i];
      double dw = 0;
      if (tempXDigalModel.positionRetioy != null) {
        dw = fixedWidth * tempXDigalModel.positionRetioy;//两个点之间的x方向距离
      }

      ///绘制x轴文本
      TextPainter(
          textAlign: TextAlign.center,
          ellipsis: '.',
          text: TextSpan(
              text: tempXDigalModel.title, style: tempXDigalModel.titleStyle),
          textDirection: TextDirection.ltr)
        ..layout(minWidth: 40, maxWidth: 40)
        ..paint(canvas, Offset(startX + dw - 20, startY + basePadding));

      if (isShowHintY && i != 0) {
        //y轴辅助线
        Path hitYPath = Path();
        hitYPath
          ..moveTo(startX + dw, startY)
          ..lineTo(startX + dw, endY - overPadding);
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
    double xSub = startX - 40;
    double subWidth = 40;
    int maxLength = 1;
    TextDirection textDirection = TextDirection.rtl;
    switch (centerSubTitlePosition) {
      case CenterSubTitlePosition.None:
        isShowSub = false;
        break;
      case CenterSubTitlePosition.Right:
        xSub = endX + 8;
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
      var yLength = tempYModel.positionRetioy * fixedHeight;
      TextPainter(
          textAlign: TextAlign.right,
          ellipsis: '.',
          maxLines: 1,
          text: TextSpan(text: '$yValue', style: tempYModel.titleStyle),
          textDirection: TextDirection.rtl)
        ..layout(minWidth: 30, maxWidth: 30)
        ..paint(
            canvas,
            Offset(startX - 40,
                startY - yLength - tempYModel.titleStyle.fontSize / 2));
      if (isShowSub) {
        var subLength = (yDialValues[i].titleValue -
                (i == yDialValues.length-1 ? 0 : yDialValues[i+1].titleValue)) /
            2 /
            yMax *
            fixedHeight;
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
            Offset(xSub, startY - yLength + subLength.abs() - tp.height / 2));
      }

      if (isShowHintX && yLength != 0) {
        //x轴辅助线
        Path hitXPath = Path();
        hitXPath
          ..moveTo(startX, startY - yLength)
          ..lineTo(endX + overPadding, startY - yLength);
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
    valueArr.clear();
    if (chartBeans == null || chartBeans.length == 0) {
      return;
    }
    int indexValue = chartBeans.first.second;
    int index = 0;
    for (var i = 0; i < chartBeans.last.second; i++) {
      if (i == indexValue) {
        valueArr.add(chartBeans[index].focus);
        indexValue = chartBeans[index + 1].second;
        index++;
      } else {
        if (!isLinkBreak) {
          valueArr.add(chartBeans[index].focus);
        } else {
          valueArr.add(null);
        }
      }
    }
  }

  ///计算Path
  void _calculatePath(Size size) {
    if (valueArr.length > 0) {
      shadowPaths.clear();
      pathArr.clear();
      double preX, preY, currentX = startX, currentY, oldX = startX;
      Path oldShadowPath = Path();
      Path path = Path();

      //折线轨迹,每个元素都是1秒的存在期
      double W = (1 / xMax) * fixedWidth; //x轴距离
      //用来控制中间过度线条的大小。
      double gradualStep = W / 4;
      double stepBegainX = startX;
      for (int i = 0; i < valueArr.length; i++) {
        if (valueArr[i] != null) {
          if (i == 0 || (i > 0 && (valueArr[i - 1] == null))) {
            //初始化新起点
            Path newPath = Path();
            path = newPath;
            var value = (startY - valueArr[i] / yMax * fixedHeight);
            path.moveTo(currentX, value);
            Path shadowPath = new Path();
            shadowPath.moveTo(currentX, startY);
            shadowPath.lineTo(currentX - gradualStep, value);
            shadowPath.lineTo(currentX - gradualStep, value);
            oldShadowPath = shadowPath;
            stepBegainX = currentX;
          }

          if (i > 0 && (valueArr[i] != null && valueArr[i - 1] != null)) {
            preX = oldX;
            preY = (startY - valueArr[i - 1] / yMax * fixedHeight);
            currentY = (startY - valueArr[i] / yMax * fixedHeight);

            //曲线连接轨迹
            path.cubicTo((preX + currentX) / 2, preY, (preX + currentX) / 2,
                currentY, currentX, currentY);
            //直线连接轨迹
            // path.lineTo(currentX, currentY);

            //阴影轨迹(如果渐变色已经设定的话也走一次性绘制)
            if (isSamePhase(valueArr[i - 1], valueArr[i]) ||
                gradualColors != null) {
              oldShadowPath.cubicTo(
                  (preX + currentX) / 2,
                  preY,
                  (preX + currentX) / 2,
                  currentY,
                  currentX - gradualStep,
                  currentY);
              oldShadowPath.lineTo(currentX + gradualStep, currentY);
            } else {
              Path shadowPath = new Path();
              if (valueArr[i - 1] > valueArr[i]) {
                oldShadowPath.cubicTo(
                    (preX + currentX) / 2,
                    preY,
                    (preX + currentX) / 2,
                    currentY,
                    currentX - gradualStep,
                    currentY);
                oldShadowPath
                  ..lineTo(currentX - gradualStep, startY)
                  ..lineTo(stepBegainX, startY)
                  ..close();

                shadowPath.moveTo(currentX, startY);
                shadowPath.lineTo(currentX - gradualStep, startY);
                shadowPath.lineTo(currentX - gradualStep, currentY);
              } else {
                oldShadowPath
                  ..lineTo(preX + gradualStep, startY)
                  ..lineTo(stepBegainX, startY)
                  ..close();

                shadowPath.moveTo(currentX, startY);
                shadowPath.lineTo(preX + gradualStep, startY);
                shadowPath.lineTo(preX + gradualStep, preY);
                shadowPath.cubicTo(
                    (preX + currentX) / 2,
                    preY,
                    (preX + currentX) / 2,
                    currentY,
                    currentX - gradualStep,
                    currentY);
              }
              shadowPath.lineTo(currentX + gradualStep, currentY);
              shadowPaths.add(new ShadowSub(
                  focusPath: oldShadowPath,
                  rectGradient: _shader(i - 1, stepBegainX, currentX)));
              oldShadowPath = shadowPath;
              stepBegainX = currentX;
            }
          }

          if ((i < (valueArr.length - 1) && valueArr[i + 1] == null) ||
              (i == valueArr.length - 1)) {
            //结束点
            pathArr.add(path);
            oldShadowPath
              ..lineTo(currentX + gradualStep, startY)
              ..lineTo(stepBegainX, startY)
              ..close();
            shadowPaths.add(new ShadowSub(
                focusPath: oldShadowPath,
                rectGradient: _shader(i, stepBegainX, currentX)));
            path = null;
            oldShadowPath = null;
          }
        }

        if (currentX > (fixedWidth + startX)) {
          // 绘制结束
          if (path != null && oldShadowPath != null) {
            pathArr.add(path);
            oldShadowPath
              ..lineTo(currentX + gradualStep, startY)
              ..lineTo(stepBegainX, startY)
              ..close();
            shadowPaths.add(new ShadowSub(
                focusPath: oldShadowPath,
                rectGradient: _shader(i, stepBegainX, currentX)));
            path = null;
            oldShadowPath = null;
          }
          this.canvasEnd();
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
      return fixedHeight;
    }
    double extremum = 0;
    for (var i = 0; i < yDialValues.length - 1; i++) {
      if (value > yDialValues[i].titleValue &&
          value < yDialValues[i + 1].titleValue) {
        extremum = yDialValues[i + 1].titleValue / yMax * fixedHeight;
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
    double height = startY - getExtremum(valueArr[index]);
    //属于该专注力的固定小方块
    Rect rectFocus = Rect.fromLTRB(preX, height, currentX, startY);
    return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.mirror,
            colors: getGradualColor(valueArr[index]))
        .createShader(rectFocus);
  }

  ///曲线或折线
  void _drawLine(Canvas canvas, Size size) {
    if (valueArr.length == 0 || yMax <= 0) return;
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
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round
      ..color = lineColor
      ..style = PaintingStyle.stroke;
    pathArr.forEach((path) {
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
