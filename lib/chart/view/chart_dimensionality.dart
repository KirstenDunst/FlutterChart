/*
 * @Author: Cao Shixin
 * @Date: 2020-07-17 17:38:11
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2022-05-24 15:26:37
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/base/chart_bean.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_dimensionality.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_dimensionality_content.dart';
import 'package:flutter_chart_csx/chart/painter/chart_dimensionality_painter.dart';

class ChartDimensionality extends StatefulWidget {
  //维度划分的重要参数
  final List<ChartBeanDimensionality> dimensionalityDivisions;
  //维度填充数据的重要内容
  final List<DimensionalityBean> dimensionalityTags;
  //宽高
  final Size size;
  //背景设置
  final DimensionBGSet bgSet;
  //圆半径
  final double? centerR;
  final BaseBean? baseBean;
  //绘制的背景色
  final Color? backgroundColor;
  //可点击参数设置，不设置表示不支持点击选中最近点功能
  final DimensionTouchSet? touchSet;

  const ChartDimensionality({
    Key? key,
    required this.size,
    required this.dimensionalityDivisions,
    required this.dimensionalityTags,
    this.bgSet = DimensionBGSet.normal,
    this.centerR,
    this.baseBean,
    this.backgroundColor,
    this.touchSet,
  })  : assert(dimensionalityDivisions.length > 2),
        super(key: key);

  @override
  State<StatefulWidget> createState() => ChartDimensionalityState();
}

class ChartDimensionalityState extends State<ChartDimensionality>
    with SingleTickerProviderStateMixin {
  //选中的维度index。没有点击功能的时候为null，有点击的时候默认index为0
  int? _selectDimensionIndex;
  late bool _isCanTouch;
  DimensionabilityTouchBackModel? _lastTouchModel;
  late ChartDimensionalityPainter _painter;

  @override
  void initState() {
    super.initState();
    _isCanTouch = widget.touchSet != null;
    if (_isCanTouch) {
      _selectDimensionIndex = 0;
    }
  }

  //清除点击的点
  void clearTouchPoint() {
    if (_isCanTouch && widget.touchSet!.touchBack != null) {
      widget.touchSet!.touchBack!(true, null, Size.zero, 0, null);
      _lastTouchModel = null;
      _selectDimensionIndex = null;
      setState(() {});
    }
  }

  /*
   * 切换调整选中维度的状态
   * 如果index超出范围，那么将默认选中范围内的最近维度
   */
  void changeSelectDimension() {
    var nextIndex = (_selectDimensionIndex ?? 0) + 1;
    if (nextIndex >= widget.dimensionalityDivisions.length) {
      nextIndex = 0;
    }
    var tempModel = _painter.getNearbyIndex(nextIndex);
    _dealBack(tempModel, false);
  }

  @override
  Widget build(BuildContext context) {
    var painter = ChartDimensionalityPainter(
      dimensionalityDivisions: widget.dimensionalityDivisions,
      selectDimensionIndex: _selectDimensionIndex,
      dimensionalityTags: widget.dimensionalityTags,
      bgSet: widget.bgSet,
      centerR: widget.centerR,
    )..baseBean = widget.baseBean ?? BaseBean(yDialValues: []);
    _painter = painter;
    if (_isCanTouch) {
      return GestureDetector(
        onTapDown: (details) => _dealTouchPoint(painter, details.localPosition),
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

  void _dealTouchPoint(ChartDimensionalityPainter painter, Offset touchOffset) {
    var tempModel = painter.getNearbyPoint(touchOffset);
    _dealBack(tempModel, true);
  }

  void _dealBack(DimensionabilityTouchBackModel? tempModel, bool isTouch) {
    if (tempModel == null) {
      //不在坐标轴内部的点击
      if (widget.touchSet?.outsidePointClear == true) {
        widget.touchSet!.touchBack!(isTouch, null, Size.zero, 0, null);
        _lastTouchModel = null;
        _selectDimensionIndex = null;
        setState(() {});
      }
      return;
    }
    if (_lastTouchModel == null ||
        (_lastTouchModel!.point != tempModel.point)) {
      if (widget.touchSet!.touchBack != null) {
        widget.touchSet!.touchBack!(isTouch, tempModel.point, tempModel.size,
            tempModel.index, tempModel.param);
      }
      _lastTouchModel = tempModel;
      _selectDimensionIndex = tempModel.index;
      setState(() {});
    }
  }
}
