import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/bean/chart_pie_bean.dart';
import 'package:flutter_chart/chart/painter/base_painter.dart';

class ChartPiePainter extends BasePainter {
  double value; //当前动画值
  List<ChartPieBean> chartBeans;
  double R, centerR; //圆弧半径,中心圆半径
  Color centerColor; //中心圆颜色
  double divisionWidth; //各个占比之间的分割线宽度，默认为0即不显示分割
  AssistTextShowType assistTextShowType; //辅助性文案显示的样式
  static const double basePadding = 16; //默认的边距
  static const Color defaultColor = Colors.deepPurple;
  double startX, endX, startY, endY;
  double centerX, centerY; //圆心
  Color assistBGColor; //辅助性文案的背景框背景颜色
  int decimalDigits; //辅助性百分比显示的小数位数,（饼状图还是真实的比例）

  //角朝向，内部使用
  RowDirection lastRowDirection;
  //上一次绘制文案的最大距离,(角朝上的话为x的min，角朝下的话为x的max。以此角朝左右的为y的min，max，绘制是顺时针方向的)
  double lastXY;
  //y轴的最大值，对应用来上下角出现叠加的时候计算位置使用。
  double lastYOverlay;
  Paint assistPaint;

  ChartPiePainter(
    this.chartBeans, {
    this.value = 1,
    this.R,
    this.centerR = 0,
    this.divisionWidth = 0,
    this.centerColor = defaultColor,
    this.assistTextShowType = AssistTextShowType.None,
    this.assistBGColor = defaultColor,
    this.decimalDigits = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _init(size);
    _drawPie(canvas); //画圆弧
    if (divisionWidth > 0) {
      _drawRectSpeace(canvas); //画间隔线
    }
    _drawCenter(canvas); //画中心圆
  }

  @override
  bool shouldRepaint(ChartPiePainter oldDelegate) {
    return true;
    // oldDelegate.value != value;
  }

  //初始化
  _init(Size size) {
    startX = basePadding;
    endX = size.width - basePadding;
    startY = size.height - basePadding;
    endY = basePadding;

    centerX = startX + (endX - startX) / 2;
    centerY = endY + (startY - endY) / 2;
    double xR = endX - centerX;
    double yR = startY - centerY;
    double realR = xR.compareTo(yR) > 0 ? yR : xR;

    if (R == null || R == 0) {
      R = realR;
    } else {
      if (R > realR) R = realR;
    }
    if (centerR > R) centerR = R;
    lastRowDirection = RowDirection.Null;
    assistPaint = Paint()
      ..color = assistBGColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    _setPieAngle(); //计算角度
  }

  //辅助性文案的绘制区域
  bool needCenterAssist = false;
  _drawPie(Canvas canvas) {
    Paint paint = Paint()..isAntiAlias = true;
    var rect = Rect.fromCircle(center: Offset(centerX, centerY), radius: R);
    var realAngle = value * 2 * pi; //当前动画值对应的总角度
    isNeedEnterRedrawArr = false;
    fistTopLeftPoint = null;
    redrawArr.clear();
    yRedrawArrRowTop.clear();
    yRedrawArrRowBottom.clear();
    for (var i = 0; i < chartBeans.length; i++) {
      ChartPieBean bean = chartBeans[i];
      var targetAngle = bean.startAngle + bean.sweepAngle;
      paint..color = bean.color;
      if (targetAngle <= realAngle) {
        canvas.drawArc(rect, bean.startAngle, bean.sweepAngle, true, paint);
      } else if (bean.startAngle < realAngle) {
        double sweepAngle = realAngle - bean.startAngle;
        canvas.drawArc(rect, bean.startAngle, sweepAngle, true, paint);
      }
      if (needCenterAssist) {
        double centerRedin = bean.startAngle + bean.sweepAngle / 2;
        double centerSin = sin(centerRedin), centerCos = cos(centerRedin);
        _drawPerRatio(canvas, bean.assistText, bean.assistTextStyle, centerSin,
            centerCos, i);
      }
    }
    if (needCenterAssist) {
      //查看是否有重叠并进行重新排布，针对尾部和头部的偏移冲突进行重新布局
      _redrawShadowRect(canvas);
    }
  }

  //间隔
  void _drawRectSpeace(Canvas canvas) {
    for (var bean in chartBeans) {
      _drawSpeaceRect(canvas, bean.startAngle);
    }
  }

  void _drawSpeaceRect(Canvas canvas, double angle) {
    Paint speacePaint = Paint()
      ..color = centerColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = divisionWidth
      ..isAntiAlias = true;
    Point arcPoint = Point(centerX + R * cos(angle), centerY + R * sin(angle));
    canvas.drawLine(
        Offset(centerX, centerY), Offset(arcPoint.x, arcPoint.y), speacePaint);
  }

  void _redrawShadowRect(Canvas canvas) {
    if (redrawArr.length != 0 && fistTopLeftPoint != null) {
      RedrawModel model = redrawArr.last;
      if ((model.rectTopLeftPoint.y + model.textPainter.height) >
          fistTopLeftPoint.y) {
        double begainY = fistTopLeftPoint.y - speaceBetween;
        //反向重排并绘制
        for (var i = redrawArr.length - 1; i >= 0; i--) {
          RedrawModel tempModel = redrawArr[i];
          begainY -= tempModel.textPainter.height;
          if (begainY < tempModel.rectTopLeftPoint.y) {
            tempModel.rectTopLeftPoint =
                Point(tempModel.rectTopLeftPoint.x, begainY);
            tempModel.isAdjust = true;
          }
          begainY = tempModel.rectTopLeftPoint.y - speaceBetween;
        }
      }
    }

    //数组中的重绘
    for (var item in redrawArr) {
      _redrewAllleftRow(canvas, item.rowTopPoint, item.rectTopLeftPoint,
          item.textPainter, item.isAdjust);
    }
    //上下倒着绘制，防止尖角覆盖上一个的内容
    for (var i = yRedrawArrRowTop.length - 1; i >= 0; i--) {
      var item = yRedrawArrRowTop[i];
      _redrewAllTopRow(
          canvas, item.rowTopPoint, item.rectTopLeftPoint, item.textPainter);
    }
    for (var i = yRedrawArrRowBottom.length - 1; i >= 0; i--) {
      var item = yRedrawArrRowBottom[i];
      _redrewAllBottomRow(
          canvas, item.rowTopPoint, item.rectTopLeftPoint, item.textPainter);
    }
  }

  //可能需要重绘的数组
  List<RedrawModel> redrawArr = [];
  double rowHeiWidth = 5, speaseWidth = 10; //尖角高5，左右各多5像素
  //如果多个平行绘制的话，文本框之间的间距
  double speaceBetween = 2;
  //如果第一个是左角的话记录此位置，以便后面对比是否有重合,
  Point fistTopLeftPoint;
  //是否需要加入到重绘数组中，当绘制完其他的角之后即打开，再绘制左角就可加入数组
  bool isNeedEnterRedrawArr;

  //y轴重叠重绘数组
  List<RedrawModel> yRedrawArrRowTop = [];
  List<RedrawModel> yRedrawArrRowBottom = [];

  void _drawPerRatio(Canvas canvas, String title, TextStyle titleStyle,
      double centerSin, double centerCos, int index) {
    TextPainter tp = new TextPainter(
        textAlign: TextAlign.center,
        ellipsis: '.',
        maxLines: 1,
        text: TextSpan(text: title, style: titleStyle),
        textDirection: TextDirection.ltr)
      ..layout();

    double assistTextWidth = tp.width + speaseWidth;
    double assistTextHeight = tp.height;

    double rowYspeace = (R + 5) * centerSin;
    double rowXspeace = (R + 5) * centerCos;
    Point rowPoint = Point(centerX + rowXspeace, centerY + rowYspeace);

    //尖角的底部宽度默认设置5，
    double approachSpeace = 5;
    //阴影框的左上角起始点
    Point shadowLeftTopPoint;
    Paint paint = Paint()
      ..color = assistBGColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    Path path = Path()..moveTo(rowPoint.x, rowPoint.y);
    if (centerSin.abs() > centerCos.abs()) {
      //上下脚
      if (centerSin > 0) {
        isNeedEnterRedrawArr = true;
        //上角
        shadowLeftTopPoint =
            Point(rowPoint.x - assistTextWidth / 2, rowPoint.y + rowHeiWidth);
        if (lastRowDirection == RowDirection.Top) {
          if ((rowPoint.x + assistTextWidth / 2) > lastXY) {
            //有重叠
            shadowLeftTopPoint =
                Point(rowPoint.x - assistTextWidth/2, lastYOverlay);
          }
        } else {
          if (lastXY != null && (rowPoint.y + rowHeiWidth) < lastXY) {
            //跨域重叠，只存在左上角和右下角
            shadowLeftTopPoint = Point(rowPoint.x - assistTextWidth / 2,
                lastXY);
          }
        }
        //待比对点
        Point beforePoint = centerCos > 0
                ? Point(shadowLeftTopPoint.x,
                    shadowLeftTopPoint.y)
                : Point(shadowLeftTopPoint.x + assistTextWidth,
                    shadowLeftTopPoint.y);
        Point afterPoint = _pointToPointDistance(beforePoint);
        if (afterPoint.x != beforePoint.x || afterPoint.y != beforePoint.y) {
          shadowLeftTopPoint =
            Point(afterPoint.x-(centerCos > 0 ? 0 : assistTextWidth), afterPoint.y);
        }
        yRedrawArrRowTop.add(RedrawModel(
              rowTopPoint: rowPoint,
              rectTopLeftPoint: shadowLeftTopPoint,
              textPainter: tp));
        lastXY = shadowLeftTopPoint.x - speaceBetween;
        lastRowDirection = RowDirection.Top;
        lastYOverlay = shadowLeftTopPoint.y + tp.height + speaceBetween;
      } else {
        isNeedEnterRedrawArr = true;
        //下角
        shadowLeftTopPoint = Point(rowPoint.x - assistTextWidth / 2,
            rowPoint.y - rowHeiWidth - assistTextHeight);
        if (lastRowDirection == RowDirection.Bottom) {
          if ((rowPoint.x - assistTextWidth / 2) < lastXY) {
            //有重叠
            shadowLeftTopPoint = Point(rowPoint.x - assistTextWidth / 2,
                lastYOverlay - assistTextHeight);
          }
        } else {
          if (lastXY != null && (rowPoint.y - rowHeiWidth) > lastXY) {
            //跨域重叠，只存在左上角和右下角
            shadowLeftTopPoint = Point(rowPoint.x - assistTextWidth / 2,
                lastXY - assistTextHeight);
          }
        }
        //待比对点
        Point beforePoint = centerCos > 0
                ? Point(shadowLeftTopPoint.x,
                    shadowLeftTopPoint.y + assistTextHeight)
                : Point(shadowLeftTopPoint.x + assistTextWidth,
                    shadowLeftTopPoint.y + assistTextHeight);
        Point afterPoint = _pointToPointDistance(beforePoint);
        if (afterPoint.x != beforePoint.x || afterPoint.y != beforePoint.y) {
          shadowLeftTopPoint =
            Point(afterPoint.x-(centerCos > 0 ? 0 : assistTextWidth), afterPoint.y-assistTextHeight);
        }
        yRedrawArrRowBottom.add(RedrawModel(
              rowTopPoint: rowPoint,
              rectTopLeftPoint: shadowLeftTopPoint,
              textPainter: tp));
        lastXY = shadowLeftTopPoint.x + assistTextWidth + speaceBetween;
        lastRowDirection = RowDirection.Bottom;
        lastYOverlay = shadowLeftTopPoint.y - speaceBetween;
      }
    } else {
      //左右脚
      if (centerCos > 0) {
        //出左脚
        bool isAdject = false;
        shadowLeftTopPoint =
            Point(rowPoint.x + rowHeiWidth, rowPoint.y - assistTextHeight / 2);
        if (index == 0) {
          fistTopLeftPoint = shadowLeftTopPoint;
        }
        if (lastRowDirection == RowDirection.Left) {
          if ((rowPoint.y - assistTextHeight / 2) < lastXY) {
            //有重叠
            shadowLeftTopPoint = Point(rowPoint.x + rowHeiWidth, lastXY);
            approachSpeace = assistTextHeight / 2;
            isAdject = true;
          }
        }
        if (isNeedEnterRedrawArr) {
          redrawArr.add(RedrawModel(
              rowTopPoint: rowPoint,
              rectTopLeftPoint: shadowLeftTopPoint,
              textPainter: tp,
              isAdjust: isAdject));
        } else {
          _redrewAllleftRow(canvas, rowPoint, shadowLeftTopPoint, tp, isAdject);
        }

        lastXY = shadowLeftTopPoint.y + assistTextHeight + speaceBetween;
        lastRowDirection = RowDirection.Left;
      } else {
        isNeedEnterRedrawArr = true;
        //出右角
        shadowLeftTopPoint = Point(rowPoint.x - rowHeiWidth - assistTextWidth,
            rowPoint.y - assistTextHeight / 2);
        if (lastRowDirection == RowDirection.Right) {
          if ((rowPoint.y + assistTextHeight / 2) > lastXY) {
            //有重叠
            shadowLeftTopPoint = Point(
                rowPoint.x - rowHeiWidth - assistTextWidth,
                lastXY - assistTextHeight);
            approachSpeace = assistTextHeight / 2;
          }
        }
        path
          ..lineTo(shadowLeftTopPoint.x + assistTextWidth,
              shadowLeftTopPoint.y + assistTextHeight / 2 - approachSpeace / 2)
          ..lineTo(shadowLeftTopPoint.x + assistTextWidth, shadowLeftTopPoint.y)
          ..lineTo(shadowLeftTopPoint.x, shadowLeftTopPoint.y)
          ..lineTo(
              shadowLeftTopPoint.x, shadowLeftTopPoint.y + assistTextHeight)
          ..lineTo(shadowLeftTopPoint.x + assistTextWidth,
              shadowLeftTopPoint.y + assistTextHeight)
          ..lineTo(shadowLeftTopPoint.x + assistTextWidth,
              shadowLeftTopPoint.y + assistTextHeight / 2 + approachSpeace / 2);
        lastXY = shadowLeftTopPoint.y - speaceBetween;
        lastRowDirection = RowDirection.Right;

        path
          ..lineTo(rowPoint.x, rowPoint.y)
          ..close();
        canvas.drawPath(path, paint);
        tp.paint(
            canvas,
            Offset(
                shadowLeftTopPoint.x + speaseWidth / 2, shadowLeftTopPoint.y));
      }
    }
  }

  void _redrewAllBottomRow(
      Canvas canvas, Point point, Point begainLeftTopPoint, TextPainter tp) {
    Path path = Path()..moveTo(point.x, point.y);
    double assistTextWidth = tp.width + speaseWidth;
    double assistTextHeight = tp.height;
    //尖角的底部宽度默认设置5，
    double approachSpeace = 5;
    path
      ..lineTo(begainLeftTopPoint.x + assistTextWidth / 2 - approachSpeace / 2,
          begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(begainLeftTopPoint.x, begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(begainLeftTopPoint.x, begainLeftTopPoint.y)
      ..lineTo(begainLeftTopPoint.x + assistTextWidth, begainLeftTopPoint.y)
      ..lineTo(begainLeftTopPoint.x + assistTextWidth,
          begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(begainLeftTopPoint.x + assistTextWidth / 2 + approachSpeace / 2,
          begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(point.x, point.y)
      ..close();
    canvas.drawPath(path, assistPaint);
    tp.paint(canvas,
        Offset(begainLeftTopPoint.x + speaseWidth / 2, begainLeftTopPoint.y));
  }

  void _redrewAllTopRow(
      Canvas canvas, Point point, Point begainLeftTopPoint, TextPainter tp) {
    Path path = Path()..moveTo(point.x, point.y);
    double assistTextWidth = tp.width + speaseWidth;
    double assistTextHeight = tp.height;
    //尖角的底部宽度默认设置5，
    double approachSpeace = 5;
    path
      ..lineTo(begainLeftTopPoint.x + assistTextWidth / 2 - approachSpeace / 2,
          begainLeftTopPoint.y)
      ..lineTo(begainLeftTopPoint.x, begainLeftTopPoint.y)
      ..lineTo(begainLeftTopPoint.x, begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(begainLeftTopPoint.x + assistTextWidth,
          begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(begainLeftTopPoint.x + assistTextWidth, begainLeftTopPoint.y)
      ..lineTo(begainLeftTopPoint.x + assistTextWidth / 2 + approachSpeace / 2,
          begainLeftTopPoint.y)
      ..lineTo(point.x, point.y)
      ..close();
    canvas.drawPath(path, assistPaint);
    tp.paint(canvas,
        Offset(begainLeftTopPoint.x + speaseWidth / 2, begainLeftTopPoint.y));
  }

  void _redrewAllleftRow(Canvas canvas, Point point, Point begainLeftTopPoint,
      TextPainter tp, bool isAdjust) {
    Path path = Path()..moveTo(point.x, point.y);
    double assistTextWidth = tp.width + speaseWidth;
    double assistTextHeight = tp.height;
    //尖角的底部宽度默认设置5，
    double approachSpeace = isAdjust ? (tp.height / 2) : 5;
    path
      ..lineTo(begainLeftTopPoint.x,
          begainLeftTopPoint.y + assistTextHeight / 2 - approachSpeace / 2)
      ..lineTo(begainLeftTopPoint.x, begainLeftTopPoint.y)
      ..lineTo(begainLeftTopPoint.x + assistTextWidth, begainLeftTopPoint.y)
      ..lineTo(begainLeftTopPoint.x + assistTextWidth,
          begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(begainLeftTopPoint.x, begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(begainLeftTopPoint.x,
          begainLeftTopPoint.y + assistTextHeight / 2 + approachSpeace / 2)
      ..lineTo(point.x, point.y)
      ..close();
    canvas.drawPath(path, assistPaint);
    tp.paint(canvas,
        Offset(begainLeftTopPoint.x + speaseWidth / 2, begainLeftTopPoint.y));
  }

  //计算可能可能存在和饼状区域有交集的点与圆心的距离，返回：如果有交集返回应该扩展的高度，没有交集返回0
  Point _pointToPointDistance(
      Point point) {
    double xDistance = (point.x-centerX);
    double yDistance = (point.y-centerY);
    double quartXY = xDistance * xDistance + yDistance * yDistance;
    double speaceWidth = sqrt(quartXY);
    if (speaceWidth >= R) {
      return point;
    } else {
      return Point(centerX + (R+5)*xDistance/speaceWidth, centerY + (R+5)*yDistance/speaceWidth);
    }
  }

  void _drawCenter(Canvas canvas) {
    Paint paint = Paint()
      ..color = centerColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    canvas.drawCircle(Offset(centerX, centerY), centerR, paint);
  }

  ///计算各个扇形的起始角度
  _setPieAngle() {
    double total = _getTotal(chartBeans);
    double rate = 0;
    double startAngle = 0; // 扇形开始的角度 正上方
    for (var bean in chartBeans) {
      rate = bean.value / total; //当前对象值所占比例
      bean.rate = rate;
      switch (assistTextShowType) {
        case AssistTextShowType.CenterOnlyPercentage:
          needCenterAssist = true;
          bean.assistText = (rate * 100).toStringAsFixed(decimalDigits);
          break;
        case AssistTextShowType.CenterNamePercentage:
          needCenterAssist = true;
          String percentStr = (rate * 100).toStringAsFixed(decimalDigits);
          bean.assistText = '$percentStr%${bean.type}';
          break;
        default:
      }
      bean.startAngle = startAngle;
      bean.sweepAngle = rate * 2 * pi; //当前对象所占比例 对应的 角度
      startAngle += bean.sweepAngle;
    }
  }

  ///计算数据总和
  _getTotal(List<ChartPieBean> data) {
    double total = 0;
    for (var bean in data) {
      total += bean.value;
    }
    return total;
  }
}

class RedrawModel {
  Point rowTopPoint;
  Point rectTopLeftPoint;
  TextPainter textPainter;
  bool isAdjust;

  RedrawModel(
      {this.rowTopPoint,
      this.rectTopLeftPoint,
      this.textPainter,
      this.isAdjust});
}

//角的方位
enum RowDirection {
  //初始占位
  Null,
  //朝上
  Top,
  //朝左
  Left,
  //朝下
  Bottom,
  //朝右
  Right,
}
