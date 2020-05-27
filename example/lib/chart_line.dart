/*
 * @Author: Cao Shixin
 * @Date: 2020-05-27 11:34:05
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-05-27 13:43:52
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart/flutter_chart.dart';

class ChartLinePage extends StatefulWidget {
  static const String routeName = 'chart_line';
  @override
  _ChartLineState createState() => _ChartLineState();
}

class _ChartLineState extends State<ChartLinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('折线带填充颜色'),
      ),
      body: _buildChartLine(context),
    );
  }

  ///line
  Widget _buildChartLine(context) {
    var chartLine = ChartLine(
      chartBeans: [
        ChartBean(x: '12-01', y: 30),
        ChartBean(x: '12-02', y: 88),
        ChartBean(x: '12-03', y: 20),
        ChartBean(x: '12-04', y: 67),
        ChartBean(x: '12-05', y: 10),
        ChartBean(x: '12-06', y: 40),
        ChartBean(x: '12-07', y: 10),
      ],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.6),
      isCurve: false,
      lineWidth: 2,
      lineColor: Colors.yellow,
      fontColor: Colors.white,
      xyColor: Colors.white,
      shaderColors: [
        Colors.yellow.withOpacity(0.3),
        Colors.yellow.withOpacity(0.1)
      ],
      fontSize: 12,
      yNum: 8,
      isAnimation: true,
      isReverse: false,
      isCanTouch: true,
      isShowPressedHintLine: true,
      pressedPointRadius: 4,
      pressedHintLineWidth: 0.5,
      pressedHintLineColor: Colors.white,
      duration: Duration(milliseconds: 2000),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.yellow.withOpacity(0.4),
      child: chartLine,
      clipBehavior: Clip.antiAlias,
    );
  }
}
