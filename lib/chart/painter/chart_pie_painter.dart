import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/bean/chart_pie_bean.dart';
import 'package:flutter_chart/chart/enum/chart_pie_enum.dart';
import 'package:flutter_chart/chart/painter/base_painter.dart';

/// 不同区域的显示文案位置枚举
enum PieStyleType {
  //在图对应扇形区域中心箭头标签显示
  InArrow,
  //区域的右下方同对应扇形颜色方块显示，文字在方块中显示
  RightBottomSquareIn,
  //区域的右下方同对应扇形颜色方块显示，文字在方块左侧显示
  RightBottomSquareLeft,
  //区域的右下方同对应扇形颜色方块显示，文字在方块右侧显示
  RightBottomSquareRight,
}

class ChartPiePainter extends BasePainter {
  double value; //当前动画值
  List<ChartPieBean> chartBeans;
  double R, centerR; //圆弧半径,中心圆半径
  Color centerColor; //中心圆颜色
  double divisionWidth; //各个占比之间的分割线宽度，默认为0即不显示分割
  AssistTextShowType assistTextShowType; //辅助性文案显示的样式
  ArrowBegainLocation arrowBegainLocation; //开始画圆的位置
  double basePadding = 16; //默认的边距
  static const Color defaultColor = Colors.deepPurple;
  double startX, endX, startY, endY;
  double centerX, centerY; //圆心
  Color assistBGColor; //辅助性文案的背景框背景颜色
  int decimalDigits; //辅助性百分比显示的小数位数,（饼状图还是真实的比例）
  Paint assistPaint;
  List<PieBean> _pieBeans = [];

