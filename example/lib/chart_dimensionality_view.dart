/*
 * @Author: Cao Shixin
 * @Date: 2020-07-17 17:42:38
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-07-20 15:20:29
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart/flutter_chart.dart';

class ChartDimensionalityView extends StatefulWidget {
  static const String routeName = 'chart_dimensionality_view';
  static const String title = '维度图';
  @override
  _ChartDimensionalityViewState createState() =>
      _ChartDimensionalityViewState();
}

class _ChartDimensionalityViewState extends State<ChartDimensionalityView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ChartDimensionalityView.title),
      ),
      body: _buildWidget(context),
    );
  }

  Widget _buildWidget(BuildContext context) {
    var chartLine = ChartDimensionality(
      dimensionalityDivisions: [
        ChartBeanDimensionality(
          tip: '选择性专注力',
          tipStyle: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
        ),
        ChartBeanDimensionality(
          tip: '持续性专注力',
          tipStyle: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
        ),
        ChartBeanDimensionality(
          tip: '转换性专注力',
          tipStyle: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
        ),
        ChartBeanDimensionality(
          tip: '分配性专注力',
          tipStyle: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
        ),
        ChartBeanDimensionality(
          tip: '视觉性专注力',
          tipStyle: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
        ),
        ChartBeanDimensionality(
          tip: '玩儿呢',
          tipStyle: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
        )
      ],
      dimensionalityTags: [
        DimensionalityBean(
          tagColor: Color(0xFFB1E3AD).withOpacity(0.6),
          tagTitleStyle: TextStyle(color: Color(0xFF666666), fontSize: 16.0),
          tagTitle: '初次评测',
          tagContents: [0.2, 0.4, 0.8, 1.0, 0.1, 0.5],
        ),
        DimensionalityBean(
          tagColor: Color(0xFFF88282).withOpacity(0.6),
          tagTitleStyle: TextStyle(color: Color(0xFF666666), fontSize: 16.0),
          tagTitle: '本次评测',
          tagContents: [0.8, 0.9, 0.8, 1.0, 0.7, 0.9],
        )
      ],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.6),
      isDotted: false,
      lineWidth: 2,
      centerR: 150,
      backgroundColor: Colors.white,
      lineColor: Colors.blueAccent,
      isAnimation: true,
      isReverse: false,
      dimensionalityNumber: 4,
      duration: Duration(milliseconds: 2000),
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
