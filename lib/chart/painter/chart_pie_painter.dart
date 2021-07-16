import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_pie.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_pie_content.dart';
import 'package:flutter_chart_csx/chart/enum/chart_pie_enum.dart';
import 'package:flutter_chart_csx/chart/enum/painter_const.dart';
import 'package:flutter_chart_csx/chart/painter/base_painter.dart';

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
  double? globalR, centerR;
  //中心圆颜色
  Color? centerColor;
  //各个占比之间的分割线宽度，默认为0即不显示分割
  double? divisionWidth;
  //辅助性文案显示的样式
  AssistTextShowType? assistTextShowType;
  //开始画圆的位置
  ArrowBegainLocation? arrowBegainLocation;
  //辅助性文案的背景框背景颜色
  Color? assistBGColor;
  //辅助性百分比显示的小数位数,（饼状图还是真实的比例）
  int? decimalDigits;
  late double _startX, _endX, _startY, _endY;
  late double _centerX, _centerY; //圆心
  late Paint _assistPaint;
  late List<PieBean> _pieBeans;
  //辅助性文案的绘制区域
  late bool _needCenterAssist;

  ChartPiePainter(
    this.chartBeans, {
    this.value = 1,
    this.globalR,
    this.centerR,
    this.divisionWidth,
    this.centerColor,
    this.assistTextShowType,
    this.arrowBegainLocation,
    this.assistBGColor,
    this.decimalDigits,
  });

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    _init(size);
    //计算角度
    _setPieAngle();
    //画圆弧
    _drawPie(canvas);
    if (divisionWidth! > 0) {
      //画间隔线
      _drawRectSpeace(canvas);
    }
    //画中心圆
    _drawCenter(canvas);
  }

  @override
  bool shouldRepaint(ChartPiePainter oldDelegate) {
    return true;
  }

  /// 初始化
  void _init(Size size) {
    _pieBeans = <PieBean>[];
    assistBGColor ??= defaultColor;
    centerR ??= 0;
    divisionWidth ??= 0;
    centerColor ??= defaultColor;
    assistTextShowType ??= AssistTextShowType.None;
    arrowBegainLocation ??= ArrowBegainLocation.Top;
    decimalDigits ??= 0;

    _needCenterAssist = false;
    _startX = baseBean!.basePadding.left;
    _endX = size.width - baseBean!.basePadding.right;
    _startY = size.height - baseBean!.basePadding.bottom;
    _endY = baseBean!.basePadding.top;

    _centerX = _startX + (_endX - _startX) / 2;
    _centerY = _endY + (_startY - _endY) / 2;
    var xR = _endX - _centerX;
    var yR = _startY - _centerY;
    var realR = xR.compareTo(yR) > 0 ? yR : xR;

    if (globalR == null || globalR == 0) {
      globalR = realR;
    } else {
      if (globalR! > realR) globalR = realR;
    }
    if (centerR! > globalR!) centerR = globalR;
    _assistPaint = Paint()
      ..color = assistBGColor!
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
  }

  /// 绘制圆饼
  void _drawPie(Canvas canvas) {
    var paint = Paint()..isAntiAlias = true;
    var rect =
        Rect.fromCircle(center: Offset(_centerX, _centerY), radius: globalR!);
    var realAngle = value * 2 * pi; //当前动画值对应的总角度
    _initPieAngleValue();
    for (var i = 0; i < _pieBeans.length; i++) {
      var bean = _pieBeans[i];
      var targetAngle = bean.startAngle! + bean.sweepAngle!;
      paint..color = bean.color!;
      if (targetAngle <= realAngle) {
        canvas.drawArc(rect, bean.startAngle!, bean.sweepAngle!, true, paint);
      } else if (bean.startAngle! < realAngle) {
        var sweepAngle = realAngle - bean.startAngle!;
        canvas.drawArc(rect, bean.startAngle!, sweepAngle, true, paint);
      }
      if (_needCenterAssist) {
        var centerRedin = bean.startAngle! + bean.sweepAngle! / 2;
        var centerSin = sin(centerRedin), centerCos = cos(centerRedin);
        _drawPerRatio(canvas, bean.assistText, bean.assistTextStyle, centerSin,
            centerCos, i);
      }
    }
    if (_needCenterAssist) {
      //查看是否有重叠并进行重新排布，针对尾部和头部的偏移冲突进行重新布局
      _redrawShadowRect(canvas);
    }
  }

  /// 绘制间隔
  void _drawRectSpeace(Canvas canvas) {
    for (var bean in _pieBeans) {
      _drawSpeaceRect(canvas, bean.startAngle!);
    }
  }

  /// 绘制间隔区间
  void _drawSpeaceRect(Canvas canvas, double angle) {
    var speacePaint = Paint()
      ..color = centerColor!
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = divisionWidth!
      ..isAntiAlias = true;
    var arcPoint =
        Point(_centerX + globalR! * cos(angle), _centerY + globalR! * sin(angle));
    canvas.drawLine(Offset(_centerX, _centerY), Offset(arcPoint.x, arcPoint.y),
        speacePaint);
  }

  /// 绘制中心区域
  void _drawCenter(Canvas canvas) {
    var paint = Paint()
      ..color = centerColor!
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    canvas.drawCircle(Offset(_centerX, _centerY), centerR!, paint);
  }

  /// 计算各个扇形的起始角度
  void _setPieAngle() {
    _pieBeans.clear();
    var total = _getTotal(chartBeans);
    var startAngle = 0.0; // 扇形开始的角度 右侧
    switch (arrowBegainLocation) {
      case ArrowBegainLocation.Top:
        startAngle = -pi / 2;
        break;
      case ArrowBegainLocation.Right:
        startAngle = 0.0;
        break;
      case ArrowBegainLocation.Bottom:
        startAngle = pi / 2;
        break;
      case ArrowBegainLocation.Left:
        startAngle = pi;
        break;
      default:
        startAngle = 0.0;
    }
    for (var bean in chartBeans) {
      var pieBean = PieBean(
          value: bean.value,
          type: bean.type,
          color: bean.color,
          assistTextStyle: bean.assistTextStyle);
      var rate = bean.value / total; //当前对象值所占比例
      pieBean.rate = rate;
      switch (assistTextShowType) {
        case AssistTextShowType.OnlyName:
          _needCenterAssist = true;
          pieBean.assistText = bean.type;
          break;
        case AssistTextShowType.OnlyPercentage:
          _needCenterAssist = true;
          pieBean.assistText = (rate * 100).toStringAsFixed(decimalDigits!);
          break;
        case AssistTextShowType.NamePercentage:
          _needCenterAssist = true;
          var percentStr = (rate * 100).toStringAsFixed(decimalDigits!);
          pieBean.assistText = '$percentStr%${bean.type}';
          break;
        default:
      }
      pieBean.startAngle = startAngle;
      pieBean.sweepAngle = rate * 2 * pi; //当前对象所占比例 对应的 角度
      startAngle += pieBean.sweepAngle!;
      _pieBeans.add(pieBean);
    }
  }

  /// 计算数据总和
  double _getTotal(List<ChartPieBean> data) {
    var total = 0.0;
    for (var bean in data) {
      total += bean.value;
    }
    return total;
  }

  /// 绘制饼状图途中周围显示的尖角标签 开始

  //角朝向，内部使用
  RowDirection? _lastRowDirection;
  //上一次绘制文案的最大距离,(角朝上的话为x的min，角朝下的话为x的max。以此角朝左右的为y的min，max，绘制是顺时针方向的)
  double? _lastXY;
  //y轴的最大值，对应用来上下角出现叠加的时候计算位置使用。
  late double _lastYOverlay;
  //可能需要重绘的数组
  late List<RedrawModel> _redrawArr;
  var _rowHeiWidth, _speaseWidth; //尖角高5，左右各多5像素
  //如果多个平行绘制的话，文本框之间的间距
  final double _speaceBetween = 2;
  //如果第一个是左角的话记录此位置，以便后面对比是否有重合,
  Point? _fistTopLeftPoint;
  //是否需要加入到重绘数组中，当绘制完其他的角之后即打开，再绘制左角就可加入数组
  late bool _isNeedEnterRedrawArr;
  //y轴重叠重绘数组
  late List<RedrawModel> _yRedrawArrRowTop;
  late List<RedrawModel> _yRedrawArrRowBottom;

  /// 初始绘制值初始化
  void _initPieAngleValue() {
    _rowHeiWidth = 5.0;
    _speaseWidth = 10.0;
    _isNeedEnterRedrawArr = false;
    _fistTopLeftPoint = null;
    _redrawArr = [];
    _yRedrawArrRowTop = [];
    _yRedrawArrRowBottom = [];
    _lastRowDirection = RowDirection.Null;
  }

  /// 绘制每一块扇形区域
  void _drawPerRatio(Canvas canvas, String? title, TextStyle? titleStyle,
      double centerSin, double centerCos, int index) {
    var tp = TextPainter(
        textAlign: TextAlign.center,
        ellipsis: '.',
        maxLines: 1,
        text: TextSpan(text: title, style: titleStyle),
        textDirection: TextDirection.ltr)
      ..layout();

    var assistTextWidth = tp.width + _speaseWidth;
    var assistTextHeight = tp.height;

    var rowYspeace = (globalR! + 5) * centerSin;
    var rowXspeace = (globalR! + 5) * centerCos;
    var rowPoint = Point(_centerX + rowXspeace, _centerY + rowYspeace);

    //尖角的底部宽度默认设置5
    var approachSpeace = 5.0;
    //阴影框的左上角起始点
    Point shadowLeftTopPoint;
    var paint = Paint()
      ..color = assistBGColor!
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    var path = Path()..moveTo(rowPoint.x, rowPoint.y);
    if (centerSin.abs() > centerCos.abs()) {
      //上下脚
      if (centerSin > 0) {
        _isNeedEnterRedrawArr = true;
        //上角
        shadowLeftTopPoint =
            Point(rowPoint.x - assistTextWidth / 2, rowPoint.y + _rowHeiWidth);
        if (_lastRowDirection == RowDirection.Top) {
          if ((rowPoint.x + assistTextWidth / 2) > _lastXY!) {
            //有重叠
            shadowLeftTopPoint =
                Point(rowPoint.x - assistTextWidth / 2, _lastYOverlay);
          }
        } else if (_lastRowDirection != RowDirection.Bottom) {
          if (_lastXY != null && (rowPoint.y + _rowHeiWidth) < _lastXY!) {
            //跨域重叠，只存在左上角和右下角
            shadowLeftTopPoint =
                Point(rowPoint.x - assistTextWidth / 2, _lastXY!);
          }
        }
        //待比对点
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
          if ((rowPoint.x - assistTextWidth / 2) < _lastXY!) {
            //有重叠
            shadowLeftTopPoint = Point(rowPoint.x - assistTextWidth / 2,
                _lastYOverlay - assistTextHeight);
          }
        } else if (_lastRowDirection != RowDirection.Top) {
          if (_lastXY != null && (rowPoint.y - _rowHeiWidth) > _lastXY!) {
            //跨域重叠，只存在左上角和右下角
            shadowLeftTopPoint = Point(
                rowPoint.x - assistTextWidth / 2, _lastXY! - assistTextHeight);
          }
        }
        //待比对点
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
        var isAdject = false;
        shadowLeftTopPoint =
            Point(rowPoint.x + _rowHeiWidth, rowPoint.y - assistTextHeight / 2);
        if (index == 0) {
          _fistTopLeftPoint = shadowLeftTopPoint;
        }
        if (_lastRowDirection == RowDirection.Left) {
          if ((rowPoint.y - assistTextHeight / 2) < _lastXY!) {
            //有重叠
            shadowLeftTopPoint = Point(rowPoint.x + _rowHeiWidth, _lastXY!);
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
          if ((rowPoint.y + assistTextHeight / 2) > _lastXY!) {
            //有重叠
            shadowLeftTopPoint = Point(
                rowPoint.x - _rowHeiWidth - assistTextWidth,
                _lastXY! - assistTextHeight);
            approachSpeace = assistTextHeight / 2;
          }
        }
        path
          ..lineTo(shadowLeftTopPoint.x + assistTextWidth,
              shadowLeftTopPoint.y + assistTextHeight / 2 - approachSpeace / 2)
          ..lineTo(shadowLeftTopPoint.x + assistTextWidth, shadowLeftTopPoint.y as double)
          ..lineTo(shadowLeftTopPoint.x as double, shadowLeftTopPoint.y as double)
          ..lineTo(
              shadowLeftTopPoint.x as double, shadowLeftTopPoint.y + assistTextHeight)
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
                shadowLeftTopPoint.x + _speaseWidth / 2 as double, shadowLeftTopPoint.y as double));
      }
    }
  }

  /// 重绘填充色边框
  void _redrawShadowRect(Canvas canvas) {
    if (_redrawArr.isNotEmpty && _fistTopLeftPoint != null) {
      var model = _redrawArr.last;
      if ((model.rectTopLeftPoint!.y + model.textPainter!.height) >
          _fistTopLeftPoint!.y) {
        double begainY = _fistTopLeftPoint!.y - _speaceBetween;
        //反向重排并绘制
        for (var i = _redrawArr.length - 1; i >= 0; i--) {
          var tempModel = _redrawArr[i];
          begainY -= tempModel.textPainter!.height;
          if (begainY < tempModel.rectTopLeftPoint!.y) {
            tempModel.rectTopLeftPoint =
                Point(tempModel.rectTopLeftPoint!.x, begainY);
            tempModel.isAdjust = true;
          }
          begainY = tempModel.rectTopLeftPoint!.y - _speaceBetween;
        }
      }
    }

    //数组中的重绘
    for (var item in _redrawArr) {
      _redrewAllleftRow(canvas, item.rowTopPoint!, item.rectTopLeftPoint!,
          item.textPainter!, item.isAdjust!);
    }
    //上下倒着绘制，防止尖角覆盖上一个的内容
    for (var i = _yRedrawArrRowTop.length - 1; i >= 0; i--) {
      var item = _yRedrawArrRowTop[i];
      _redrewAllTopRow(
          canvas, item.rowTopPoint!, item.rectTopLeftPoint!, item.textPainter!);
    }
    for (var i = _yRedrawArrRowBottom.length - 1; i >= 0; i--) {
      var item = _yRedrawArrRowBottom[i];
      _redrewAllBottomRow(
          canvas, item.rowTopPoint!, item.rectTopLeftPoint!, item.textPainter!);
    }
  }

  ///重绘底部文案
  void _redrewAllBottomRow(
      Canvas canvas, Point point, Point begainLeftTopPoint, TextPainter tp) {
    var path = Path()..moveTo(point.x as double, point.y as double);
    var assistTextWidth = tp.width + _speaseWidth;
    var assistTextHeight = tp.height;
    //尖角的底部宽度默认设置5，
    var approachSpeace = 5;
    path
      ..lineTo(begainLeftTopPoint.x + assistTextWidth / 2 - approachSpeace / 2,
          begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(begainLeftTopPoint.x as double, begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(begainLeftTopPoint.x as double, begainLeftTopPoint.y as double)
      ..lineTo(begainLeftTopPoint.x + assistTextWidth, begainLeftTopPoint.y as double)
      ..lineTo(begainLeftTopPoint.x + assistTextWidth,
          begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(begainLeftTopPoint.x + assistTextWidth / 2 + approachSpeace / 2,
          begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(point.x as double, point.y as double)
      ..close();
    canvas.drawPath(path, _assistPaint);
    tp.paint(canvas,
        Offset(begainLeftTopPoint.x + _speaseWidth / 2 as double, begainLeftTopPoint.y as double));
  }

  /// 重绘顶部文案
  void _redrewAllTopRow(
      Canvas canvas, Point point, Point begainLeftTopPoint, TextPainter tp) {
    var path = Path()..moveTo(point.x as double, point.y as double);
    var assistTextWidth = tp.width + _speaseWidth;
    var assistTextHeight = tp.height;
    //尖角的底部宽度默认设置5，
    var approachSpeace = 5.0;
    path
      ..lineTo(begainLeftTopPoint.x + assistTextWidth / 2 - approachSpeace / 2,
          begainLeftTopPoint.y as double)
      ..lineTo(begainLeftTopPoint.x as double, begainLeftTopPoint.y as double)
      ..lineTo(begainLeftTopPoint.x as double, begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(begainLeftTopPoint.x + assistTextWidth,
          begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(begainLeftTopPoint.x + assistTextWidth, begainLeftTopPoint.y as double)
      ..lineTo(begainLeftTopPoint.x + assistTextWidth / 2 + approachSpeace / 2,
          begainLeftTopPoint.y as double)
      ..lineTo(point.x as double, point.y as double)
      ..close();
    canvas.drawPath(path, _assistPaint);
    tp.paint(canvas,
        Offset(begainLeftTopPoint.x + _speaseWidth / 2 as double, begainLeftTopPoint.y as double));
  }

  /// 重绘左侧文案
  void _redrewAllleftRow(Canvas canvas, Point point, Point begainLeftTopPoint,
      TextPainter tp, bool isAdjust) {
    var path = Path()..moveTo(point.x as double, point.y as double);
    var assistTextWidth = tp.width + _speaseWidth;
    var assistTextHeight = tp.height;
    //尖角的底部宽度默认设置5，
    var approachSpeace = isAdjust ? (tp.height / 2) : 5.0;
    path
      ..lineTo(begainLeftTopPoint.x as double,
          begainLeftTopPoint.y + assistTextHeight / 2 - approachSpeace / 2)
      ..lineTo(begainLeftTopPoint.x as double, begainLeftTopPoint.y as double)
      ..lineTo(begainLeftTopPoint.x + assistTextWidth, begainLeftTopPoint.y as double)
      ..lineTo(begainLeftTopPoint.x + assistTextWidth,
          begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(begainLeftTopPoint.x as double, begainLeftTopPoint.y + assistTextHeight)
      ..lineTo(begainLeftTopPoint.x as double,
          begainLeftTopPoint.y + assistTextHeight / 2 + approachSpeace / 2)
      ..lineTo(point.x as double, point.y as double)
      ..close();
    canvas.drawPath(path, _assistPaint);
    tp.paint(canvas,
        Offset(begainLeftTopPoint.x + _speaseWidth / 2 as double, begainLeftTopPoint.y as double));
  }

  /// 计算可能可能存在和饼状区域有交集的点与圆心的距离，返回：如果有交集返回应该扩展的高度，没有交集返回0
  Point _pointToPointDistance(Point point) {
    double xDistance = (point.x - _centerX);
    double yDistance = (point.y - _centerY);
    var quartXY = xDistance * xDistance + yDistance * yDistance;
    var speaceWidth = sqrt(quartXY);
    if (speaceWidth >= globalR!) {
      return point;
    } else {
      return Point(_centerX + (globalR! + 5) * xDistance / speaceWidth,
          _centerY + (globalR! + 5) * yDistance / speaceWidth);
    }
  }

  /// 绘制饼状图途中周围显示的尖角标签 结束
}
