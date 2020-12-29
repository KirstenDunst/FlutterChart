/*
 * @Author: Cao Shixin
 * @Date: 2020-05-27 11:33:23
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-12-29 10:53:57
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class ChartBarRoundPage extends StatefulWidget {
  static const String routeName = 'chart_bar_round';
  static const String title = '柱状图自定义弧角';
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
          ChartBarBeanX(
              title: '12-01',
              titleStyle: TextStyle(color: Colors.white, fontSize: 10),
              value: 30,
              gradualColor: [Colors.red, Colors.red]),
          ChartBarBeanX(
              title: '12-02',
              titleStyle: TextStyle(color: Colors.white, fontSize: 10),
              value: null,
              gradualColor: [Colors.yellow, Colors.yellow]),
          ChartBarBeanX(
              title: '12-03',
              titleStyle: TextStyle(color: Colors.white, fontSize: 10),
              value: 0.0,
              gradualColor: [Colors.green, Colors.green]),
          ChartBarBeanX(
              title: '12-04',
              titleStyle: TextStyle(color: Colors.white, fontSize: 10),
              value: 70.1,
              gradualColor: [Colors.blue, Colors.blue]),
          ChartBarBeanX(
              title: '12-05',
              titleStyle: TextStyle(color: Colors.white, fontSize: 10),
              value: 30,
              gradualColor: [Colors.deepPurple, Colors.deepPurple]),
          ChartBarBeanX(
              title: '12-06',
              titleStyle: TextStyle(color: Colors.white, fontSize: 10),
              value: 90,
              gradualColor: [Colors.deepOrange, Colors.deepOrange]),
          ChartBarBeanX(
              title: '12-07',
              titleStyle: TextStyle(color: Colors.white, fontSize: 10),
              value: 50,
              gradualColor: [Colors.greenAccent, Colors.greenAccent]),
          ChartBarBeanX(
              title: '12-08',
              titleStyle: TextStyle(color: Colors.white, fontSize: 10),
              value: 10,
              gradualColor: [Colors.greenAccent, Colors.greenAccent]),
          ChartBarBeanX(
              title: '12-09',
              titleStyle: TextStyle(color: Colors.red, fontSize: 10),
              value: 10,
              gradualColor: [
                Colors.greenAccent.withOpacity(0.2),
                Colors.greenAccent
              ])
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
                positionRetioy: 35 / 100),
            DialStyleY(
                title: '',
                titleStyle: TextStyle(color: Colors.lightBlue, fontSize: 10),
                centerSubTitle: '',
                centerSubTextStyle: TextStyle(color: Colors.red, fontSize: 10),
                positionRetioy: 0 / 100)
          ],
          isLeftYDialSub: false,
          isShowHintX: true,
          isHintLineImaginary: true,
          xColor: Colors.cyan,
          yColor: Colors.cyan,
          yMax: 100.0,
        ),
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height / 5 * 1.8),
        rectTopTextStyle: TextStyle(color: Colors.white, fontSize: 12),
        rectWidth: 50.0,
        borderRadius: BorderRadius.circular(4));
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.brown.withOpacity(0.6),
      child: chartBar,
      clipBehavior: Clip.none,
    );
  }
}
