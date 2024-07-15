/*
 * @Author: Cao Shixin
 * @Date: 2020-05-27 11:32:05
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2022-10-26 13:57:55
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */

import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class ChartBarCirclePage extends StatefulWidget {
  static const String routeName = 'chart_bar_circle';
  static const String title = '柱状顶部半圆型';

  const ChartBarCirclePage({super.key});
  @override
  State<ChartBarCirclePage> createState() => _ChartBarCircleState();
}

class _ChartBarCircleState extends State<ChartBarCirclePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ChartBarCirclePage.title),
      ),
      body: _buildChartBarCircle(context),
    );
  }

  ///bar-circle
  Widget _buildChartBarCircle(context) {
    var chartBar = ChartBar(
      xDialValues: [
        ChartBarBeanX(
          xBottomTextModel: TextSetModel(title: '12-01'),
          beanXModels: [
            ChartBarBeanXCell(
              value: 5,
              sectionColors: [
                SectionColor(
                  starRate: 0,
                  endRate: 1,
                  gradualColor: [Colors.red, Colors.red],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                )
              ],
            )
          ],
        ),
        ChartBarBeanX(
          xBottomTextModel: TextSetModel(title: '12-02'),
          beanXModels: [
            ChartBarBeanXCell(
              value: 100,
              sectionColors: [
                SectionColor(
                  starRate: 0,
                  endRate: 1,
                  gradualColor: [Colors.yellow, Colors.yellow],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                )
              ],
            ),
          ],
        ),
        ChartBarBeanX(
          xBottomTextModel: TextSetModel(title: '12-03'),
          beanXModels: [
            ChartBarBeanXCell(
              value: 70,
              sectionColors: [
                SectionColor(
                  starRate: 0,
                  endRate: 1,
                  gradualColor: [Colors.green, Colors.green],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                )
              ],
            ),
          ],
        ),
        ChartBarBeanX(
          xBottomTextModel: TextSetModel(title: '12-04'),
          beanXModels: [
            ChartBarBeanXCell(
              value: 70,
              sectionColors: [
                SectionColor(
                  starRate: 0,
                  endRate: 1,
                  gradualColor: [Colors.blue, Colors.blue],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                )
              ],
            ),
          ],
        ),
        ChartBarBeanX(
          xBottomTextModel: TextSetModel(title: '12-05'),
          beanXModels: [
            ChartBarBeanXCell(
              value: 30,
              sectionColors: [
                SectionColor(
                  starRate: 0,
                  endRate: 1,
                  gradualColor: [Colors.deepPurple, Colors.deepPurple],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                )
              ],
            ),
          ],
        ),
        ChartBarBeanX(
          xBottomTextModel: TextSetModel(title: '12-06'),
          beanXModels: [
            ChartBarBeanXCell(
              value: 90,
              sectionColors: [
                SectionColor(
                  starRate: 0,
                  endRate: 1,
                  gradualColor: [Colors.deepOrange, Colors.deepOrange],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                )
              ],
            ),
          ],
        ),
        ChartBarBeanX(
          xBottomTextModel: TextSetModel(title: '12-07'),
          beanXModels: [
            ChartBarBeanXCell(
              value: 50,
              sectionColors: [
                SectionColor(
                  starRate: 0,
                  endRate: 1,
                  gradualColor: [Colors.greenAccent, Colors.greenAccent],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                )
              ],
            ),
          ],
        )
      ],
      baseLineY: 35,
      baseBean: BaseBean(
        yDialValues: [
          DialStyleY(
              leftSub: DialStyleYSub(
                title: '100',
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
                    const TextStyle(color: Colors.lightBlue, fontSize: 10),
                centerSubTitle: 'Aware',
                centerSubTextStyle:
                    const TextStyle(color: Colors.red, fontSize: 10),
              ),
              yValue: 65,
              positionRetioy: 65 / 100),
          DialStyleY(
              leftSub: DialStyleYSub(
                title: '35',
                titleStyle:
                    const TextStyle(color: Colors.lightBlue, fontSize: 10),
                centerSubTitle: 'Focused',
                centerSubTextStyle:
                    const TextStyle(color: Colors.red, fontSize: 10),
              ),
              yValue: 35,
              positionRetioy: 35 / 100)
        ],
        yMax: 100.0,
        yMin: 0.0,
        isShowHintX: true
      ),
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.8),
      rectWidth: 50.0,
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.orange.withOpacity(0.4),
      clipBehavior: Clip.antiAlias,
      child: chartBar,
    );
  }
}