  ChartPiePainter(
    this.chartBeans, {
    this.value = 1,
    this.R,
    this.centerR = 0,
    this.divisionWidth = 0,
    this.centerColor = defaultColor,
    this.assistTextShowType = AssistTextShowType.None,
    this.arrowBegainLocation = ArrowBegainLocation.Top,
    this.basePadding = 16,
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
    assistPaint = Paint()
      ..color = assistBGColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    _setPieAngle(); //计算角度
  }

  //辅助性文案的绘制区域
  bool _needCenterAssist = false;
  _drawPie(Canvas canvas) {
    Paint paint = Paint()..isAntiAlias = true;
    var rect = Rect.fromCircle(center: Offset(centerX, centerY), radius: R);
    var realAngle = value * 2 * pi; //当前动画值对应的总角度
    _initPieAngleValue();
    for (var i = 0; i < _pieBeans.length; i++) {
      PieBean bean = _pieBeans[i];
      var targetAngle = bean.startAngle + bean.sweepAngle;
      paint..color = bean.color;
      if (targetAngle <= realAngle) {
        canvas.drawArc(rect, bean.startAngle, bean.sweepAngle, true, paint);
      } else if (bean.startAngle < realAngle) {
        double sweepAngle = realAngle - bean.startAngle;
        canvas.drawArc(rect, bean.startAngle, sweepAngle, true, paint);
      }
      if (_needCenterAssist) {
        double centerRedin = bean.startAngle + bean.sweepAngle / 2;
        double centerSin = sin(centerRedin), centerCos = cos(centerRedin);
        _drawPerRatio(canvas, bean.assistText, bean.assistTextStyle, centerSin,
            centerCos, i);
      }
    }
    if (_needCenterAssist) {
      //查看是否有重叠并进行重新排布，针对尾部和头部的偏移冲突进行重新布局
      _redrawShadowRect(canvas);
    }
  }

  //间隔
  void _drawRectSpeace(Canvas canvas) {
    for (var bean in _pieBeans) {
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
    _pieBeans.clear();
    double total = _getTotal(chartBeans);
    double rate = 0;
    double startAngle = 0; // 扇形开始的角度 正上方
    switch (arrowBegainLocation) {
      case ArrowBegainLocation.Top:
        startAngle = -pi / 2;
        break;
      case ArrowBegainLocation.Right:
        startAngle = 0;
        break;
      case ArrowBegainLocation.Top:
        startAngle = pi / 2;
        break;
      case ArrowBegainLocation.Top:
        startAngle = pi;
        break;
      default:
        startAngle = pi;
    }
    for (var bean in chartBeans) {
      PieBean pieBean = PieBean(
          value: bean.value,
          type: bean.type,
          color: bean.color,
          assistTextStyle: bean.assistTextStyle);
      rate = bean.value / total; //当前对象值所占比例
      pieBean.rate = rate;
      switch (assistTextShowType) {
        case AssistTextShowType.OnlyName:
          _needCenterAssist = true;
          pieBean.assistText = bean.type;
          break;
        case AssistTextShowType.OnlyPercentage:
          _needCenterAssist = true;
          pieBean.assistText = (rate * 100).toStringAsFixed(decimalDigits);
          break;
        case AssistTextShowType.NamePercentage:
          _needCenterAssist = true;
          String percentStr = (rate * 100).toStringAsFixed(decimalDigits);
          pieBean.assistText = '$percentStr%${bean.type}';
          break;
        default:
      }
      pieBean.startAngle = startAngle;
      pieBean.sweepAngle = rate * 2 * pi; //当前对象所占比例 对应的 角度
      startAngle += pieBean.sweepAngle;
      _pieBeans.add(pieBean);
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

  /// 绘制饼状图途中周围显示的尖角标签 开始

  //角朝向，内部使用
  RowDirection _lastRowDirection;
  //上一次绘制文案的最大距离,(角朝上的话为x的min，角朝下的话为x的max。以此角朝左右的为y的min，max，绘制是顺时针方向的)
  double _lastXY;
  //y轴的最大值，对应用来上下角出现叠加的时候计算位置使用。
  double _lastYOverlay;
  //可能需要重绘的数组
  List<RedrawModel> _redrawArr = [];
  double _rowHeiWidth = 5, _speaseWidth = 10; //尖角高5，左右各多5像素
  //如果多个平行绘制的话，文本框之间的间距
  double _speaceBetween = 2;
  //如果第一个是左角的话记录此位置，以便后面对比是否有重合,
  Point _fistTopLeftPoint;
  //是否需要加入到重绘数组中，当绘制完其他的角之后即打开，再绘制左角就可加入数组
  bool _isNeedEnterRedrawArr;
  //y轴重叠重绘数组
  List<RedrawModel> _yRedrawArrRowTop = [];
  List<RedrawModel> _yRedrawArrRowBottom = [];
  //初始绘制值初始化
  void _initPieAngleValue() {
    _isNeedEnterRedrawArr = false;
    _fistTopLeftPoint = null;
    _redrawArr.clear();
    _yRedrawArrRowTop.clear();
    _yRedrawArrRowBottom.clear();
    _lastRowDirection = RowDirection.Null;
  }

  void _drawPerRatio(Canvas canvas, String title, TextStyle titleStyle,
      double centerSin, double centerCos, int index) {
    TextPainter tp = new TextPainter(
        textAlign: TextAlign.center,
        ellipsis: '.',
        maxLines: 1,
        text: TextSpan(text: title, style: titleStyle),
        textDirection: TextDirection.ltr)
      ..layout();

    double assistTextWidth = tp.width + _speaseWidth;
    double assistTextHeight = tp.height;

    double rowYspeace = (R + 5) * centerSin;
    double rowXspeace = (R + 5) * centerCos;
    Point rowPoint = Point(centerX + rowXspeace, centerY + rowYspeace);

    //尖角的底部宽度默认设置5
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
        _isNeedEnterRedrawArr = true;
        //上角
        shadowLeftTopPoint =
            Point(rowPoint.x - assistTextWidth / 2, rowPoint.y + _rowHeiWidth);
        if (_lastRowDirection == RowDirection.Top) {
          if ((rowPoint.x + assistTextWidth / 2) > _lastXY) {
            //有重叠
            shadowLeftTopPoint =
                Point(rowPoint.x - assistTextWidth / 2, _lastYOverlay);
          }
        } else {
          if (_lastXY != null && (rowPoint.y + _rowHeiWidth) < _lastXY) {
            //跨域重叠，只存在左上角和右下角
            shadowLeftTopPoint =
                Point(rowPoint.x - assistTextWidth / 2, _lastXY);
          }
        }
        //待比对点
        Point beforePoint = centerCos > 0
            ? Point(shadowLeftTopPoint.x, shadowLeftTopPoint.y)
            : Point(
                shadowLeftTopPoint.x + assistTextWidth, shadowLeftTopPoint.y);
        Point afterPoint = _pointToPointDistance(beforePoint);
        if (afterPoint.x != beforePoint.x || afterPoint.y != beforePoint.y) {
          shadowLeftTopPoint = Point(
              afterPoint.x - (centerCos > 0 ? 0 : assistTextWidth),
              afterPoint.y);
        }
        _yRedrawArrRowTop.add(RedrawModel(
            rowTopPoint: rowPoint,
            rectTopLeftPoint: shadowLeftTopPoint,
            textPainter: tp));
        _lastXY = shadowLeftTopPoint.x - _speaceBetween;
        _lastRowDirection = RowDirection.Top;
        _lastYOverlay = shadowLeftTopPoint.y + tp.height + _speaceBetween;
      } else {
        _isNeedEnterRedrawArr = true;
        //下角
        shadowLeftTopPoint = Point(rowPoint.x - assistTextWidth / 2,
            rowPoint.y - _rowHeiWidth - assistTextHeight);
        if (_lastRowDirection == RowDirection.Bottom) {
          if ((rowPoint.x - assistTextWidth / 2) < _lastXY) {
            //有重叠
            shadowLeftTopPoint = Point(rowPoint.x - assistTextWidth / 2,
                _lastYOverlay - assistTextHeight);
          }
        } else {
          if (_lastXY != null && (rowPoint.y - _rowHeiWidth) > _lastXY) {
            //跨域重叠，只存在左上角和右下角
            shadowLeftTopPoint = Point(
                rowPoint.x - assistTextWidth / 2, _lastXY - assistTextHeight);
          }
        }
        //待比对点
        Point beforePoint = centerCos > 0
            ? Point(
                shadowLeftTopPoint.x, shadowLeftTopPoint.y + assistTextHeight)
            : Point(shadowLeftTopPoint.x + assistTextWidth,
                shadowLeftTopPoint.y + assistTextHeight);
        Point afterPoint = _pointToPointDistance(beforePoint);
        if (afterPoint.x != beforePoint.x || afterPoint.y != beforePoint.y) {
          shadowLeftTopPoint = Point(
              afterPoint.x - (centerCos > 0 ? 0 : assistTextWidth),
              afterPoint.y - assistTextHeight);
        }
        _yRedrawArrRowBottom.add(RedrawModel(
            rowTopPoint: rowPoint,
            rectTopLeftPoint: shadowLeftTopPoint,
            textPainter: tp));
        _lastXY = shadowLeftTopPoint.x + assistTextWidth + _speaceBetween;
        _lastRowDirection = RowDirection.Bottom;
        _lastYOverlay = shadowLeftTopPoint.y - _speaceBetween;
      }
    } else {
      //左右脚
      if (centerCos > 0) {
        //出左脚
        bool isAdject = false;
        shadowLeftTopPoint =
            Point(rowPoint.x + _rowHeiWidth, rowPoint.y - assistTextHeight / 2);
        if (index == 0) {
          _fistTopLeftPoint = shadowLeftTopPoint;
        }
        if (_lastRowDirection == RowDirection.Left) {
          if ((rowPoint.y - assistTextHeight / 2) < _lastXY) {
            //有重叠
            shadowLeftTopPoint = Point(rowPoint.x + _rowHeiWidth, _lastXY);
            approachSpeace = assistTextHeight / 2;
            isAdject = true;
          }
        }
        if (_isNeedEnterRedrawArr) {
          _redrawArr.add(RedrawModel(
              rowTopPoint: rowPoint,
              rectTopLeftPoint: shadowLeftTopPoint,
              textPainter: tp,
              isAdjust: isAdject));
        } else {
          _redrewAllleftRow(canvas, rowPoint, shadowLeftTopPoint, tp, isAdject);
        }

        _lastXY = shadowLeftTopPoint.y + assistTextHeight + _speaceBetween;
        _lastRowDirection = RowDirection.Left;
      } else {
        _isNeedEnterRedrawArr = true;
        //出右角
        shadowLeftTopPoint = Point(rowPoint.x - _rowHeiWidth - assistTextWidth,
            rowPoint.y - assistTextHeight / 2);
        if (_lastRowDirection == RowDirection.Right) {
          if ((rowPoint.y + assistTextHeight / 2) > _lastXY) {
            //有重叠
            shadowLeftTopPoint = Point(
                rowPoint.x - _rowHeiWidth - assistTextWidth,
                _lastXY - assistTextHeight);
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
        _lastXY = shadowLeftTopPoint.y - _speaceBetween;
        _lastRowDirection = RowDirection.Right;

        path
          ..lineTo(rowPoint.x, rowPoint.y)
          ..close();
        canvas.drawPath(path, paint);
        tp.paint(
            canvas,
            Offset(
                shadowLeftTopPoint.x + _speaseWidth / 2, shadowLeftTopPoint.y));
      }
    }
  }

  void _redrawShadowRect(Canvas canvas) {
    if (_redrawArr.length != 0 && _fistTopLeftPoint != null) {
      RedrawModel model = _redrawArr.last;
      if ((model.rectTopLeftPoint.y + model.textPainter.height) >
          _fistTopLeftPoint.y) {
        double begainY = _fistTopLeftPoint.y - _speaceBetween;
        //反向重排并绘制
        for (var i = _redrawArr.length - 1; i >= 0; i--) {
          RedrawModel tempModel = _redrawArr[i];
          begainY -= tempModel.textPainter.height;
          if (begainY < tempModel.rectTopLeftPoint.y) {
            tempModel.rectTopLeftPoint =
                Point(tempModel.rectTopLeftPoint.x, begainY);
            tempModel.isAdjust = true;
          }
          begainY = tempModel.rectTopLeftPoint.y - _speaceBetween;
        }
      }
    }

    //数组中的重绘
    for (var item in _redrawArr) {
      _redrewAllleftRow(canvas, item.rowTopPoint, item.rectTopLeftPoint,
          item.textPainter, item.isAdjust);
    }
    //上下倒着绘制，防止尖角覆盖上一个的内容
    for (var i = _yRedrawArrRowTop.length - 1; i >= 0; i--) {
      var item = _yRedrawArrRowTop[i];
      _redrewAllTopRow(
          canvas, item.rowTopPoint, item.rectTopLeftPoint, item.textPainter);
    }
    for (var i = _yRedrawArrRowBottom.length - 1; i >= 0; i--) {
      var item = _yRedrawArrRowBottom[i];
      _redrewAllBottomRow(
          canvas, item.rowTopPoint, item.rectTopLeftPoint, item.textPainter);
    }
  }

  void _redrewAllBottomRow(
      Canvas canvas, Point point, Point begainLeftTopPoint, TextPainter tp) {
    Path path = Path()..moveTo(point.x, point.y);
    double assistTextWidth = tp.width + _speaseWidth;
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
        Offset(begainLeftTopPoint.x + _speaseWidth / 2, begainLeftTopPoint.y));
  }

  void _redrewAllTopRow(
      Canvas canvas, Point point, Point begainLeftTopPoint, TextPainter tp) {
    Path path = Path()..moveTo(point.x, point.y);
    double assistTextWidth = tp.width + _speaseWidth;
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
        Offset(begainLeftTopPoint.x + _speaseWidth / 2, begainLeftTopPoint.y));
  }

  void _redrewAllleftRow(Canvas canvas, Point point, Point begainLeftTopPoint,
      TextPainter tp, bool isAdjust) {
    Path path = Path()..moveTo(point.x, point.y);
    double assistTextWidth = tp.width + _speaseWidth;
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
        Offset(begainLeftTopPoint.x + _speaseWidth / 2, begainLeftTopPoint.y));
  }

  //计算可能可能存在和饼状区域有交集的点与圆心的距离，返回：如果有交集返回应该扩展的高度，没有交集返回0
  Point _pointToPointDistance(Point point) {
    double xDistance = (point.x - centerX);
    double yDistance = (point.y - centerY);
    double quartXY = xDistance * xDistance + yDistance * yDistance;
    double speaceWidth = sqrt(quartXY);
    if (speaceWidth >= R) {
      return point;
    } else {
      return Point(centerX + (R + 5) * xDistance / speaceWidth,
          centerY + (R + 5) * yDistance / speaceWidth);
    }
  }

  /// 绘制饼状图途中周围显示的尖角标签 结束

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

class PieBean {
  //占比数值，可以任意写数值，会统一计算最后每块的占比
  double value;
  //扇形板块的类型标记名称
  String type;
  //扇形板块的颜色
  Color color;
  //辅助性文案展示的文案样式
  TextStyle assistTextStyle;

  //辅助性文案（内部计算勿传）
  String assistText;
  //所占比例（内部计算勿传）
  double rate;
  //开始角度（内部计算）
  double startAngle;
  //所占角度（内部计算）
  double sweepAngle;
  PieBean(
      {this.value,
      this.type,
      this.color,
      this.assistTextStyle,
      this.assistText,
      this.rate,
      this.startAngle,
      this.sweepAngle});
}
