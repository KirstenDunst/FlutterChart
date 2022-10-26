/*
 * @Author: Cao Shixin
 * @Date: 2021-05-24 11:02:23
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2022-07-28 16:14:27
 * @Description: 折线区间放大
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class ChartLineSectionEnlarge extends StatelessWidget {
  static const String routeName = 'chart_line_section_enlarge';
  static const String title = '折线y轴区间放大+可点击拖拽';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ChartLineSectionEnlarge.title),
      ),
      body: ChartLineSectionEnlargePage(),
    );
  }
}

class ChartLineSectionEnlargePage extends StatefulWidget {
  @override
  _ChartLineSectionEnlargePageState createState() =>
      _ChartLineSectionEnlargePageState();
}

class _ChartLineSectionEnlargePageState
    extends State<ChartLineSectionEnlargePage> {
  ChartBeanSystem _chartLineBeanSystem;
  Offset _offset;
  final GlobalKey<ChartLineState> globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _chartLineBeanSystem = ChartBeanSystem(
      lineWidth: 2,
      isCurve: false,
      chartBeans: [
        ChartLineBean(xPositionRetioy: 0 / 6, y: null, touchBackParam: '1'),
        ChartLineBean(
            xPositionRetioy: 1 / 6,
            y: null,
            cellPointSet: CellPointSet(
              pointSize: Size(6, 6),
              pointRadius: Radius.circular(3),
              pointShaderColors: [Colors.cyan, Colors.cyan],
            ),
            yShowText: '60.0',
            pointToTextSpace: 3,
            touchBackParam: '2'),
        ChartLineBean(xPositionRetioy: 2 / 6, y: 42, touchBackParam: '3'),
        ChartLineBean(xPositionRetioy: 3 / 6, y: 65, touchBackParam: '4'),
        ChartLineBean(xPositionRetioy: 4 / 6, y: 51, touchBackParam: '5'),
        ChartLineBean(xPositionRetioy: 5 / 6, y: null, touchBackParam: '6'),
        ChartLineBean(xPositionRetioy: 6 / 6, y: null, touchBackParam: '7'),
      ],
      shaderColors: [
        Colors.blue.withOpacity(0.3),
        Colors.blue.withOpacity(0.1)
      ],
      lineColor: Colors.red,
      enableTouch: true,
    );
  }

  @override
  Widget build(BuildContext context) {
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
    var chartLine = Stack(
      children: [
        ChartLine(
          xDialValues: tempXs,
          backgroundColor: Colors.yellow.withOpacity(0.4),
          key: globalKey,
          chartBeanSystems: [_chartLineBeanSystem],
          size: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height / 5 * 1.6),
          bothEndPitchX: 10,
          baseBean: BaseBean(
            xColor: Colors.black,
            yColor: Colors.white,
            isShowXScale: true,
            yDialValues: [
              DialStyleY(
                title: '30',
                titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
                positionRetioy: 0 / 40.0,
              ),
              DialStyleY(
                title: '35',
                titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
                positionRetioy: 5 / 40.0,
              ),
              DialStyleY(
                title: '65',
                titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
                positionRetioy: 35 / 40.0,
              ),
              DialStyleY(
                title: '70',
                titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
                positionRetioy: 40 / 40.0,
              )
            ],
            yMax: 70,
            yMin: 30,
            isShowHintX: true,
            isHintLineImaginary: true,
          ),
          touchSet: LineTouchSet(
              outsidePointClear: false,
              hintEdgeInset: HintEdgeInset.all(PointHintParam()),
              pointSet: CellPointSet(
                  pointSize: Size(10, 10),
                  pointRadius: Radius.circular(5),
                  pointShaderColors: [Colors.cyan, Colors.cyan]),
              touchBack: (offset, param) {
                setState(() {
                  _offset = offset;
                });
                print('带出来的参数:$offset,$param');
              }),
        ),
        if (_offset != null)
          Positioned(
            child: IgnorePointer(
              child: Container(
                color: Colors.red,
              ),
            ),
            left: _offset.dx,
            top: _offset.dy,
            width: 20,
            height: 20,
          ),
      ],
    );
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            semanticContainer: true,
            child: chartLine,
            clipBehavior: Clip.antiAlias,
          ),
          SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: () => globalKey.currentState.clearTouchPoint(),
            child: Container(
              width: 200,
              height: 50,
              alignment: Alignment.center,
              color: Colors.orange,
              child: Text('点击外部关闭图表的选中点'),
            ),
          )
        ],
      ),
    );
  }
}
