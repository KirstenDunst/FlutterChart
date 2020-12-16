/*
 * @Author: Cao Shixin
 * @Date: 2020-05-27 11:34:30
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2020-11-09 17:32:22
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class DoubleChartlinePage extends StatefulWidget {
  static const String routeName = 'double_chart_line';
  static const String title = '双折线';
  @override
  _DoubleChartlineState createState() => _DoubleChartlineState();
}

class _DoubleChartlineState extends State<DoubleChartlinePage> {
  ChartBeanSystem _chartLineBeanSystem1, _chartLineBeanSystem2;

  @override
  void initState() {
    _chartLineBeanSystem1 = ChartBeanSystem(
      xTitleStyle: TextStyle(color: Colors.grey, fontSize: 12),
      isDrawX: true,
      lineWidth: 2,
      pointRadius: 4,
      isCurve: false,
      chartBeans: [
        ChartLineBean(x: '3-01', y: 30),
        ChartLineBean(x: '3-02', y: 88, isShowPlaceImage: true),
        ChartLineBean(x: '3-03', y: 20),
        ChartLineBean(x: '3-04', y: 67),
        ChartLineBean(x: '3-05', y: 10),
        ChartLineBean(x: '3-06', y: 40, isShowPlaceImage: true),
        ChartLineBean(x: '3-07', y: 10),
        ChartLineBean(x: '3-08', y: 100, isShowPlaceImage: false),
      ],
      shaderColors: [
        Colors.blue.withOpacity(0.3),
        Colors.blue.withOpacity(0.1)
      ],
      lineColor: Colors.cyan,
      placehoderImageBreak: true,
    );
    _chartLineBeanSystem2 = ChartBeanSystem(
      xTitleStyle: TextStyle(color: Colors.grey, fontSize: 12),
      isDrawX: false,
      lineWidth: 2,
      pointRadius: 10,
      pointType: PointType.RoundEdgeRectangle,
      pointShaderColors: [Colors.red.withOpacity(0.3), Colors.red],
      isCurve: false,
      chartBeans: [
        ChartLineBean(x: '3-01', y: 70, isShowPlaceImage: false),
        ChartLineBean(x: '3-02', y: 20),
        ChartLineBean(x: '3-03', y: 30),
        ChartLineBean(x: '3-04', y: 50, isShowPlaceImage: true),
        ChartLineBean(x: '3-05', y: 100, isShowPlaceImage: true),
        ChartLineBean(x: '3-06', y: 30, isShowPlaceImage: false),
        ChartLineBean(x: '3-07', y: 0),
        ChartLineBean(x: '3-08', y: 0, isShowPlaceImage: false),
      ],
      shaderColors: [Colors.red.withOpacity(0.3), Colors.red.withOpacity(0.1)],
      lineColor: Colors.red,
      placehoderImageBreak: false,
    );
    UIImageUtil.loadImage('assets/lock.jpg').then((value) {
      _chartLineBeanSystem1.placehoderImage = value;
      _chartLineBeanSystem2.placehoderImage = value;
      _chartLineBeanSystem1.placeImageRatio = 0.5;
      _chartLineBeanSystem2.placeImageRatio = 0.5;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DoubleChartlinePage.title),
      ),
      body: _buildDoubleChartLine(context),
    );
  }

  Widget _buildDoubleChartLine(context) {
    var chartLine = ChartLine(
      chartBeanSystems: [_chartLineBeanSystem1, _chartLineBeanSystem2],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.6),
      baseBean: BaseBean(
        xColor: Colors.white,
        yColor: Colors.white,
        rulerWidth: 3,
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
        xyLineWidth: 0.5,
        isShowHintX: true,
        isHintLineImaginary: true,
      ),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.white.withOpacity(0.4),
      child: chartLine,
      clipBehavior: Clip.antiAlias,
    );
  }
}
