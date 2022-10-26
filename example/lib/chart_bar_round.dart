/*
 * @Author: Cao Shixin
 * @Date: 2020-05-27 11:33:23
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2022-01-21 14:02:00
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class ChartBarRoundPage extends StatefulWidget {
  static const String routeName = 'chart_bar_round';
  static const String title = '柱状图自定义弧角+可点击拖拽';
  @override
  _ChartBarRoundState createState() => _ChartBarRoundState();
}

class _ChartBarRoundState extends State<ChartBarRoundPage> {
  Offset _offset;
  final GlobalKey<ChartBarState> globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ChartBarRoundPage.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildChartBarRound(context),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              child: Container(
                width: 200,
                height: 60,
                color: Colors.orange,
                alignment: Alignment.center,
                child: Text('点击取消图表标记'),
              ),
              onTap: () => globalKey.currentState.clearTouchPoint(),
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
              title: '12-01',
              titleStyle: TextStyle(color: Colors.white, fontSize: 10),
              value: 30,
              rectTopText: '30',
              rectTopTextStyle: TextStyle(color: Colors.white, fontSize: 12),
              sectionColors: [
                SectionColor(
                    starRate: 0,
                    endRate: 1,
                    borderRadius: BorderRadius.circular(4),
                    gradualColor: [Colors.orange, Colors.orange])
              ],
              touchBackParam: '1'),
          ChartBarBeanX(
              title: '12-02',
              titleStyle: TextStyle(color: Colors.white, fontSize: 10),
              value: 0,
              sectionColors: [
                SectionColor(
                    starRate: 0,
                    endRate: 1,
                    borderRadius: BorderRadius.circular(4),
                    gradualColor: [Colors.yellow, Colors.yellow])
              ],
              touchBackParam: '2'),
          ChartBarBeanX(
              title: '12-03',
              titleStyle: TextStyle(color: Colors.white, fontSize: 10),
              value: 0.0,
              rectTopText: '0.0',
              rectTopTextStyle: TextStyle(color: Colors.white, fontSize: 12),
              sectionColors: [
                SectionColor(
                    starRate: 0,
                    endRate: 1,
                    borderRadius: BorderRadius.circular(4),
                    gradualColor: [Colors.green, Colors.green])
              ],
              touchBackParam: '3'),
          ChartBarBeanX(
              title: '12-04',
              titleStyle: TextStyle(color: Colors.white, fontSize: 10),
              value: 70.1,
              rectTopText: '70.1',
              rectTopTextStyle: TextStyle(color: Colors.white, fontSize: 12),
              sectionColors: [
                SectionColor(
                    starRate: 0,
                    endRate: 1,
                    borderRadius: BorderRadius.circular(4),
                    gradualColor: [Colors.blue, Colors.blue])
              ],
              touchBackParam: '4'),
          ChartBarBeanX(
              title: '12-05',
              titleStyle: TextStyle(color: Colors.white, fontSize: 10),
              value: 30,
              rectTopText: '30ge',
              rectTopTextStyle: TextStyle(color: Colors.white, fontSize: 12),
              sectionColors: [
                SectionColor(
                    starRate: 0,
                    endRate: 1,
                    borderRadius: BorderRadius.circular(4),
                    gradualColor: [Colors.deepPurple, Colors.deepPurple])
              ],
              touchBackParam: '5'),
          ChartBarBeanX(
              title: '12-06',
              titleStyle: TextStyle(color: Colors.white, fontSize: 10),
              value: 90,
              rectTopText: '90',
              rectTopTextStyle: TextStyle(color: Colors.white, fontSize: 12),
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
              touchBackParam: '6'),
          ChartBarBeanX(
              title: '12-07',
              titleStyle: TextStyle(color: Colors.white, fontSize: 10),
              value: 50,
              rectTopText: '50',
              rectTopTextStyle: TextStyle(color: Colors.white, fontSize: 12),
              sectionColors: [
                SectionColor(
                    starRate: 0,
                    endRate: 1,
                    borderRadius: BorderRadius.circular(4),
                    gradualColor: [Colors.greenAccent, Colors.greenAccent])
              ],
              touchBackParam: '7'),
          ChartBarBeanX(
              title: '12-08',
              titleStyle: TextStyle(color: Colors.white, fontSize: 10),
              value: 10,
              rectTopText: '10',
              rectTopTextStyle: TextStyle(color: Colors.white, fontSize: 12),
              sectionColors: [
                SectionColor(
                    starRate: 0,
                    endRate: 1,
                    borderRadius: BorderRadius.circular(4),
                    gradualColor: [Colors.greenAccent, Colors.greenAccent])
              ],
              touchBackParam: '8'),
          ChartBarBeanX(
              title: '12-09',
              titleStyle: TextStyle(color: Colors.red, fontSize: 10),
              value: 10,
              rectTopText: '10',
              rectTopTextStyle: TextStyle(color: Colors.white, fontSize: 12),
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
              touchBackParam: '9')
        ],
        baseBean: BaseBean(
          yDialValues: [
            DialStyleY(
                title: '100',
                titleStyle: TextStyle(color: Colors.lightBlue, fontSize: 10),
                centerSubTitle: 'Calm',
                centerSubTextStyle: TextStyle(color: Colors.red, fontSize: 10),
                positionRetioy: 100 / 100),
            DialStyleY(
                title: '65',
                titleStyle: TextStyle(color: Colors.lightBlue, fontSize: 10),
                centerSubTitle: 'Aware',
                centerSubTextStyle: TextStyle(color: Colors.red, fontSize: 10),
                positionRetioy: 65 / 100),
            DialStyleY(
                title: '35',
                titleStyle: TextStyle(color: Colors.lightBlue, fontSize: 10),
                centerSubTitle: 'Focused',
                centerSubTextStyle: TextStyle(color: Colors.red, fontSize: 10),
                positionRetioy: 35 / 100)
          ],
          isLeftYDialSub: false,
          isShowHintX: true,
          isHintLineImaginary: true,
          xColor: Colors.cyan,
          yColor: Colors.cyan,
          yMax: 100.0,
          yMin: 0.0,
          unitX: UnitXY(
              text: '(日期)',
              textStyle: TextStyle(fontSize: 10),
              offset: Offset(2, 10)),
          unitY: UnitXY(
              text: '(分钟)',
              textStyle: TextStyle(fontSize: 10),
              offset: Offset(0, 5)),
        ),
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height / 5 * 1.8),
        duration: Duration(seconds: 2),
        rectWidth: 50.0,
        touchSet: TouchSet(
          outsidePointClear: false,
          touchBack: (startOffset, size, param) {
          setState(() {
            _offset = startOffset;
            print('////点击的位置:$startOffset,size:$size,param:$param');
          });
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
    ]);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      child: chartBar,
      clipBehavior: Clip.none,
    );
  }
}
