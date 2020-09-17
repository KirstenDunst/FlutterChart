/*
 * @Author: Cao Shixin
 * @Date: 2020-05-27 11:33:43
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-07-31 18:58:51
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class ChartCurvePage extends StatefulWidget {
  static const String routeName = 'chart_curve';
  static const String title = '平滑曲线带填充颜色';
  @override
  _ChartCurveState createState() => _ChartCurveState();
}

class _ChartCurveState extends State<ChartCurvePage> {
  ChartBeanSystem _chartBeanSystem;

  @override
  void initState() {
    _chartBeanSystem = ChartBeanSystem(
      xTitleStyle: TextStyle(color: Colors.grey, fontSize: 12),
      isDrawX: true,
      lineWidth: 2,
      pointRadius: 0,
      isCurve: true,
      chartBeans: [
        ChartBean(x: '12-01', y: 30),
        ChartBean(x: '12-02', y: 88),
        ChartBean(x: '12-03', y: 20),
        ChartBean(x: '12-04', y: 67),
        ChartBean(x: '12-05', y: 10),
        ChartBean(x: '12-06', y: 40),
        ChartBean(x: '12-07', y: 10),
      ],
      shaderColors: [
        Colors.blueAccent.withOpacity(0.3),
        Colors.blueAccent.withOpacity(0.1)
      ],
      lineColor: Colors.blue,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ChartCurvePage.title),
      ),
      body: _buildChartCurve(context),
    );
  }

  ///curve
  Widget _buildChartCurve(context) {
    var chartLine = ChartLine(
      chartBeanSystems: [_chartBeanSystem],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.6),
      xColor: Colors.white,
      yColor: Colors.white,
      yDialValues: [
        DialStyle(
          title: '0',
          titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
          positionRetioy: 0 / 100.0,
        ),
        DialStyle(
          title: '35',
          titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
          positionRetioy: 35 / 100.0,
        ),
        DialStyle(
          title: '65',
          titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
          positionRetioy: 65 / 100.0,
        ),
        DialStyle(
          title: '100',
          titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
          positionRetioy: 100 / 100.0,
        )
      ],
      yMax: 100,
      isShowHintY: true,
      hintLineSolid: false,
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.green.withOpacity(0.5),
      child: chartLine,
      clipBehavior: Clip.antiAlias,
    );
  }
}
