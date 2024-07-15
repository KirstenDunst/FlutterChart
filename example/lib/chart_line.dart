/*
 * @Author: Cao Shixin
 * @Date: 2020-05-27 11:34:05
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2022-07-29 09:25:11
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class ChartLinePage extends StatefulWidget {
  static const String routeName = 'chart_line';
  static const String title = '折线带填充颜色';

  const ChartLinePage({super.key});
  @override
  State<ChartLinePage> createState() => _ChartLineState();
}

class _ChartLineState extends State<ChartLinePage> {
  final GlobalKey<ChartLineState> globalKey = GlobalKey();
  final ValueNotifier<Offset?> pointNotifier1 = ValueNotifier(null);
  final ValueNotifier<Offset?> pointNotifier2 = ValueNotifier(null);
  late ChartBeanSystem _chartLineBeanSystem;

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
                ? const CellPointSet(
                    pointSize: Size(10, 10),
                    pointRadius: Radius.circular(5),
                    pointShaderColors: [Colors.red, Colors.red],
                  )
                : CellPointSet.normal),
      );
    }
    _chartLineBeanSystem = ChartBeanSystem(
      lineWidth: 2,
      isCurve: false,
      chartBeans: tempDatas,
      lineShader: LineShaderSetModel(
        baseLineBottomGradient: LinearGradientModel(shaderColors: [
          Colors.blueAccent.withOpacity(0.3),
          Colors.blueAccent.withOpacity(0.1)
        ]),
        baseLineTopGradient: LinearGradientModel(shaderColors: [
          Colors.blueAccent.withOpacity(0.3),
          Colors.blueAccent.withOpacity(0.1)
        ]),
      ),
      lineColor: Colors.red,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ChartLinePage.title),
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
            titleStyle: const TextStyle(color: Colors.grey, fontSize: 12),
            positionRetioy: (1 / (xarr.length - 1)) * i),
      );
    }
    var chartLine = ChartLine(
      key: globalKey,
      xDialValues: tempXs,
      chartBeanSystems: [_chartLineBeanSystem],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.6),
      baseBean: BaseBean(
        xColor: Colors.black,
        yColor: Colors.white,
        yDialValues: [
          DialStyleY(
            leftSub: DialStyleYSub(
                title: '0',
                titleStyle:
                    const TextStyle(fontSize: 10.0, color: Colors.black)),
            yValue: 0,
            positionRetioy: 0 / 100.0,
          ),
          DialStyleY(
            leftSub: DialStyleYSub(
                title: '35',
                titleStyle:
                    const TextStyle(fontSize: 10.0, color: Colors.black)),
            yValue: 35,
            positionRetioy: 35 / 100.0,
          ),
          DialStyleY(
            leftSub: DialStyleYSub(
                title: '65',
                titleStyle:
                    const TextStyle(fontSize: 10.0, color: Colors.black)),
            yValue: 65,
            positionRetioy: 65 / 100.0,
          ),
          DialStyleY(
            leftSub: DialStyleYSub(
                title: '100',
                titleStyle:
                    const TextStyle(fontSize: 10.0, color: Colors.black)),
            yValue: 100,
            positionRetioy: 100 / 100.0,
          )
        ],
        yMax: 100.0,
        yMin: 0.0,
        isShowHintX: true,
        isHintLineImaginary: true,
      ),
      paintEnd: () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          var model = globalKey.currentState?.searchWithTag('40.0');
          if (kDebugMode) {
            print(
                '>>>>>>${model?.backValue}>>>>${model?.pointOffset}>>>>${model?.xyTopLeftOffset}');
          }
          pointNotifier1.value = model?.pointOffset;
          pointNotifier2.value = model?.xyTopLeftOffset;
        });
      },
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.yellow.withOpacity(0.4),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          chartLine,
          ValueListenableBuilder<Offset?>(
            valueListenable: pointNotifier1,
            builder: (context, offset, child) => offset != null
                ? Positioned(
                    top: offset.dy,
                    left: offset.dx,
                    child: Container(width: 10, height: 10, color: Colors.red))
                : Container(),
          ),
          ValueListenableBuilder<Offset?>(
            valueListenable: pointNotifier2,
            builder: (context, offset, child) => offset != null
                ? Positioned(
                    top: offset.dy,
                    left: offset.dx,
                    child:
                        Container(width: 10, height: 10, color: Colors.orange))
                : Container(),
          )
        ],
      ),
    );
  }
}
