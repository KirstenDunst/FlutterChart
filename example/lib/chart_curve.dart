/*
 * @Author: Cao Shixin
 * @Date: 2020-05-27 11:33:43
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2022-07-28 16:13:53
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
  ChartBeanSystem _chartLineBeanSystem;

  @override
  void initState() {
    var dataarr = [30.0, 88.0, 20.0, 67.0, 10.0, 40.0, 10.0];
    var tempDatas = <ChartLineBean>[];
    for (var i = 0; i < dataarr.length; i++) {
      tempDatas.add(
        ChartLineBean(
            y: dataarr[i], xPositionRetioy: (1 / (dataarr.length - 1)) * i),
      );
    }
    _chartLineBeanSystem = ChartBeanSystem(
      lineWidth: 2,
      isCurve: true,
      chartBeans: tempDatas,
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
    var xarr = ['12-01', '12-02', '12-03', '12-04', '12-05', '12-06', '12-07'];
    var tempXs = <DialStyleX>[];
    for (var i = 0; i < xarr.length; i++) {
      tempXs.add(
        DialStyleX(
            title: xarr[i],
            titleStyle: TextStyle(color: Colors.red, fontSize: 12),
            positionRetioy: (1 / (xarr.length - 1)) * i),
      );
    }
    var chartLine = ChartLine(
      xDialValues: tempXs,
      chartBeanSystems: [_chartLineBeanSystem],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.6),
      baseBean: BaseBean(
        xColor: Colors.white,
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
        yMax: 100.0,
        yMin: 0.0,
        isShowHintY: true,
        isHintLineImaginary: true,
      ),
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
