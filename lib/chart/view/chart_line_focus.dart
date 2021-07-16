/*
 * @Author: Cao Shixin
 * @Date: 2020-03-29 10:26:09
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-12-29 10:44:33
 * @Description: 绘制承载区, 支持多个不同曲线的绘制
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_focus.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_focus_content.dart';
import 'package:flutter_chart_csx/chart/painter/chart_line_focus_painter.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class ChartLineFocus extends StatefulWidget {
  //内容宽高
  final Size size;
  //绘制的内容背景色
  final Color? backgroundColor;
  final List<FocusChartBeanMain> focusChartBeans;
  //x轴刻度显示，不传则没有
  final List<DialStyleX>? xDialValues;
  //x轴的区间带（不用的话不用设置）
  final List<SectionBean>? xSectionBeans;
  final BaseBean? baseBean;
  final int? xMax;
  //触摸参数设置
  //触摸辅助线是否为虚线
  final bool isPressedHintDottedLine;
  //触摸点半径，大于[W]的时候会默认W的宽度
  final double pressedPointRadius;
  //触摸辅助线宽度
  final double pressedHintLineWidth;
  //触摸辅助线颜色
  final Color? pressedHintLineColor;
  //触摸回调
  final PressPointBack? pointBack;

  const ChartLineFocus({
    Key? key,
    required this.size,
    required this.focusChartBeans,
    this.backgroundColor,
    this.xDialValues,
    this.baseBean,
    this.xSectionBeans,
    this.isPressedHintDottedLine = true,
    this.pressedPointRadius = 4,
    this.pressedHintLineWidth = 1,
    this.pressedHintLineColor,
    this.xMax,
    this.pointBack,
  })  : assert(size != null),
        super(key: key);

  @override
  ChartLineFocusState createState() => ChartLineFocusState();
}

class ChartLineFocusState extends State<ChartLineFocus>
    with SingleTickerProviderStateMixin {
  Offset? localPosition;
  late bool isCanTouch;
  late FocusChartBeanMain firstCanTouchBean;
  late TouchModel _lastTouchModel;

  @override
  void initState() {
    isCanTouch = false;
    try {
      for (var item in widget.focusChartBeans) {
        if (item.touchEnable) {
          isCanTouch = true;
          firstCanTouchBean = item;
          break;
        }
      }
      // ignore: empty_catches
    } catch (e) {}
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (isCanTouch && widget.pointBack != null) {
        //如果可点击，默认显示第一个元素，如果没有
        var chartBeanFocus = firstCanTouchBean.chartBeans!.first;
        var _startY = widget.size.height - widget.baseBean!.basePadding.bottom;
        var _endY = widget.baseBean!.basePadding.top;
        var yValue = chartBeanFocus.second == 0 ? chartBeanFocus.focus : 0;
        var value =
            chartBeanFocus.second == 0 ? chartBeanFocus.touchBackValue : null;
        var currentY =
            (_startY - ((yValue / widget.baseBean!.yMax) * (_startY - _endY)));
        if (currentY < _endY) {
          currentY = _endY;
        }
        localPosition = Offset(widget.baseBean!.basePadding.left, currentY);
        _lastTouchModel =
            TouchModel(offset: localPosition, touchBackValue: value);
        widget.pointBack!(localPosition, value);
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var painter = ChartLineFocusPainter(widget.focusChartBeans,
        xDialValues: widget.xDialValues,
        xSectionBeans: widget.xSectionBeans,
        isPressedHintDottedLine: widget.isPressedHintDottedLine,
        pressedHintLineColor: widget.pressedHintLineColor,
        pressedHintLineWidth: widget.pressedHintLineWidth,
        pressedPointRadius: widget.pressedPointRadius,
        touchLocalPosition: localPosition,
        xMax: widget.xMax);
    painter..baseBean = widget.baseBean;
    if (isCanTouch) {
      return GestureDetector(
        onTapDown: (details) {
          var tempModel = painter.getNearbyPoint(details.localPosition)!;
          if (_lastTouchModel.offset != tempModel.offset) {
            if (widget.pointBack != null) {
              widget.pointBack!(tempModel.offset, tempModel.touchBackValue);
            }
            setState(() {
              _lastTouchModel = tempModel;
              localPosition = tempModel.offset;
            });
          }
        },
        onHorizontalDragUpdate: (details) {
          var tempModel = painter.getNearbyPoint(details.localPosition)!;
          if (_lastTouchModel.offset != tempModel.offset) {
            if (widget.pointBack != null) {
              widget.pointBack!(tempModel.offset, tempModel.touchBackValue);
            }
            setState(() {
              _lastTouchModel = tempModel;
              localPosition = tempModel.offset;
            });
          }
        },
        // onTapCancel: () async {
        //   await Future.delayed(Duration(milliseconds: 800)).then((_) {
        //     if (widget.pointBack != null) {
        //       widget.pointBack(null, '');
        //     }
        //     setState(() {
        //       localPosition = null;
        //     });
        //   });
        // },
        child: CustomPaint(
          size: widget.size,
          painter: widget.backgroundColor == null ? painter : null,
          foregroundPainter: widget.backgroundColor != null ? painter : null,
          child: widget.backgroundColor != null
              ? Container(
                  width: widget.size.width,
                  height: widget.size.height,
                  color: widget.backgroundColor,
                )
              : null,
        ),
      );
    } else {
      return CustomPaint(
        size: widget.size,
        painter: widget.backgroundColor == null ? painter : null,
        foregroundPainter: widget.backgroundColor != null ? painter : null,
        child: widget.backgroundColor != null
            ? Container(
                width: widget.size.width,
                height: widget.size.height,
                color: widget.backgroundColor,
              )
            : null,
      );
    }
  }
}
