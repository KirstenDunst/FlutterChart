/*
 * @Author: Cao Shixin
 * @Date: 2020-05-27 11:32:05
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2020-11-09 17:29:55
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */

import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class ChartBarCirclePage extends StatefulWidget {
  static const String routeName = 'chart_bar_circle';
  static const String title = '柱状顶部半圆型';
  @override
  _ChartBarCircleState createState() => _ChartBarCircleState();
}

class _ChartBarCircleState extends State<ChartBarCirclePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ChartBarCirclePage.title),
      ),
      body: _buildChartBarCircle(context),
    );
  }

  ///bar-circle
  Widget _buildChartBarCircle(context) {
    var chartBar = ChartBar(
      xDialValues: [
        ChartBarBeanX(
            title: '12-01', value: 30, gradualColor: [Colors.red, Colors.red]),
        ChartBarBeanX(
            title: '12-02',
            value: 100,
            gradualColor: [Colors.yellow, Colors.yellow]),
        ChartBarBeanX(
            title: '12-03',
            value: 70,
            gradualColor: [Colors.green, Colors.green]),
        ChartBarBeanX(
            title: '12-04',
            value: 70,
            gradualColor: [Colors.blue, Colors.blue]),
        ChartBarBeanX(
            title: '12-05',
            value: 30,
            gradualColor: [Colors.deepPurple, Colors.deepPurple]),
        ChartBarBeanX(
            title: '12-06',
            value: 90,
            gradualColor: [Colors.deepOrange, Colors.deepOrange]),
        ChartBarBeanX(
            title: '12-07',
            value: 50,
            gradualColor: [Colors.greenAccent, Colors.greenAccent])
      ],
      baseBean: BaseBean(
        yDialValues: [
          DialStyleY(
              title: '100',
              titleStyle: TextStyle(color: Colors.lightBlue, fontSize: 10),
              centerSubTitle: 'Calm',
              centerSubTextStyle: TextStyle(color: Colors.red, fontSize: 10),
              positionRetioy: 100 / 100),
          DialStyleY(
              title: '65',
              titleStyle: TextStyle(color: Colors.lightBlue, fontSize: 10),
              centerSubTitle: 'Aware',
              centerSubTextStyle: TextStyle(color: Colors.red, fontSize: 10),
              positionRetioy: 65 / 100),
          DialStyleY(
              title: '35',
              titleStyle: TextStyle(color: Colors.lightBlue, fontSize: 10),
              centerSubTitle: 'Focused',
              centerSubTextStyle: TextStyle(color: Colors.red, fontSize: 10),
              positionRetioy: 35 / 100)
        ],
        yMax: 100.0,
      ),
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.8),
      rectWidth: 50.0,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50), topRight: Radius.circular(50)),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.blue.withOpacity(0.4),
      child: chartBar,
      clipBehavior: Clip.antiAlias,
    );
  }
}
