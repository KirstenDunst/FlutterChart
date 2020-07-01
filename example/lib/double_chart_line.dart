/*
 * @Author: Cao Shixin
 * @Date: 2020-05-27 11:34:30
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-06-29 10:19:09
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart/flutter_chart.dart';

class DoubleChartlinePage extends StatefulWidget {
  static const String routeName = 'double_chart_line';
  static const String title = '双折线';
  @override
  _DoubleChartlineState createState() => _DoubleChartlineState();
}

class _DoubleChartlineState extends State<DoubleChartlinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DoubleChartlinePage.title),
      ),
      body: _buildDoubleChartLine(context),
    );
  }

  Widget _buildDoubleChartLine(context) {
    var chartLine = ChartLine(
      chartBeans: [
        ChartBean(x: '3-01', y: 30, subY: 70),
        ChartBean(x: '3-02', y: 88, subY: 20),
        ChartBean(x: '3-03', y: 20, subY: 30),
        ChartBean(x: '3-04', y: 67, subY: 50),
        ChartBean(x: '3-05', y: 10, subY: 100),
        ChartBean(x: '3-06', y: 40, subY: 30),
        ChartBean(x: '3-07', y: 10, subY: 0),
      ],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.6),
      isCurve: false,
      lineWidth: 2,
      lineColor: Colors.cyan,
      subLineColor: Colors.red,
      fontColor: Colors.white,
      xyColor: Colors.white,
      fontSize: 12,
      yNum: 5,
      isAnimation: true,
      isReverse: false,
      isCanTouch: true,
      isShowPressedHintLine: true,
      isShowHintX: true,
      pressedPointRadius: 4,
      pressedHintLineWidth: 0.5,
      pressedHintLineColor: Colors.white,
      duration: Duration(milliseconds: 2000),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.blue.withOpacity(0.4),
      child: chartLine,
      clipBehavior: Clip.antiAlias,
    );
  }
}
