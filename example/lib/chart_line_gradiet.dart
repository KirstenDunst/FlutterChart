/*
 * @Author: Cao Shixin
 * @Date: 2022-10-21 15:04:16
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2022-10-21 15:31:04
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class ChartLineGradientPage extends StatefulWidget {
  static const String routeName = 'chart_line_gradient';
  static const String title = '折线线条渐变色';
  @override
  _ChartLineGradientState createState() => _ChartLineGradientState();
}

class _ChartLineGradientState extends State<ChartLineGradientPage> {
  ChartBeanSystem _chartLineBeanSystem;

  @override
  void initState() {
    var dataarr = [30.0, 88.0, 20.0, 67.0, 10.0, 40.0, 10.0];
    var tempDatas = <ChartLineBean>[];
    for (var i = 0; i < dataarr.length; i++) {
      var e = dataarr[i];
      tempDatas.add(
        ChartLineBean(
            y: e,
            xPositionRetioy: (1 / (dataarr.length - 1)) * i,
            tag: '$e',
            touchBackParam: e,
            cellPointSet: e == 40.0
                ? CellPointSet(
                    pointSize: Size(10, 10),
                    pointRadius: Radius.circular(5),
                    pointShaderColors: [Colors.red, Colors.red],
                  )
                : CellPointSet.normal),
      );
    }
    _chartLineBeanSystem = ChartBeanSystem(
      lineWidth: 5,
      isCurve: false,
      chartBeans: tempDatas,
      lineColor: Colors.red,
      //此处设置lineGradient,则上面的lineColor已经意义不大了
      lineGradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        tileMode: TileMode.mirror,
        colors: [
          Colors.red,
          Colors.red,
          Colors.yellow,
          Colors.yellow,
          Colors.blue,
          Colors.blue
        ],
        stops: [0.0, 0.33, 0.37, 0.63, 0.67, 1.0],
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ChartLineGradientPage.title),
      ),
      body: _buildChartLine(context),
    );
  }

  ///line
  Widget _buildChartLine(context) {
    var xarr = ['12-01', '12-02', '12-03', '12-04', '12-05', '12-06', '12-07'];
    var tempXs = <DialStyleX>[];
    for (var i = 0; i < xarr.length; i++) {
      tempXs.add(
        DialStyleX(
            title: xarr[i],
            titleStyle: TextStyle(color: Colors.grey, fontSize: 12),
            positionRetioy: (1 / (xarr.length - 1)) * i),
      );
    }
    var chartLine = ChartLine(
      xDialValues: tempXs,
      chartBeanSystems: [_chartLineBeanSystem],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.6),
      baseBean: BaseBean(
        xColor: Colors.black,
        yColor: Colors.white,
        rulerWidth: -4,
        isShowXScale: true,
        isLeftYDial: false,
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
        isShowHintX: true,
        isHintLineImaginary: true,
      ),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      child: chartLine,
      clipBehavior: Clip.antiAlias,
    );
  }
}
