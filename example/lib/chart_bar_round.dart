/*
 * @Author: Cao Shixin
 * @Date: 2020-05-27 11:33:23
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2022-01-21 14:02:00
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class ChartBarRoundPage extends StatefulWidget {
  static const String routeName = 'chart_bar_round';
  static const String title = '柱状图自定义弧角+可点击拖拽';

  const ChartBarRoundPage({super.key});
  @override
  State<ChartBarRoundPage> createState() => _ChartBarRoundState();
}

class _ChartBarRoundState extends State<ChartBarRoundPage> {
  Offset? _offset;
  final GlobalKey<ChartBarState> globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ChartBarRoundPage.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildChartBarRound(context),
            const SizedBox(
              height: 50,
            ),
            GestureDetector(
              child: Container(
                width: 200,
                height: 60,
                color: Colors.orange,
                alignment: Alignment.center,
                child: const Text('点击取消图表标记'),
              ),
              onTap: () => globalKey.currentState?.clearTouchPoint(),
            ),
          ],
        ),
      ),
    );
  }

  ///bar-round
  Widget _buildChartBarRound(context) {
    var chartBar = Stack(children: [
      ChartBar(
        backgroundColor: Colors.brown.withOpacity(0.6),
        key: globalKey,
        xDialValues: [
          ChartBarBeanX(
              xBottomTextModel: TextSetModel(
                  title: '12-01',
                  titleStyle:
                      const TextStyle(color: Colors.white, fontSize: 10)),
              beanXModels: [
                ChartBarBeanXCell(
                  value: 30,
                  rectTopText: '30',
                  rectTopTextStyle:
                      const TextStyle(color: Colors.white, fontSize: 12),
                  sectionColors: [
                    SectionColor(
                        starRate: 0,
                        endRate: 1,
                        borderRadius: BorderRadius.circular(4),
                        gradualColor: [Colors.orange, Colors.orange])
                  ],
                ),
              ],
              touchBackParam: '1'),
          ChartBarBeanX(
              xBottomTextModel: TextSetModel(
                  title: '12-02',
                  titleStyle:
                      const TextStyle(color: Colors.white, fontSize: 10)),
              beanXModels: [
                ChartBarBeanXCell(
                  value: 0,
                  sectionColors: [
                    SectionColor(
                        starRate: 0,
                        endRate: 1,
                        borderRadius: BorderRadius.circular(4),
                        gradualColor: [Colors.yellow, Colors.yellow])
                  ],
                ),
              ],
              touchBackParam: '2'),
          ChartBarBeanX(
              xBottomTextModel: TextSetModel(
                  title: '12-03',
                  titleStyle:
                      const TextStyle(color: Colors.white, fontSize: 10)),
              beanXModels: [
                ChartBarBeanXCell(
                  value: 0.0,
                  rectTopText: '0.0',
                  rectTopTextStyle:
                      const TextStyle(color: Colors.white, fontSize: 12),
                  sectionColors: [
                    SectionColor(
                        starRate: 0,
                        endRate: 1,
                        borderRadius: BorderRadius.circular(4),
                        gradualColor: [Colors.green, Colors.green])
                  ],
                ),
              ],
              touchBackParam: '3'),
          ChartBarBeanX(
              xBottomTextModel: TextSetModel(
                  title: '12-04',
                  titleStyle:
                      const TextStyle(color: Colors.white, fontSize: 10)),
              beanXModels: [
                ChartBarBeanXCell(
                  value: 70.1,
                  rectTopText: '70.1',
                  rectTopTextStyle:
                      const TextStyle(color: Colors.white, fontSize: 12),
                  sectionColors: [
                    SectionColor(
                        starRate: 0,
                        endRate: 1,
                        borderRadius: BorderRadius.circular(4),
                        gradualColor: [Colors.blue, Colors.blue])
                  ],
                ),
              ],
              touchBackParam: '4'),
          ChartBarBeanX(
              xBottomTextModel: TextSetModel(
                  title: '12-05',
                  titleStyle:
                      const TextStyle(color: Colors.white, fontSize: 10)),
              beanXModels: [
                ChartBarBeanXCell(
                  value: 30,
                  rectTopText: '30ge',
                  rectTopTextStyle:
                      const TextStyle(color: Colors.white, fontSize: 12),
                  sectionColors: [
                    SectionColor(
                        starRate: 0,
                        endRate: 1,
                        borderRadius: BorderRadius.circular(4),
                        gradualColor: [Colors.deepPurple, Colors.deepPurple])
                  ],
                ),
              ],
              touchBackParam: '5'),
          ChartBarBeanX(
              xBottomTextModel: TextSetModel(
                  title: '12-06',
                  titleStyle:
                      const TextStyle(color: Colors.white, fontSize: 10)),
              beanXModels: [
                ChartBarBeanXCell(
                  value: 90,
                  rectTopText: '90',
                  rectTopTextStyle:
                      const TextStyle(color: Colors.white, fontSize: 12),
                  sectionColors: [
                    SectionColor(
                        starRate: 0,
                        endRate: 0.1,
                        borderRadius: BorderRadius.circular(4),
                        gradualColor: [Colors.deepOrange, Colors.deepOrange]),
                    SectionColor(
                        starRate: 0.1,
                        endRate: 0.3,
                        borderRadius: BorderRadius.circular(4),
                        gradualColor: [Colors.blue, Colors.blue]),
                    SectionColor(
                        starRate: 0.3,
                        endRate: 1,
                        borderRadius: BorderRadius.circular(4),
                        gradualColor: [Colors.purple, Colors.purple])
                  ],
                ),
              ],
              touchBackParam: '6'),
          ChartBarBeanX(
              xBottomTextModel: TextSetModel(
                  title: '12-07',
                  titleStyle:
                      const TextStyle(color: Colors.white, fontSize: 10)),
              beanXModels: [
                ChartBarBeanXCell(
                  value: 50,
                  rectTopText: '50',
                  rectTopTextStyle:
                      const TextStyle(color: Colors.white, fontSize: 12),
                  sectionColors: [
                    SectionColor(
                        starRate: 0,
                        endRate: 1,
                        borderRadius: BorderRadius.circular(4),
                        gradualColor: [Colors.greenAccent, Colors.greenAccent])
                  ],
                ),
              ],
              touchBackParam: '7'),
          ChartBarBeanX(
              xBottomTextModel: TextSetModel(
                  title: '12-08',
                  titleStyle:
                      const TextStyle(color: Colors.white, fontSize: 10)),
              cellBarSpace: 2,
              beanXModels: [
                ChartBarBeanXCell(
                  value: 10,
                  rectTopText: '10',
                  rectTopTextStyle:
                      const TextStyle(color: Colors.white, fontSize: 12),
                  sectionColors: [
                    SectionColor(
                        starRate: 0,
                        endRate: 1,
                        borderRadius: BorderRadius.circular(4),
                        gradualColor: [Colors.greenAccent, Colors.greenAccent])
                  ],
                ),
                ChartBarBeanXCell(
                  value: 8,
                  rectTopText: '8',
                  rectTopTextStyle:
                      const TextStyle(color: Colors.white, fontSize: 12),
                  sectionColors: [
                    SectionColor(
                        starRate: 0,
                        endRate: 1,
                        borderRadius: BorderRadius.circular(4),
                        gradualColor: [Colors.greenAccent, Colors.greenAccent])
                  ],
                ),
              ],
              touchBackParam: '8'),
          ChartBarBeanX(
              xBottomTextModel: TextSetModel(
                  title: '12-09',
                  titleStyle: const TextStyle(color: Colors.red, fontSize: 10)),
              beanXModels: [
                ChartBarBeanXCell(
                  value: 10,
                  rectTopText: '10',
                  rectTopTextStyle:
                      const TextStyle(color: Colors.white, fontSize: 12),
                  sectionColors: [
                    SectionColor(
                        starRate: 0,
                        endRate: 1,
                        borderRadius: BorderRadius.circular(4),
                        gradualColor: [
                          Colors.greenAccent.withOpacity(0.2),
                          Colors.greenAccent
                        ])
                  ],
                ),
              ],
              touchBackParam: '9')
        ],
        baseLineY: 45,
        baseBean: BaseBean(
          yDialLeftMain: false,
          xBaseLineY: 45,
          yDialValues: [
            DialStyleY(
                leftSub: DialStyleYSub(
                  title: '100',
                  titleStyle:
                      const TextStyle(color: Colors.lightBlue, fontSize: 10),
                ),
                rightSub: DialStyleYSub(
                  title: '100right',
                  titleStyle:
                      const TextStyle(color: Colors.lightBlue, fontSize: 10),
                  centerSubTitle: 'Calm',
                  centerSubTextStyle:
                      const TextStyle(color: Colors.red, fontSize: 10),
                ),
                yValue: 100,
                positionRetioy: 100 / 100),
            DialStyleY(
                leftSub: DialStyleYSub(
                    title: '65',
                    titleStyle:
                        const TextStyle(color: Colors.lightBlue, fontSize: 10)),
                rightSub: DialStyleYSub(
                    title: '65right',
                    titleStyle:
                        const TextStyle(color: Colors.lightBlue, fontSize: 10),
                    centerSubTitle: 'Aware',
                    centerSubTextStyle:
                        const TextStyle(color: Colors.red, fontSize: 10)),
                yValue: 65,
                positionRetioy: 65 / 100),
            DialStyleY(
                leftSub: DialStyleYSub(
                    title: '35',
                    titleStyle:
                        const TextStyle(color: Colors.lightBlue, fontSize: 10)),
                rightSub: DialStyleYSub(
                    centerSubTitle: 'Focused',
                    centerSubTextStyle:
                        const TextStyle(color: Colors.red, fontSize: 10),
                    title: '35right',
                    titleStyle:
                        const TextStyle(color: Colors.lightBlue, fontSize: 10)),
                yValue: 35,
                positionRetioy: 35 / 100),
            DialStyleY(
                leftSub: DialStyleYSub(
                    title: '0',
                    titleStyle:
                        const TextStyle(color: Colors.lightBlue, fontSize: 10)),
                rightSub: DialStyleYSub(
                    title: '0right',
                    titleStyle:
                        const TextStyle(color: Colors.lightBlue, fontSize: 10)),
                yValue: 0,
                positionRetioy: 0 / 100)
          ],
          isShowHintX: true,
          isHintLineImaginary: true,
          xColor: Colors.cyan,
          yColor: Colors.cyan,
          yMax: 100.0,
          yMin: 0.0,
          units: [
            UnitXY(
                text: '(日期)',
                textStyle: const TextStyle(fontSize: 10),
                spaceDif: const Offset(2, 10),
                baseOrientation: UnitOrientation.bottomRight),
            UnitXY(
                text: '(分钟)',
                textStyle: const TextStyle(fontSize: 10),
                spaceDif: const Offset(0, 5),
                baseOrientation: UnitOrientation.topLeft),
            UnitXY(
                text: '左下',
                textStyle: const TextStyle(fontSize: 10),
                baseOrientation: UnitOrientation.bottomLeft),
            UnitXY(
                text: '右上',
                textStyle: const TextStyle(fontSize: 10),
                baseOrientation: UnitOrientation.topRight)
          ],
        ),
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height / 5 * 1.8),
        duration: const Duration(seconds: 2),
        rectWidth: 50.0,
        touchSet: TouchSet(
            outsidePointClear: false,
            touchBack: (startOffset, size, param) {
              setState(() {
                _offset = startOffset;
                if (kDebugMode) {
                  print('////点击的位置:$startOffset,size:$size,param:$param');
                }
              });
            }),
      ),
      if (_offset != null)
        Positioned(
          left: _offset!.dx,
          top: _offset!.dy,
          width: 20,
          height: 20,
          child: IgnorePointer(
            child: Container(
              color: Colors.red,
            ),
          ),
        ),
    ]);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      clipBehavior: Clip.none,
      child: chartBar,
    );
  }
}
