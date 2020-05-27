/*
 * @Author: Cao Shixin
 * @Date: 2020-05-27 11:34:43
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-05-27 13:44:43
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart/flutter_chart.dart';

class ChartPiePage extends StatefulWidget {
  static const String routeName = 'chart_pie';
  @override
  _ChartPieState createState() => _ChartPieState();
}

class _ChartPieState extends State<ChartPiePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('饼状图'),
      ),
      body: _buildChartPie(context),
    );
  }

  ///pie
  Widget _buildChartPie(context) {
    var chartPie = ChartPie(
      chartBeans: [
        ChartPieBean(
            type: '话费',
            value: 180,
            color: Colors.blueGrey,
            assistTextStyle: TextStyle(fontSize: 12, color: Colors.blueGrey)),
        ChartPieBean(
            type: '零食',
            value: 10,
            color: Colors.deepPurple,
            assistTextStyle: TextStyle(fontSize: 12, color: Colors.deepPurple)),
        ChartPieBean(
            type: '衣服',
            value: 1,
            color: Colors.green,
            assistTextStyle: TextStyle(fontSize: 12, color: Colors.green)),
        ChartPieBean(
            type: '早餐',
            value: 10,
            color: Colors.blue,
            assistTextStyle: TextStyle(fontSize: 12, color: Colors.blue)),
        ChartPieBean(
            type: '水果',
            value: 10,
            color: Colors.red,
            assistTextStyle: TextStyle(fontSize: 12, color: Colors.red)),
        ChartPieBean(
            type: '你猜',
            value: 20,
            color: Colors.orange,
            assistTextStyle: TextStyle(fontSize: 12, color: Colors.red)),
      ],
      assistTextShowType: AssistTextShowType.CenterNamePercentage,
      assistBGColor: Color(0xFFF6F6F6),
      decimalDigits: 1,
      divisionWidth: 2,
      size: Size(
          MediaQuery.of(context).size.width, MediaQuery.of(context).size.width),
      R: MediaQuery.of(context).size.width / 3,
      centerR: 6,
      duration: Duration(milliseconds: 2000),
      centerColor: Colors.white,
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      color: Colors.orangeAccent.withOpacity(0.6),
      clipBehavior: Clip.antiAlias,
      borderOnForeground: true,
      child: chartPie,
    );
  }
}
