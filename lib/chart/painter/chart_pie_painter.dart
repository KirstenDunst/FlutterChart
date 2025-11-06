import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_pie.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_pie_content.dart';
import 'package:flutter_chart_csx/chart/enum/chart_pie_enum.dart';
import '../base/painter_const.dart';
import 'package:flutter_chart_csx/chart/base/base_painter.dart';

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
  //当前动画值
  double value;
  List<ChartPieBean> chartBeans;
  //圆弧半径,中心圆半径
  double globalR;
  double centerR;
  //中心圆颜色
  Color centerColor;
  //各个占比之间的分割线宽度，默认为0即不显示分割
  double divisionWidth;
  //辅助性文案显示的样式
  AssistTextShowType assistTextShowType;
  //开始画圆的位置
  ArrowBegainLocation arrowBegainLocation;
  //辅助性文案的背景框背景颜色
  Color assistBGColor;
  //辅助性百分比显示的小数位数,（饼状图还是真实的比例）
  int decimalDigits;
  late double _startX, _endX, _startY, _endY;
  late double _centerX, _centerY; //圆心
  late Paint _assistPaint;
  late List<PieBean> _pieBeans;

  ChartPiePainter(
    this.chartBeans, {
    this.value = 1,
    this.globalR = 0,
    this.centerR = 0,
    this.divisionWidth = 0,
    this.centerColor = defaultColor,
    this.assistTextShowType = AssistTextShowType.None,
    this.arrowBegainLocation = ArrowBegainLocation.Top,
    this.assistBGColor = defaultColor,
    this.decimalDigits = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    if (chartBeans.isEmpty) {
      throw '饼状图没有扇区数组,扇区数组chartBeans为空!';
    }
    _init(size);
    //计算角度
    _setPieAngle();
    //画圆弧
    _drawPie(canvas);
    if (divisionWidth > 0) {
      //画间隔线
      _drawRectSpeace(canvas);
    }
    //画中心圆
    _drawCenter(canvas);
  }

  /// 初始化
  void _init(Size size) {
    _pieBeans = <PieBean>[];
    _startX = baseBean.basePadding.left;
    _endX = size.width - baseBean.basePadding.right;
    _startY = size.height - baseBean.basePadding.bottom;
    _endY = baseBean.basePadding.top;

    _centerX = _startX + (_endX - _startX) / 2;
    _centerY = _endY + (_startY - _endY) / 2;
    var xR = _endX - _centerX;
    var yR = _startY - _centerY;
    var realR = xR.compareTo(yR) > 0 ? yR : xR;

    if (globalR == 0) {
      globalR = realR;
    } else if (globalR > realR) {
      globalR = realR;
    }
    if (centerR > globalR) centerR = globalR;
    _assistPaint = Paint()
      ..color = assistBGColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
  }

  /// 绘制圆饼
  void _drawPie(Canvas canvas) {
    var paint = Paint()..isAntiAlias = true;
    var rect =
        Rect.fromCircle(center: Offset(_centerX, _centerY), radius: globalR);
    var realAngle = value * 2 * pi; //当前动画值对应的总角度
    _initPieAngleValue();
    //绘制排序
    for (var i = 0; i < _pieBeans.length; i++) {
      var bean = _pieBeans[i];
      var targetAngle = bean.startAngle + bean.sweepAngle;
      paint..color = bean.color;
      if (targetAngle <= realAngle) {
        canvas.drawArc(rect, bean.startAngle, bean.sweepAngle, true, paint);
      } else if (bean.startAngle < realAngle) {
        var sweepAngle = realAngle - bean.startAngle;
        canvas.drawArc(rect, bean.startAngle, sweepAngle, true, paint);
      }
      if (bean.assistText.isNotEmpty) {
        var centerRedin = bean.startAngle + bean.sweepAngle / 2;
        var centerSin = sin(centerRedin), centerCos = cos(centerRedin);
        _drawPerRatio(canvas, bean.assistText, bean.assistTextStyle, centerSin,
            centerCos);
      }
    }
    //倒序输出，防止尖角遮挡
    for (var i = _redrawTopArr.length - 1; i >= 0; i--) {
      var item = _redrawTopArr[i];
      _redrewTopRow(
          canvas, item.rowTopPoint, item.rectTopLeftPoint, item.textPainter);
    }
    for (var i = _redrawLeftArr.length - 1; i >= 0; i--) {
      var item = _redrawLeftArr[i];
      _redrewLeftRow(canvas, item.rowTopPoint, item.rectTopLeftPoint,
          item.textPainter, item.isAdjust);
    }
    for (var i = _redrawBottomArr.length - 1; i >= 0; i--) {
      var item = _redrawBottomArr[i];
      _redrewBottomRow(
          canvas, item.rowTopPoint, item.rectTopLeftPoint, item.textPainter);
    }
    for (var i = _redrawRightArr.length - 1; i >= 0; i--) {
      var item = _redrawRightArr[i];
      _redrewRightRow(canvas, item.rowTopPoint, item.rectTopLeftPoint,
          item.textPainter, item.isAdjust);
    }
  }

  /// 绘制间隔
  void _drawRectSpeace(Canvas canvas) {
    for (var bean in _pieBeans) {
      _drawSpeaceRect(canvas, bean.startAngle);
    }
  }

  /// 绘制间隔区间
  void _drawSpeaceRect(Canvas canvas, double angle) {
    var speacePaint = Paint()
      ..color = centerColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = divisionWidth
      ..isAntiAlias = true;
    var arcPoint =
        Point(_centerX + globalR * cos(angle), _centerY + globalR * sin(angle));
    canvas.drawLine(Offset(_centerX, _centerY), Offset(arcPoint.x, arcPoint.y),
        speacePaint);
  }

  /// 绘制中心区域
  void _drawCenter(Canvas canvas) {
    var paint = Paint()
      ..color = centerColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    canvas.drawCircle(Offset(_centerX, _centerY), centerR, paint);
  }

  /// 计算各个扇形的起始角度
  void _setPieAngle() {
    var total = chartBeans.first.value;
    var maxIndex = 0;
    var maxValue = chartBeans.first.value;
    for (var i = 1; i < chartBeans.length; i++) {
      var bean = chartBeans[i];
      if (maxValue < bean.value) {
        maxIndex = i;
        maxValue = bean.value;
      }
      total += bean.value;
    }
    //调整从最大的扇形开始画，避免首尾重叠内部一堆逻辑处理的问题出现。
    var residualAngle = 0.0;
    var tempChartBeans = <ChartPieBean>[];
    if (maxIndex == 0) {
      tempChartBeans.addAll(chartBeans);
    } else {
      tempChartBeans.addAll(chartBeans.getRange(0, maxIndex));
      tempChartBeans.forEach((element) => residualAngle += element.value);
      tempChartBeans.insertAll(
          0, chartBeans.getRange(maxIndex, chartBeans.length));
    }
    var startAngle = 0.0; // 扇形开始的角度 右侧
    switch (arrowBegainLocation) {
      case ArrowBegainLocation.Top:
        startAngle = -pi / 2;
        break;
      case ArrowBegainLocation.Right:
        startAngle = 0.0;
        break;
      case ArrowBegainLocation.Bottom:
        startAngle = -pi * 3 / 2;
        break;
      case ArrowBegainLocation.Left:
        startAngle = -pi;
        break;
    }
    startAngle += (residualAngle / total * 2 * pi);
    if (startAngle > 0) {
      startAngle -= 2 * pi;
    }
    _pieBeans.clear();
    for (var bean in tempChartBeans) {
      var pieBean = PieBean(
          value: bean.value,
          type: bean.type,
          color: bean.color,
          assistTextStyle: bean.assistTextStyle);
      var rate = bean.value / total; //当前对象值所占比例
      pieBean.rate = rate;
      switch (assistTextShowType) {
        case AssistTextShowType.OnlyName:
          pieBean.assistText = bean.type;
          break;
        case AssistTextShowType.OnlyPercentage:
          pieBean.assistText = (rate * 100).toStringAsFixed(decimalDigits);
          break;
        case AssistTextShowType.NamePercentage:
          var percentStr = (rate * 100).toStringAsFixed(decimalDigits);
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

  /// 绘制饼状图途中周围显示的尖角标签
  //角朝向，内部使用
  late RowDirection _lastRowDirection;
  //上一个标签的frame
  late Frame _lastTextFrame;
  //需要重绘数组
  late List<RedrawModel> _redrawTopArr,
      _redrawLeftArr,
      _redrawBottomArr,
      _redrawRightArr;
  //尖角高5，左右各多5像素
  final _rowHeiWidth = 5.0, _speaseWidth = 10.0;

  /// 初始绘制值初始化
  void _initPieAngleValue() {
    _lastTextFrame = Frame(x: 0, y: 0, width: 0, height: 0);
    _lastRowDirection = RowDirection.Null;
    _redrawTopArr = <RedrawModel>[];
    _redrawLeftArr = <RedrawModel>[];
    _redrawBottomArr = <RedrawModel>[];
    _redrawRightArr = <RedrawModel>[];
  }

  /// 绘制每一块扇形区域
  void _drawPerRatio(Canvas canvas, String? title, TextStyle? titleStyle,
      double centerSin, double centerCos) {
    var tp = TextPainter(
        textAlign: TextAlign.center,
        ellipsis: '.',
        maxLines: 1,
        text: TextSpan(text: title, style: titleStyle),
        textDirection: TextDirection.ltr)
      ..layout();
    var assistTextWidth = tp.width + _speaseWidth;
    var assistTextHeight = tp.height;

    var rowYspeace = (globalR + 5) * centerSin;
    var rowXspeace = (globalR + 5) * centerCos;
    var rowPoint = Point(_centerX + rowXspeace, _centerY + rowYspeace);

    //阴影框的左上角起始点
    Point<double> shadowLeftTopPoint;
    if (centerSin.abs() > centerCos.abs()) {
      //上下脚
      var isTop = centerSin > 0;
      if (isTop) {
        //上角
        shadowLeftTopPoint =
            Point(rowPoint.x - assistTextWidth / 2, rowPoint.y + _rowHeiWidth);
        if (![RowDirection.Bottom, RowDirection.Null]
            .contains(_lastRowDirection)) {
          if (_lastRowDirection == RowDirection.Top) {
            if ((rowPoint.x + assistTextWidth / 2) > _lastTextFrame.minSpaceX) {
              //并排重叠
              shadowLeftTopPoint = Point(
                  rowPoint.x - assistTextWidth / 2, _lastTextFrame.maxSpaceY);
            }
          } else if ((rowPoint.y + _rowHeiWidth) < _lastTextFrame.maxSpaceY) {
            //跨域重叠(右下)
            shadowLeftTopPoint = Point(
                rowPoint.x - assistTextWidth / 2, _lastTextFrame.maxSpaceY);
          }
        }
        //同级横向是否存在与饼状图有冲突叠加，并计算安全的topleftpoint位置
        var beforePoint = centerCos > 0
            ? Point(shadowLeftTopPoint.x, shadowLeftTopPoint.y)
            : Point(
                shadowLeftTopPoint.x + assistTextWidth, shadowLeftTopPoint.y);
        var afterPoint = _pointToPointDistance(beforePoint);
        if (afterPoint.x != beforePoint.x || afterPoint.y != beforePoint.y) {
          shadowLeftTopPoint = Point(
              afterPoint.x - (centerCos > 0 ? 0 : assistTextWidth),
              afterPoint.y);
        }
        _lastRowDirection = RowDirection.Top;
      } else {
        //下角
        shadowLeftTopPoint = Point(rowPoint.x - assistTextWidth / 2,
            rowPoint.y - _rowHeiWidth - assistTextHeight);
        if (![RowDirection.Top, RowDirection.Null]
            .contains(_lastRowDirection)) {
          if (_lastRowDirection == RowDirection.Bottom) {
            if ((rowPoint.x - assistTextWidth / 2) < _lastTextFrame.maxSpaceX) {
              //并排重叠
              shadowLeftTopPoint = Point(rowPoint.x - assistTextWidth / 2,
                  _lastTextFrame.minSpaceY - assistTextHeight);
            }
          } else if ((rowPoint.y - _rowHeiWidth) > _lastTextFrame.minSpaceY) {
            //跨域重叠(左上)
            shadowLeftTopPoint = Point(rowPoint.x - assistTextWidth / 2,
                _lastTextFrame.minSpaceY - assistTextHeight);
          }
        }
        //同级横向是否存在与饼状图有冲突叠加，并计算安全的topleftpoint位置
        var beforePoint = centerCos > 0
            ? Point(
                shadowLeftTopPoint.x, shadowLeftTopPoint.y + assistTextHeight)
            : Point(shadowLeftTopPoint.x + assistTextWidth,
                shadowLeftTopPoint.y + assistTextHeight);
        var afterPoint = _pointToPointDistance(beforePoint);
        if (afterPoint.x != beforePoint.x || afterPoint.y != beforePoint.y) {
          shadowLeftTopPoint = Point(
              afterPoint.x - (centerCos > 0 ? 0 : assistTextWidth),
              afterPoint.y - assistTextHeight);
        }
        _lastRowDirection = RowDirection.Bottom;
      }
      if (_lastRowDirection != RowDirection.Null) {
        //忽略第一个绘制，最后的之后再把第一个点计算和最后一个是否重叠再绘制
        isTop
            ? _redrawTopArr.add(RedrawModel(
                rowTopPoint: rowPoint,
                rectTopLeftPoint: shadowLeftTopPoint,
                textPainter: tp))
            : _redrawBottomArr.add(RedrawModel(
                rowTopPoint: rowPoint,
                rectTopLeftPoint: shadowLeftTopPoint,
                textPainter: tp));
      }
    } else {
      //左右脚
      var isAdject = false;
      var isLeft = centerCos > 0;
      if (isLeft) {
        //出左脚
        shadowLeftTopPoint =
            Point(rowPoint.x + _rowHeiWidth, rowPoint.y - assistTextHeight / 2);
        if (![RowDirection.Right, RowDirection.Null]
            .contains(_lastRowDirection)) {
          if ((rowPoint.y - assistTextHeight / 2) < _lastTextFrame.maxSpaceY) {
            //同级重叠、跨域重叠(左上)
            shadowLeftTopPoint =
                Point(rowPoint.x + _rowHeiWidth, _lastTextFrame.maxSpaceY);
            isAdject = true;
          }
        }
        _lastRowDirection = RowDirection.Left;
      } else {
        //出右角
        shadowLeftTopPoint = Point(rowPoint.x - _rowHeiWidth - assistTextWidth,
            rowPoint.y - assistTextHeight / 2);
        if (![RowDirection.Left, RowDirection.Null]
            .contains(_lastRowDirection)) {
          if ((rowPoint.y + assistTextHeight / 2) > _lastTextFrame.minSpaceY) {
            //同级重叠、跨域重叠（右下）
            shadowLeftTopPoint = Point(
                rowPoint.x - _rowHeiWidth - assistTextWidth,
                _lastTextFrame.minSpaceY - assistTextHeight);
            isAdject = true;
          }
        }
        _lastRowDirection = RowDirection.Right;
      }
      if (_lastRowDirection != RowDirection.Null) {
        //忽略第一个绘制，最后的之后再把第一个点计算和最后一个是否重叠再绘制
        isLeft
            ? _redrawLeftArr.add(RedrawModel(
                rowTopPoint: rowPoint,
                rectTopLeftPoint: shadowLeftTopPoint,
                textPainter: tp,
                isAdjust: isAdject))
            : _redrawRightArr.add(RedrawModel(
                rowTopPoint: rowPoint,
                rectTopLeftPoint: shadowLeftTopPoint,
                textPainter: tp,
                isAdjust: isAdject));
      }
    }
    _lastTextFrame = Frame(
        x: shadowLeftTopPoint.x,
        y: shadowLeftTopPoint.y,
        width: assistTextWidth,
        height: assistTextHeight);
  }

  ///重绘底部文案
  void _redrewBottomRow(
      Canvas canvas, Point point, Point begainLeftTopPoint, TextPainter tp) {
    var path = Path()..moveTo(point.x.toDouble(), point.y.toDouble());
    var assistTextWidth = tp.width + _speaseWidth;
    var assistTextHeight = tp.height;
    //尖角的底部宽度默认设置5，
    var approachSpeace = 5;
    path
      ..lineTo(begainLeftTopPoint.x + assistTextWidth / 2 - approachSpeace / 2,
          begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(begainLeftTopPoint.x.toDouble(),
          begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(begainLeftTopPoint.x.toDouble(), begainLeftTopPoint.y.toDouble())
      ..lineTo(begainLeftTopPoint.x + assistTextWidth,
          begainLeftTopPoint.y.toDouble())
      ..lineTo(begainLeftTopPoint.x + assistTextWidth,
          begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(begainLeftTopPoint.x + assistTextWidth / 2 + approachSpeace / 2,
          begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(point.x.toDouble(), point.y.toDouble())
      ..close();
    canvas.drawPath(path, _assistPaint);
    tp.paint(
        canvas,
        Offset(begainLeftTopPoint.x + _speaseWidth / 2,
            begainLeftTopPoint.y.toDouble()));
  }

  /// 重绘顶部文案
  void _redrewTopRow(
      Canvas canvas, Point point, Point begainLeftTopPoint, TextPainter tp) {
    var path = Path()..moveTo(point.x.toDouble(), point.y.toDouble());
    var assistTextWidth = tp.width + _speaseWidth;
    var assistTextHeight = tp.height;
    //尖角的底部宽度默认设置5，
    var approachSpeace = 5.0;
    path
      ..lineTo(begainLeftTopPoint.x + assistTextWidth / 2 - approachSpeace / 2,
          begainLeftTopPoint.y.toDouble())
      ..lineTo(begainLeftTopPoint.x.toDouble(), begainLeftTopPoint.y.toDouble())
      ..lineTo(begainLeftTopPoint.x.toDouble(),
          begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(begainLeftTopPoint.x + assistTextWidth,
          begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(begainLeftTopPoint.x + assistTextWidth,
          begainLeftTopPoint.y.toDouble())
      ..lineTo(begainLeftTopPoint.x + assistTextWidth / 2 + approachSpeace / 2,
          begainLeftTopPoint.y.toDouble())
      ..lineTo(point.x.toDouble(), point.y.toDouble())
      ..close();
    canvas.drawPath(path, _assistPaint);
    tp.paint(
        canvas,
        Offset(begainLeftTopPoint.x + _speaseWidth / 2,
            begainLeftTopPoint.y.toDouble()));
  }

  /// 重绘左侧文案
  void _redrewLeftRow(Canvas canvas, Point point, Point begainLeftTopPoint,
      TextPainter tp, bool isAdjust) {
    var path = Path()..moveTo(point.x.toDouble(), point.y.toDouble());
    var assistTextWidth = tp.width + _speaseWidth;
    var assistTextHeight = tp.height;
    //尖角的底部宽度默认设置5，
    var approachSpeace = isAdjust ? (tp.height / 2) : 5.0;
    path
      ..lineTo(begainLeftTopPoint.x.toDouble(),
          begainLeftTopPoint.y + assistTextHeight / 2 - approachSpeace / 2)
      ..lineTo(begainLeftTopPoint.x.toDouble(), begainLeftTopPoint.y.toDouble())
      ..lineTo(begainLeftTopPoint.x + assistTextWidth,
          begainLeftTopPoint.y.toDouble())
      ..lineTo(begainLeftTopPoint.x + assistTextWidth,
          begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(begainLeftTopPoint.x.toDouble(),
          begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(begainLeftTopPoint.x.toDouble(),
          begainLeftTopPoint.y + assistTextHeight / 2 + approachSpeace / 2)
      ..lineTo(point.x.toDouble(), point.y.toDouble())
      ..close();
    canvas.drawPath(path, _assistPaint);
    tp.paint(
        canvas,
        Offset(begainLeftTopPoint.x + _speaseWidth / 2,
            begainLeftTopPoint.y.toDouble()));
  }

  ///绘制所有右侧文案
  void _redrewRightRow(Canvas canvas, Point point, Point begainLeftTopPoint,
      TextPainter tp, bool isAdjust) {
    var path = Path()..moveTo(point.x.toDouble(), point.y.toDouble());
    var assistTextWidth = tp.width + _speaseWidth;
    var assistTextHeight = tp.height;
    //尖角的底部宽度默认设置5，
    var approachSpeace = isAdjust ? (tp.height / 2) : 5.0;
    path
      ..lineTo(begainLeftTopPoint.x + assistTextWidth,
          begainLeftTopPoint.y + assistTextHeight / 2 - approachSpeace / 2)
      ..lineTo(begainLeftTopPoint.x + assistTextWidth,
          begainLeftTopPoint.y.toDouble())
      ..lineTo(begainLeftTopPoint.x.toDouble(), begainLeftTopPoint.y.toDouble())
      ..lineTo(begainLeftTopPoint.x.toDouble(),
          begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(begainLeftTopPoint.x + assistTextWidth,
          begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(begainLeftTopPoint.x + assistTextWidth,
          begainLeftTopPoint.y + assistTextHeight / 2 + approachSpeace / 2);
    path
      ..lineTo(point.x.toDouble(), point.y.toDouble())
      ..close();
    canvas.drawPath(path, _assistPaint);
    tp.paint(
        canvas,
        Offset(begainLeftTopPoint.x + _speaseWidth / 2,
            begainLeftTopPoint.y.toDouble()));
  }

  /// 计算可能存在和饼状区域有交集的点与圆心的距离，返回：处理后的点
  Point<double> _pointToPointDistance(Point<double> point) {
    var xDistance = (point.x - _centerX);
    var yDistance = (point.y - _centerY);
    var quartXY = xDistance * xDistance + yDistance * yDistance;
    var speaceWidth = sqrt(quartXY);
    if (speaceWidth >= globalR) {
      return point;
    } else {
      return Point(_centerX + (globalR + 5) * xDistance / speaceWidth,
          _centerY + (globalR + 5) * yDistance / speaceWidth);
    }
  }
}
