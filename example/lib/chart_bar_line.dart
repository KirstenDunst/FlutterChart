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
                        (index) => LineBarSectionBean(
                            index / 24, 1 / 24, Random().nextDouble() * 100,
                            param: '$index')),
                    lineColor: Colors.blue),
                ChartLineBarBeanSystem(
                    lineBarBeans: List.generate(
                        24,
                        (index) => LineBarSectionBean(
                            index / 24, 1 / 24, Random().nextDouble() * 100,
                            param: '$index')),
                    lineColor: Colors.orange,
                    enableTouch: true)
              ],
              touchSet: LineBarTouchSet(
                selelctSet: LineBarSelectSet(
                  highLightColor: Colors.black.withOpacity(0.4),
                ),
                touchBack: (startPoint, size, value) {
                  print('>>>>>>>$startPoint');
                },
              ),
              baseBean: BaseBean(yDialValues: [
                DialStyleY(
                    leftSub: DialStyleYSub(
                        title: '100',
                        titleStyle:
                            const TextStyle(color: Colors.black, fontSize: 10)),
                    yValue: 100,
                    positionRetioy: 100 / 100),
                DialStyleY(
                    leftSub: DialStyleYSub(
                        title: '65',
                        titleStyle:
                            const TextStyle(color: Colors.black, fontSize: 10)),
                    yValue: 65,
                    positionRetioy: 65 / 100),
                DialStyleY(
                    leftSub: DialStyleYSub(
                        title: '35',
                        titleStyle:
                            const TextStyle(color: Colors.black, fontSize: 10)),
                    yValue: 35,
                    positionRetioy: 35 / 100)
              ], yMax: 100.0, yMin: 0.0, isShowHintX: true),
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
