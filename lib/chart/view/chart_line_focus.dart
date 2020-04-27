import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/bean/chart_bean_focus.dart';
import 'package:flutter_chart/chart/painter/chart_line_focus_painter.dart';
import 'package:flutter_chart/flutter_chart.dart';

class ChartLineFocus extends StatefulWidget {
  final Size size; //内容宽高
  final Color backgroundColor; //绘制的内容背景色
  final double lineWidth; //曲线或折线的线宽
  final Color lineColor; //曲线或折线的颜色
  final List<ChartBeanFocus> chartBeans;//默认数据源按照y轴向上为正方向，如果需求反向，那么数据源也需自行做反向处理
  final bool isLinkBreak;//beans的时间轴如果断开，true： 是继续上一个有数值的值绘制，还是 false：断开。按照多条绘制
  final Color xyColor; //xy轴的颜色
  final bool isShowHintX, isShowHintY; //是否显示x、y轴的辅助线
  final Color hintLineColor; //辅助线颜色
  final bool isHintLineImaginary; //辅助线是否为虚线,默认实线
  final bool isShowBorderTop, isShowBorderRight; //是否显示顶部和右侧的辅助线
  final List<DialStyle> xDialValues;//x轴刻度显示，不传则没有
  final CenterSubTitlePosition centerSubTitlePosition;//解释文案的显示与否位置
  final List<DialStyle> yDialValues;//y轴左侧刻度显示，不传则没有
  final List<Color> gradualColors;//渐变颜色。不设置的话默认按照解释文案的分层显示，如果设置，即为整体颜色渐变显示
  final int xMax; //x轴最大值（以秒为单位）
  final double yMax; //y轴最大值
  final VoidCallback canvasEnd;//绘制结束提醒。会比多一秒（例如设置60秒，走到61秒才会触发）
  final double basePadding; //默认的边距16

  const ChartLineFocus({
    Key key,
    @required this.size,
    this.chartBeans,
    this.isLinkBreak = false,
    @required this.canvasEnd,
    this.lineWidth = 4,
    this.lineColor,
    this.hintLineColor,
    this.isHintLineImaginary,
    this.xyColor,
    this.backgroundColor,
    this.isShowHintX = false,
    this.isShowHintY = false,
    this.isShowBorderTop = false,
    this.isShowBorderRight = false,
    this.xDialValues,
    this.centerSubTitlePosition,
    this.yDialValues,
    this.yMax,
    this.xMax,
    this.gradualColors,
    this.basePadding = 16,
  })  : assert(lineColor != null),
        assert(size != null),
        super(key: key);

  @override
  ChartLineFocusState createState() => ChartLineFocusState();
}

class ChartLineFocusState extends State<ChartLineFocus>
    with SingleTickerProviderStateMixin {
  List<ChartBeanFocus> chartBeanList;
  
  void changeBeanList(List<ChartBeanFocus> beans) {
    setState(() {
      chartBeanList = beans;
    });
  }

  @override
  void initState() {
    super.initState();
    chartBeanList = widget.chartBeans;
  }

  @override
  Widget build(BuildContext context) {
    var painter = ChartLineFocusPainter(chartBeanList, widget.isLinkBreak, widget.lineColor,
        lineWidth: widget.lineWidth,
        xyColor: widget.xyColor,
        isShowHintX: widget.isShowHintX,
        isShowHintY: widget.isShowHintY,
        xDialValues: widget.xDialValues,
        centerSubTitlePosition: widget.centerSubTitlePosition,
        yDialValues: widget.yDialValues,
        yMax: widget.yMax,
        xMax: widget.xMax,
        gradualColors: widget.gradualColors,
        isHintLineImaginary: widget.isHintLineImaginary,
        hintLineColor: widget.hintLineColor,
        basePadding: widget.basePadding,
        canvasEnd: widget.canvasEnd);

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
