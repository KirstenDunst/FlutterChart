/*
 * @Author: Cao Shixin
 * @Date: 2020-05-27 11:34:05
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2020-11-09 17:33:14
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class ChartLinePage extends StatefulWidget {
  static const String routeName = 'chart_line';
  static const String title = '折线带填充颜色';
  @override
  _ChartLineState createState() => _ChartLineState();
}

class _ChartLineState extends State<ChartLinePage> {
  ChartBeanSystem _chartLineBeanSystem;

  @override
  void initState() {
    _chartLineBeanSystem = ChartBeanSystem(
      xTitleStyle: TextStyle(color: Colors.grey, fontSize: 12),
      isDrawX: true,
      lineWidth: 2,
      pointRadius: 0,
      isCurve: false,
      chartBeans: [
        ChartLineBean(x: '12-01', y: 30),
        ChartLineBean(x: '12-02', y: 88),
        ChartLineBean(x: '12-03', y: 20),
        ChartLineBean(x: '12-04', y: 67),
        ChartLineBean(x: '12-05', y: 10),
        ChartLineBean(x: '12-06', y: 40),
        ChartLineBean(x: '12-07', y: 10),
      ],
      shaderColors: [
        Colors.blue.withOpacity(0.3),
        Colors.blue.withOpacity(0.1)
      ],
      lineColor: Colors.red,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ChartLinePage.title),
      ),
      body: _buildChartLine(context),
    );
  }

  ///line
  Widget _buildChartLine(context) {
    var chartLine = ChartLine(
      chartBeanSystems: [_chartLineBeanSystem],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.6),
      baseBean: BaseBean(
        xColor: Colors.black,
        yColor: Colors.white,
        yDialValues: [
          DialStyleY(
            title: '0',
            titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
            positionRetioy: 0 / 100.0,
          ),
          DialStyleY(
            title: '35',
            titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
            positionRetioy: 35 / 100.0,
          ),
          DialStyleY(
            title: '65',
            titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
            positionRetioy: 65 / 100.0,
          ),
          DialStyleY(
            title: '100',
            titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
            positionRetioy: 100 / 100.0,
          )
        ],
        yMax: 100,
        isShowHintX: true,
        isHintLineImaginary: true,
      ),
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
