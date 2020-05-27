/*
 * @Author: Cao Shixin
 * @Date: 2020-05-27 11:08:14
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-05-27 13:41:04
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chart/flutter_chart.dart';

class FocusChartLinePage extends StatefulWidget {
  static const String routeName = 'focus_chart_line';
  @override
  _FocusChartLineState createState() => _FocusChartLineState();
}

class _FocusChartLineState extends State<FocusChartLinePage> {
  GlobalKey<ChartLineFocusState> _childViewKey =
      new GlobalKey<ChartLineFocusState>();
  List<ChartBeanFocus> _beanList = [];
  Timer countdownTimer;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    if (countdownTimer == null) {
      countdownTimer = Timer.periodic(new Duration(seconds: 1), (timer) {
        double value = Random().nextDouble() * 100;
        _beanList.add(ChartBeanFocus(
            focus: value, second: index > 10 ? (10 + index) : index));
        if (_childViewKey.currentState != null) {
          _childViewKey.currentState.changeBeanList(_beanList);
        }
        index++;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('FN专注力样式图'),
      ),
      body: _buildFocusChartLine(context),
    );
  }

  //FocusLine
  Widget _buildFocusChartLine(context) {
    //制造假数据
    _beanList.clear();
    for (var i = 0; i < 60; i++) {
      _beanList.add(ChartBeanFocus(focus: Random().nextDouble() * 100));
    }
    List yValues = ['100', '65', '35', '0'];
    List xValues = ["0", "20'", "40'", "60'"];
    List xPositionRetioy = [0.0, 0.33, 0.66, 1.0];
    List yTexts = ["忘我", "一般", "走神", ''];
    List yTextColors = [
      Color(0xEEF75E36),
      Color(0xEEFFC278),
      Color(0xEE172B88),
      Color(0xEE172B88),
    ];
    List<DialStyle> yArr = [], xArr = [];
    for (var i = 0; i < yValues.length; i++) {
      xArr.add(DialStyle(
        titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
        title: xValues[i],
        positionRetioy: xPositionRetioy[i],
      ));

      yArr.add(DialStyle(
          title: yValues[i],
          titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
          centerSubTitle: yTexts[i],
          positionRetioy: double.parse(yValues[i]) / 100.0,
          centerSubTextStyle:
              TextStyle(fontSize: 10.0, color: yTextColors[i])));
    }
    //制造假数据结束

    var chartLine = ChartLineFocus(
      key: _childViewKey,
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.6),
      lineWidth: 1,
      isLinkBreak: false,
      chartBeans: _beanList,
      lineColor: Colors.transparent,
      xyColor: Colors.black,
      isShowHintX: true,
      isShowHintY: false,
      hintLineColor: Colors.blue,
      isHintLineImaginary: false,
      centerSubTitlePosition: CenterSubTitlePosition.Right,
      xMax: 180,
      yMax: 100.0,
      xDialValues: xArr,
      yDialValues: yArr,
      gradualColors: [Color(0xFF17605C), Color(0x00549A97)],
      canvasEnd: () {
        countdownTimer?.cancel();
        countdownTimer = null;
        print("毁灭定时器");
      },
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.white,
      child: chartLine,
      clipBehavior: Clip.antiAlias,
    );
  }

  // 不要忘记在这里释放掉Timer
  @override
  void dispose() {
    countdownTimer?.cancel();
    countdownTimer = null;
    print("毁灭");
    super.dispose();
  }
}
