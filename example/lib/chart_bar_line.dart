import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class ChartBarLinePage extends StatefulWidget {
  static const String routeName = 'chart_bar_line';
  static const String title = '柱状线图';

  const ChartBarLinePage({super.key});

  @override
  State<ChartBarLinePage> createState() => _ChartBarLinePageState();
}

class _ChartBarLinePageState extends State<ChartBarLinePage> {
  final GlobalKey<ChartLineBarState> _globalKey =
      GlobalKey<ChartLineBarState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ChartBarLinePage.title),
      ),
      body: Column(
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            semanticContainer: true,
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            child: ChartLineBar(
              key: _globalKey,
              lineBarSystems: [
                ChartLineBarBeanSystem(
                    lineBarBeans: List.generate(
                        24,
                        (index) => LineBarSectionBean(index / 24, 1 / 24,
                            Random().nextDouble() * 300 - 150,
                            param: '$index')),
                    lineColor: Colors.blue,
                    segmentationModel: LineColorSegmentationModel(
                        Colors.red, Colors.orange, -200)),
                // ChartLineBarBeanSystem(
                //     lineBarBeans: List.generate(
                //         24,
                //         (index) => LineBarSectionBean(index / 24, 1 / 24,
                //             Random().nextDouble() * 300 - 150,
                //             param: '$index')),
                //     lineColor: Colors.orange,
                //     enableTouch: true)
              ],
              touchSet: LineBarTouchSet(
                selelctSet: LineBarSelectSet(
                  highLightColor: Colors.black.withOpacity(0.4),
                ),
                touchBack: (startPoint, size, value) {
                  // print('>>>>>>>$startPoint');
                },
              ),
              baseBean: BaseBean(yDialValues: [
                DialStyleY(
                    leftSub: DialStyleYSub(
                        title: '140',
                        titleStyle:
                            const TextStyle(color: Colors.black, fontSize: 10)),
                    yValue: 140,
                    positionRetioy: 29 / 30),
                DialStyleY(
                    leftSub: DialStyleYSub(
                        title: '50',
                        titleStyle:
                            const TextStyle(color: Colors.black, fontSize: 10)),
                    yValue: 50,
                    positionRetioy: 2 / 3),
                DialStyleY(
                    leftSub: DialStyleYSub(
                        title: '-50',
                        titleStyle:
                            const TextStyle(color: Colors.black, fontSize: 10)),
                    yValue: -50,
                    positionRetioy: 1 / 3),
                DialStyleY(
                    leftSub: DialStyleYSub(
                        title: '',
                        titleStyle:
                            const TextStyle(color: Colors.black, fontSize: 10)),
                    yValue: 0,
                    positionRetioy: 1 / 2),
              ], yMax: 150.0, yMin: -150.0, isShowHintX: true),
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height / 5 * 1.8),
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              _globalKey.currentState?.clearTouchPoint();
            },
            child: Container(
              width: 100,
              height: 40,
              alignment: Alignment.center,
              child: const Text('取消选中'),
            ),
          )
        ],
      ),
    );
  }
}
