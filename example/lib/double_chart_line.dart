/*
 * @Author: Cao Shixin
 * @Date: 2020-05-27 11:34:30
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2022-07-28 16:15:36
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
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var uiimage = await UIImageUtil.loadImage('assets/lock.jpg');
      _chartLineBeanSystem1 = ChartBeanSystem(
        lineWidth: 2,
        chartBeans: [
          ChartLineBean(
            xPositionRetioy: 0 / 7,
            y: 30,
            cellPointSet: CellPointSet(
              pointSize: Size(8, 8),
              pointRadius: Radius.circular(4),
            ),
          ),
          ChartLineBean(
            xPositionRetioy: 1 / 7,
            cellPointSet: CellPointSet(
              pointType: PointType.PlacehoderImage,
              placehoderImage: uiimage,
              placeImageSize: Size(10, 10),
              pointSize: Size(8, 8),
              pointRadius: Radius.circular(4),
            ),
          ),
          ChartLineBean(
            xPositionRetioy: 2 / 7,
            cellPointSet: CellPointSet(
              pointSize: Size(8, 8),
              pointRadius: Radius.circular(4),
            ),
          ),
          ChartLineBean(
            xPositionRetioy: 3 / 7,
            y: 67,
            cellPointSet: CellPointSet(
              pointSize: Size(8, 8),
              pointRadius: Radius.circular(4),
            ),
          ),
          ChartLineBean(
            xPositionRetioy: 4 / 7,
            // y: 10,
            cellPointSet: CellPointSet(
              pointSize: Size(8, 8),
              pointRadius: Radius.circular(4),
            ),
          ),
          ChartLineBean(
            xPositionRetioy: 5 / 7,
            // y: 40,
            cellPointSet: CellPointSet(
              pointType: PointType.PlacehoderImage,
              placehoderImage: uiimage,
              placeImageSize: Size(10, 10),
              pointSize: Size(8, 8),
              pointRadius: Radius.circular(4),
            ),
          ),
          ChartLineBean(
            xPositionRetioy: 6 / 7,
            y: 10,
            cellPointSet: CellPointSet(
              pointSize: Size(8, 8),
              pointRadius: Radius.circular(4),
            ),
          ),
          ChartLineBean(
            xPositionRetioy: 7 / 7,
            y: 100,
            cellPointSet: CellPointSet(
              pointType: PointType.PlacehoderImage,
              placehoderImage: null,
              placeImageSize: Size(10, 10),
              pointSize: Size(8, 8),
              pointRadius: Radius.circular(4),
            ),
          ),
        ],
        shaderColors: [
          Colors.blue.withOpacity(0.3),
          Colors.blue.withOpacity(0.1)
        ],
        lineColor: Colors.cyan,
      );
      _chartLineBeanSystem2 = ChartBeanSystem(
        lineWidth: 2,
        isCurve: false,
        chartBeans: [
          ChartLineBean(
            xPositionRetioy: 0 / 7,
            y: 70,
            cellPointSet: CellPointSet(
              pointSize: Size(10, 10),
              pointRadius: Radius.circular(5),
              pointShaderColors: [Colors.red.withOpacity(0.3), Colors.red],
            ),
          ),
          ChartLineBean(
              xPositionRetioy: 1 / 7,
              y: 20,
              cellPointSet: CellPointSet(
                pointSize: Size(10, 10),
                pointShaderColors: [Colors.red.withOpacity(0.3), Colors.red],
              )),
          ChartLineBean(
            xPositionRetioy: 2 / 7,
            y: 30,
            cellPointSet: CellPointSet(
              pointSize: Size(10, 10),
              pointRadius: Radius.circular(5),
              pointShaderColors: [Colors.red.withOpacity(0.3), Colors.red],
            ),
          ),
          ChartLineBean(
            xPositionRetioy: 3 / 7,
            y: 50,
            cellPointSet: CellPointSet(
              pointSize: Size(10, 10),
              pointRadius: Radius.circular(5),
              pointShaderColors: [Colors.red.withOpacity(0.3), Colors.red],
            ),
          ),
          ChartLineBean(
            xPositionRetioy: 4 / 7,
            y: 100,
            cellPointSet: CellPointSet(
              pointSize: Size(10, 10),
              pointRadius: Radius.circular(5),
              pointShaderColors: [Colors.red.withOpacity(0.3), Colors.red],
            ),
          ),
          ChartLineBean(
              xPositionRetioy: 5 / 7,
              y: 30,
              cellPointSet: CellPointSet(
                pointSize: Size(10, 10),
                pointShaderColors: [Colors.red.withOpacity(0.3), Colors.red],
              )),
          ChartLineBean(
            xPositionRetioy: 6 / 7,
            y: 0,
            cellPointSet: CellPointSet(
              pointSize: Size(10, 10),
              pointRadius: Radius.circular(5),
              pointShaderColors: [Colors.red.withOpacity(0.3), Colors.red],
            ),
          ),
          ChartLineBean(
            xPositionRetioy: 7 / 7,
            y: 0,
            cellPointSet: CellPointSet(
              pointSize: Size(10, 10),
              pointRadius: Radius.circular(5),
              pointShaderColors: [Colors.red.withOpacity(0.3), Colors.red],
            ),
          ),
        ],
        shaderColors: [
          Colors.red.withOpacity(0.3),
          Colors.red.withOpacity(0.1)
        ],
        lineColor: Colors.red,
      );
      setState(() {});
    });
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
    var xarr = ['3-01', '3-02', '3-03', '3-04', '3-05', '3-06', '3-07', '3-08'];
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
        yMax: 100.0,
        yMin: 0.0,
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
