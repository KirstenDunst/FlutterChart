/*
 * @Author: Cao Shixin
 * @Date: 2020-05-27 11:33:23
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-06-29 10:17:43
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class ChartBarRoundPage extends StatefulWidget {
  static const String routeName = 'chart_bar_round';
  static const String title = '柱状图顶部自定义弧角';
  @override
  _ChartBarRoundState createState() => _ChartBarRoundState();
}

class _ChartBarRoundState extends State<ChartBarRoundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ChartBarRoundPage.title),
      ),
      body: _buildChartBarRound(context),
    );
  }

  ///bar-round
  Widget _buildChartBarRound(context) {
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
      rectRadiusTopLeft: 4,
      rectRadiusTopRight: 4,
      offsetLeftX: 16.0,
      duration: Duration(milliseconds: 1000),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.brown.withOpacity(0.6),
      child: chartBar,
      clipBehavior: Clip.antiAlias,
    );
  }
}
