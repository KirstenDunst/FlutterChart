// 柱状线

import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/painter/chart_line_bar_painter.dart';

import '../base/chart_bean.dart';
import '../bean/chart_bean_bar_line.dart';
import '../bean/chart_bean_bar_line_content.dart';

class ChartLineBar extends StatefulWidget {
  final Size size;
  //绘制的背景色
  final Color? backgroundColor;
  //x轴刻度显示，不传则没有
  final List<DialStyleX>? xDialValues;
  //柱线模型
  final List<ChartLineBarBeanSystem> lineBarSystems;
  final BaseBean? baseBean;
  //点击设置,null的话不会启动点击效果
  final LineBarTouchSet? touchSet;
  // 触摸点在当前段的位置类型
  final PointPositionType pointPositionType;
  //可点击选中的时候是否支持横向推拽选中,默认true, 当需要长按触发滑动选中的时候设置为false(场景:外部可缩放,滚动的时候和内部的手势冲突问题)
  final bool touchEnableNormalselect;
  //缩放回传(由于缩放对数据的处理需要自由度更大一些,所以手势参数外传,外部设置)
  final GestureScaleUpdateCallback? onScaleUpdate;
  final GestureScaleStartCallback? onScaleStart;
  final GestureScaleEndCallback? onScaleEnd;
  const ChartLineBar({
    Key? key,
    required this.size,
    this.xDialValues,
    required this.lineBarSystems,
    this.baseBean,
    this.backgroundColor,
    this.touchSet,
    this.pointPositionType = PointPositionType.left,
    this.touchEnableNormalselect = true,
    this.onScaleUpdate,
    this.onScaleEnd,
    this.onScaleStart,
  }) : super(key: key);

  @override
  State<ChartLineBar> createState() => ChartLineBarState();
}

class ChartLineBarState extends State<ChartLineBar>
    with SingleTickerProviderStateMixin {
  late bool _isCanTouch;
  LineBarTouchBackModel? _lastTouchModel;

  @override
  void initState() {
    super.initState();
    _isCanTouch = widget.touchSet != null;
  }

  //清除点击的点
  void clearTouchPoint() {
    if (_isCanTouch && widget.touchSet!.touchBack != null) {
      widget.touchSet!.touchBack!(null, Size.zero, null);
    }
    _lastTouchModel = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var painter = ChartLineBarPainter(
      widget.lineBarSystems,
      touchLocalPosition:
          (_lastTouchModel != null && _lastTouchModel!.startOffset != null)
              ? _dealPointPosition(
                  _lastTouchModel!.startOffset, _lastTouchModel!.size.width)
              : null,
      xDialValues: widget.xDialValues,
      pointSet: widget.touchSet?.pointSet ?? CellPointSet.normal,
    )..baseBean = widget.baseBean ?? BaseBean(yDialValues: []);
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

  void _dealTouchPoint(ChartLineBarPainter painter, Offset touchOffset) {
    var tempModel = painter.getNearbyPoint(touchOffset,
        defaultCancelTouchChoose: widget.touchSet?.outsidePointClear ?? true);
    if (tempModel.needRefresh &&
        (_lastTouchModel == null ||
            (_lastTouchModel!.startOffset != tempModel.startOffset))) {
      if (widget.touchSet!.touchBack != null) {
        widget.touchSet!.touchBack!(
            _dealPointPosition(tempModel.startOffset, tempModel.size.width),
            tempModel.size,
            tempModel.backParam);
      }
      _lastTouchModel = tempModel;
      setState(() {});
    }
  }

  Offset? _dealPointPosition(Offset? startOffset, double sizeWidth) {
    if (startOffset == null) {
      return null;
    }
    var back = startOffset;
    switch (widget.pointPositionType) {
      case PointPositionType.left:
        back += Offset.zero;
        break;
      case PointPositionType.center:
        back += Offset(sizeWidth / 2, 0);
        break;
      case PointPositionType.right:
        back += Offset(sizeWidth, 0);
        break;
    }
    return back;
  }
}

//触摸点在当前段的位置类型
enum PointPositionType {
  //左侧
  left,
  //中间
  center,
  //右侧
  right
}
