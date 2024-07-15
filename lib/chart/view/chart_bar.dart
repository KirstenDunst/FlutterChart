/*
 * @Author: your name
 * @Date: 2020-09-29 13:25:19
 * @LastEditTime: 2022-01-21 14:03:11
 * @LastEditors: Cao Shixin
 * @Description: In User Settings Edit
 * @FilePath: /flutter_chart/lib/chart/view/chart_bar.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_bar.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_bar_content.dart';
import 'package:flutter_chart_csx/chart/painter/chart_bar_painter.dart';

class ChartBar extends StatefulWidget {
  // 动画的时长，默认不设置表示没有动画
  final Duration? duration;
  final Size size;
  //绘制的背景色
  final Color? backgroundColor;
  //x轴刻度显示，不传则没有
  final List<ChartBarBeanX> xDialValues;
  //基准y值(影响柱体正向增长(大于基准线)还是反向增长(小于基准线))，
  //不设置表示从x轴向上增长
  final double? baseLineY;
  final BaseBean? baseBean;
  //柱状图的宽度
  final double rectWidth;
  //柱体之间的间距,默认5
  final double rectSpace;
  //点击设置,null的话不会启动点击效果
  final TouchSet? touchSet;
  //可点击选中的时候是否支持横向推拽选中,默认true, 当需要长按触发滑动选中的时候设置为false(场景:外部可缩放,滚动的时候和内部的手势冲突问题)
  final bool touchEnableNormalselect;
  //缩放回传(由于缩放对数据的处理需要自由度更大一些,所以手势参数外传,外部设置)
  final GestureScaleUpdateCallback? onScaleUpdate;
  final GestureScaleStartCallback? onScaleStart;
  final GestureScaleEndCallback? onScaleEnd;

  const ChartBar({
    Key? key,
    required this.size,
    required this.xDialValues,
    this.baseLineY,
    this.duration,
    this.baseBean,
    this.backgroundColor,
    this.rectWidth = 20,
    this.rectSpace = 5,
    this.touchSet,
    this.touchEnableNormalselect = true,
    this.onScaleUpdate,
    this.onScaleEnd,
    this.onScaleStart,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChartBarState();
}

class ChartBarState extends State<ChartBar>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  double _value = 0;
  late bool _isCanTouch;
  int? _selectIndex;
  TouchBackModel? _lastTouchModel;

  @override
  void initState() {
    super.initState();
    if (widget.duration != null) {
      _controller = AnimationController(vsync: this, duration: widget.duration);
      Tween(begin: 0.0, end: 1.0).animate(_controller!)
        ..addListener(() {
          setState(() {
            _value = _controller!.value;
          });
        });
      _controller!.forward();
    } else {
      _value = 1.0;
    }
    _isCanTouch = widget.touchSet != null;
  }

  //清除点击的点
  void clearTouchPoint() {
    if (_isCanTouch && widget.touchSet!.touchBack != null) {
      widget.touchSet!.touchBack!(null, Size.zero, null);
    }
    _lastTouchModel = null;
    _selectIndex = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var painter = ChartBarPainter(widget.xDialValues,
        value: _value,
        rectWidth: widget.rectWidth,
        baseLineY: widget.baseLineY,
        rectSpace: widget.rectSpace,
        selectIndex: _selectIndex,
        selectModelSet: widget.touchSet?.selelctSet)
      ..baseBean = widget.baseBean ?? BaseBean(yDialValues: []);
    if (_isCanTouch) {
      return Listener(
        onPointerDown: (details) =>
            _dealTouchPoint(painter, details.localPosition),
        onPointerMove: widget.touchEnableNormalselect == true
            ? (details) => _dealTouchPoint(painter, details.localPosition)
            : null,
        child: GestureDetector(
          onScaleUpdate: widget.onScaleUpdate,
          onScaleEnd: widget.onScaleEnd,
          onScaleStart: widget.onScaleStart,
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
          foregroundPainter: widget.backgroundColor != null ? painter : null,
          child: widget.backgroundColor != null
              ? Container(
                  width: widget.size.width,
                  height: widget.size.height,
                  color: widget.backgroundColor,
                )
              : null,
          painter: widget.backgroundColor == null ? painter : null);
    }
  }

  void _dealTouchPoint(ChartBarPainter painter, Offset touchOffset) {
    var tempModel = painter.getNearbyPoint(touchOffset,
        defaultCancelTouchChoose: widget.touchSet?.outsidePointClear ?? true);
    if (tempModel.needRefresh &&
        (_lastTouchModel == null ||
            (_lastTouchModel!.startOffset != tempModel.startOffset))) {
      if (widget.touchSet!.touchBack != null) {
        widget.touchSet!.touchBack!(
            tempModel.startOffset, tempModel.size, tempModel.backParam);
      }
      _lastTouchModel = tempModel;
      _selectIndex = tempModel.index;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
