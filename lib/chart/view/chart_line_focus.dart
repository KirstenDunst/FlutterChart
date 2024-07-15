/*
 * @Author: Cao Shixin
 * @Date: 2020-03-29 10:26:09
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2022-06-23 13:38:08
 * @Description: 绘制承载区, 支持多个不同曲线的绘制
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/material.dart';
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
  //y轴区间带（不用的话不用设置）
  final List<SectionBeanY>? ySectionBeans;
  final BaseBean? baseBean;
  final int xMax;
  //触摸参数设置,某个线条开启&这个参数设置  约束开启可点击功能
  final FocusLineTouchSet? touchSet;
  //内容绘制结束
  final VoidCallback? paintEnd;
  //可点击选中的时候是否支持横向推拽选中,默认true, 当需要长按触发滑动选中的时候设置为false(场景:外部可缩放,滚动的时候和内部的手势冲突问题)
  final bool touchEnableNormalselect;
  //缩放回传(由于缩放对数据的处理需要自由度更大一些,所以手势参数外传,外部设置)
  final GestureScaleUpdateCallback? onScaleUpdate;
  final GestureScaleStartCallback? onScaleStart;
  final GestureScaleEndCallback? onScaleEnd;

  const ChartLineFocus({
    Key? key,
    required this.size,
    required this.focusChartBeans,
    this.backgroundColor,
    this.xDialValues,
    this.baseBean,
    this.xSectionBeans,
    this.ySectionBeans,
    this.xMax = 60,
    this.touchSet,
    this.paintEnd,
    this.touchEnableNormalselect = true,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
  }) : super(key: key);

  @override
  ChartLineFocusState createState() => ChartLineFocusState();
}

class ChartLineFocusState extends State<ChartLineFocus>
    with SingleTickerProviderStateMixin {
  late bool _isCanTouch;
  TouchModel? _lastTouchModel;
  ChartLineFocusPainter? _painter;

  @override
  void initState() {
    super.initState();
    //点击目前只能是一次性设置，外部数据变化，不会变更内部的点击功能，
    _isCanTouch = false;
    for (var item in widget.focusChartBeans) {
      if (item.touchEnable && widget.touchSet != null) {
        _isCanTouch = true;
        break;
      }
    }
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
    var painter = ChartLineFocusPainter(widget.focusChartBeans,
        xDialValues: widget.xDialValues,
        xSectionBeans: widget.xSectionBeans,
        ySectionBeans: widget.ySectionBeans,
        pointSet: widget.touchSet?.pointSet ?? CellPointSet.normal,
        touchLocalPosition:
            (_lastTouchModel != null && _lastTouchModel!.offset != null)
                ? _lastTouchModel!.offset
                : null,
        xMax: widget.xMax,
        paintEnd: widget.paintEnd)
      //不和initstate统一设置，是为了放置外部setstate，变换坐标轴设置，内部不刷新问题。
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

  void _dealTouchPoint(ChartLineFocusPainter painter, Offset touchOffset) {
    var tempModel = painter.getNearbyPoint(touchOffset,
        outsidePointClear: widget.touchSet?.outsidePointClear ?? true);
    if (tempModel.needRefresh &&
        (_lastTouchModel == null ||
            (_lastTouchModel!.offset != tempModel.offset))) {
      if (widget.touchSet!.touchBack != null) {
        widget.touchSet!.touchBack!(tempModel.offset, tempModel.touchBackValue);
      }
      _lastTouchModel = tempModel;
      setState(() {});
    }
  }
}
