/*
 * @Author: Cao Shixin
 * @Date: 2020-05-27 11:32:05
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-05-27 13:42:01
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */

import 'package:flutter/material.dart';
import 'package:flutter_chart/flutter_chart.dart';

class ChartBarCirclePage extends StatefulWidget {
  static const String routeName = 'chart_bar_circle';
  @override
  _ChartBarCircleState createState() => _ChartBarCircleState();
}

class _ChartBarCircleState extends State<ChartBarCirclePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text('柱状顶部半圆型'),
      ),
      body: _buildChartBarCircle(context),
    );
  }

  ///bar-circle
  Widget _buildChartBarCircle(context) {
    var chartBar = ChartBar(
      xDialValues: [
        ChartBeanX(
            title: '12-01', value: 30, gradualColor: [Colors.red, Colors.red]),
        ChartBeanX(
            title: '12-02',
            value: 100,
            gradualColor: [Colors.yellow, Colors.yellow]),
        ChartBeanX(
            title: '12-03',
            value: 70,
            gradualColor: [Colors.green, Colors.green]),
        ChartBeanX(
            title: '12-04',
            value: 70,
            gradualColor: [Colors.blue, Colors.blue]),
        ChartBeanX(
            title: '12-05',
            value: 30,
            gradualColor: [Colors.deepPurple, Colors.deepPurple]),
        ChartBeanX(
            title: '12-06',
            value: 90,
            gradualColor: [Colors.deepOrange, Colors.deepOrange]),
        ChartBeanX(
            title: '12-07',
            value: 50,
            gradualColor: [Colors.greenAccent, Colors.greenAccent])
      ],
      yDialValues: [
        ChartBeanY(
            title: '100',
            titleStyle: TextStyle(color: Colors.lightBlue, fontSize: 10),
            centerSubTitle: 'Calm',
            centerSubTextStyle: TextStyle(color: Colors.red, fontSize: 10),
            positionRetioy: 100 / 100),
        ChartBeanY(
            title: '65',
            titleStyle: TextStyle(color: Colors.lightBlue, fontSize: 10),
            centerSubTitle: 'Aware',
            centerSubTextStyle: TextStyle(color: Colors.red, fontSize: 10),
            positionRetioy: 65 / 100),
        ChartBeanY(
            title: '35',
            titleStyle: TextStyle(color: Colors.lightBlue, fontSize: 10),
            centerSubTitle: 'Focused',
            centerSubTextStyle: TextStyle(color: Colors.red, fontSize: 10),
            positionRetioy: 35 / 100)
      ],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.8),
      isShowX: true,
      yMax: 100.0,
      rectWidth: 50.0,
      fontColor: Colors.white,
      rectShadowColor: Colors.white.withOpacity(0.5),
      isReverse: false,
      isCanTouch: true,
      isShowTouchShadow: true,
      isShowTouchValue: true,
      rectRadiusTopLeft: 50,
      rectRadiusTopRight: 50,
      offsetLeftX: 16.0,
      duration: Duration(milliseconds: 1000),
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
