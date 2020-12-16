/*
 * @Author: Cao Shixin
 * @Date: 2020-07-17 17:38:11
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2020-11-09 16:35:16
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_dimensionality.dart';
import 'package:flutter_chart_csx/chart/painter/chart_dimensionality_painter.dart';

class ChartDimensionality extends StatefulWidget {
  final List<ChartBeanDimensionality> dimensionalityDivisions; //维度划分的重要参数
  final List<DimensionalityBean> dimensionalityTags; //维度填充数据的重要内容
  final Size size; //宽高
  final double lineWidth; //线宽
  final bool isDotted; //背景网是否为虚线
  final Color lineColor; //线条颜色
  final double centerR; //圆半径
  final int dimensionalityNumber; //阶层：维度图从中心到最外层有几圈

  final Color backgroundColor; //绘制的背景色

  const ChartDimensionality({
    Key key,
    @required this.size,
    @required this.dimensionalityDivisions,
    this.dimensionalityTags,
    this.lineWidth = 4,
    this.isDotted = false,
    this.lineColor,
    this.centerR,
    this.dimensionalityNumber = 4,
    this.backgroundColor,
  })  : assert(dimensionalityDivisions != null &&
            dimensionalityDivisions.length > 2),
        assert(size != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => ChartDimensionalityState();
}

class ChartDimensionalityState extends State<ChartDimensionality>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var painter = ChartDimensionalityPainter(
      widget.dimensionalityDivisions,
      dimensionalityTags: widget.dimensionalityTags,
      lineColor: widget.lineColor,
      lineWidth: widget.lineWidth,
      isDotted: widget.isDotted,
      centerR: widget.centerR,
      dimensionalityNumber: widget.dimensionalityNumber,
    );

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
