/*
 * @Author: your name
 * @Date: 2020-10-14 13:06:15
 * @LastEditTime: 2022-07-29 09:22:29
 * @LastEditors: Cao Shixin
 * @Description: In User Settings Edit
 * @FilePath: /flutter_chart/lib/chart/view/chart_line.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_focus.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_line.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_line_content.dart';
import 'package:flutter_chart_csx/chart/painter/chart_line_painter.dart';

class ChartLine extends StatefulWidget {
  //宽高
  final Size size;
  //绘制的背景色
  final Color? backgroundColor;
  final BaseBean? baseBean;
  //起始和结束距离两端y轴的单侧间距。默认无间距
  final double bothEndPitchX;
  //绘制线条的参数内容
  final List<ChartBeanSystem> chartBeanSystems;
  //x轴刻度显示，不传则没有
  final List<DialStyleX>? xDialValues;
  //x轴的区间带（不用的话不用设置）
  final List<SectionBean>? xSectionBeans;
  //y轴区间带（不用的话不用设置）
  final List<SectionBeanY>? ySectionBeans;
  //可点击参数设置，不设置表示不支持点击选中最近点功能
  final LineTouchSet? touchSet;
  //内容绘制结束
  final VoidCallback? paintEnd;
  //可点击选中的时候是否支持横向推拽选中,默认true, 当需要长按触发滑动选中的时候设置为false(场景:外部可缩放,滚动的时候和内部的手势冲突问题)
  final bool touchEnableNormalselect;
  //缩放回传(由于缩放对数据的处理需要自由度更大一些,所以手势参数外传,外部设置)
  final GestureScaleUpdateCallback? onScaleUpdate;
  final GestureScaleStartCallback? onScaleStart;
  final GestureScaleEndCallback? onScaleEnd;

  const ChartLine({
    Key? key,
    required this.size,
    required this.chartBeanSystems,
    this.backgroundColor,
    this.baseBean,
    this.bothEndPitchX = 0,
    this.xDialValues,
    this.xSectionBeans,
    this.ySectionBeans,
    this.touchSet,
    this.paintEnd,
    this.touchEnableNormalselect = true,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChartLineState();
}

class ChartLineState extends State<ChartLine>
    with SingleTickerProviderStateMixin {
  late bool _isCanTouch;
  LineTouchBackModel? _lastTouchModel;
  ChartLinePainter? _painter;

  @override
  void initState() {
    super.initState();
    _isCanTouch = widget.touchSet != null;
  }

  //清除点击的点
  void clearTouchPoint() {
    if (_isCanTouch && widget.touchSet!.touchBack != null) {
      widget.touchSet!.touchBack!(null, null);
    }
    _lastTouchModel = null;
    setState(() {});
  }

  //根据tag查找到点的回传
  TagSearchedModel? searchWithTag(String tag) {
    if (_painter == null) {
      return null;
    } else {
      var result = _painter!.getDetailWithTag(tag);
      return result;
    }
  }

  @override
  Widget build(BuildContext context) {
    var painter = ChartLinePainter(widget.chartBeanSystems,
        bothEndPitchX: widget.bothEndPitchX,
        touchLocalPosition:
            (_lastTouchModel != null && _lastTouchModel!.startOffset != null)
                ? _lastTouchModel!.startOffset
                : null,
        xDialValues: widget.xDialValues,
        xSectionBeans: widget.xSectionBeans,
        ySectionBeans: widget.ySectionBeans,
        pointSet: widget.touchSet?.pointSet ?? CellPointSet.normal,
        paintEnd: widget.paintEnd)
      ..baseBean = widget.baseBean ?? BaseBean(yDialValues: []);
    _painter = painter;
    if (_isCanTouch) {
      return Listener(
        onPointerDown: (details) =>
            _dealTouchPoint(painter, details.localPosition),
        onPointerMove: widget.touchEnableNormalselect == true
            ? (details) => _dealTouchPoint(painter, details.localPosition)
            : null,
        child: GestureDetector(
          onScaleEnd: widget.onScaleEnd,
          onScaleStart: widget.onScaleStart,
          onScaleUpdate: widget.onScaleUpdate,
          onLongPressMoveUpdate: (details) =>
              _dealTouchPoint(painter, details.localPosition),
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

  void _dealTouchPoint(ChartLinePainter painter, Offset touchOffset) {
    var tempModel = painter.getNearbyPoint(touchOffset,
        outsidePointClear: widget.touchSet?.outsidePointClear ?? true);
    if (tempModel.needRefresh &&
        (_lastTouchModel == null ||
            (_lastTouchModel!.startOffset != tempModel.startOffset))) {
      if (widget.touchSet!.touchBack != null) {
        widget.touchSet!.touchBack!(tempModel.startOffset, tempModel.backParam);
      }
      _lastTouchModel = tempModel;
      setState(() {});
    }
  }
}
