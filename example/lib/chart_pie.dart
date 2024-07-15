/*
 * @Author: Cao Shixin
 * @Date: 2020-05-27 11:34:43
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2021-05-08 09:14:59
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class ChartPiePage extends StatefulWidget {
  static const String routeName = 'chart_pie';
  static const String title = '饼状图';

  const ChartPiePage({super.key});
  @override
  State<ChartPiePage> createState() => _ChartPieState();
}

class _ChartPieState extends State<ChartPiePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ChartPiePage.title),
      ),
      body: _buildChartPie(context),
    );
  }

  ///pie
  Widget _buildChartPie(context) {
    var chartPie = ChartPie(
      chartBeans: [
        // ChartPieBean(
        //     type: '话费',
        //     value: 180,
        //     color: Colors.blueGrey,
        //     assistTextStyle: TextStyle(fontSize: 12, color: Colors.blueGrey)),
        // ChartPieBean(
        //     type: '零食',
        //     value: 10,
        //     color: Colors.deepPurple,
        //     assistTextStyle: TextStyle(fontSize: 12, color: Colors.deepPurple)),
        ChartPieBean(
            type: '衣服',
            value: 1,
            color: Colors.green,
            assistTextStyle:
                const TextStyle(fontSize: 12, color: Colors.green)),
        ChartPieBean(
            type: '早餐',
            value: 3,
            color: Colors.blue,
            assistTextStyle: const TextStyle(fontSize: 12, color: Colors.blue)),
        ChartPieBean(
            type: '水果',
            value: 200,
            color: Colors.red,
            assistTextStyle: const TextStyle(fontSize: 12, color: Colors.red)),
        ChartPieBean(
            type: '你猜',
            value: 2,
            color: Colors.orange,
            assistTextStyle: const TextStyle(fontSize: 20, color: Colors.red)),
      ],
      assistTextShowType: AssistTextShowType.NamePercentage,
      arrowBegainLocation: ArrowBegainLocation.Left,
      backgroundColor: Colors.white,
      assistBGColor: Colors.black,
      // Color(0xFFF6F6F6),
      decimalDigits: 1,
      divisionWidth: 2,
      size: Size(
          MediaQuery.of(context).size.width, MediaQuery.of(context).size.width),
      globalR: MediaQuery.of(context).size.width / 6,
      centerR: 6,
      centerColor: Colors.white,
      centerWidget: const Text(
        '测试中心widget',
        style: TextStyle(color: Colors.black, fontSize: 20),
      ),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      color: Colors.orangeAccent.withOpacity(0.6),
      clipBehavior: Clip.antiAlias,
      borderOnForeground: true,
      child: chartPie,
    );
  }
}
