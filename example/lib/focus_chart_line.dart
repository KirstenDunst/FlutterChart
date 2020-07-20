/*
 * @Author: Cao Shixin
 * @Date: 2020-05-27 11:08:14
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-07-20 16:08:24
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
  static const String title = 'FN单专注力样式图';
  @override
  _FocusChartLineState createState() => _FocusChartLineState();
}

class _FocusChartLineState extends State<FocusChartLinePage> {
  GlobalKey<ChartLineFocusState> _childViewKey =
      new GlobalKey<ChartLineFocusState>();
  List<ChartBeanFocus> _beanList = [];
  FocusChartBeanMain _focusChartBeanMain;
  Timer _countdownTimer;
  int _index = 0;
  List<DialStyle> _yArr = [], _xArr = [];

  @override
  void initState() {
    super.initState();
    //制造假数据
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

    for (var i = 0; i < yValues.length; i++) {
      _xArr.add(DialStyle(
        titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
        title: xValues[i],
        positionRetioy: xPositionRetioy[i],
      ));
      _yArr.add(DialStyle(
          title: yValues[i],
          titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
          centerSubTitle: yTexts[i],
          positionRetioy: double.parse(yValues[i]) / 100.0,
          centerSubTextStyle:
              TextStyle(fontSize: 10.0, color: yTextColors[i])));
    }

    _focusChartBeanMain = FocusChartBeanMain();
    for (var i = 0; i < 60; i++) {
      _beanList
          .add(ChartBeanFocus(focus: Random().nextDouble() * 100, second: i));
    }
    _focusChartBeanMain.chartBeans = _beanList;
    // _focusChartBeanMain.gradualColors = [Color(0xFF17605C), Color(0x00549A97)];
    _focusChartBeanMain.lineWidth = 1;
    _focusChartBeanMain.isLinkBreak = false;
    _focusChartBeanMain.lineColor = Colors.transparent;
    _focusChartBeanMain.canvasEnd = () {
      _countdownTimer?.cancel();
      _countdownTimer = null;
      print("毁灭定时器");
    };
    //制造假数据结束
  }

  @override
  Widget build(BuildContext context) {
    if (_countdownTimer == null) {
      _countdownTimer = Timer.periodic(new Duration(seconds: 1), (timer) {
        double value = Random().nextDouble() * 100;
        _beanList.add(ChartBeanFocus(
            focus: value, second: _index > 10 ? (10 + _index) : _index));
        if (_childViewKey.currentState != null) {
          _focusChartBeanMain.chartBeans = _beanList;
          _childViewKey.currentState.changeBeanList([_focusChartBeanMain]);
        }
        _index++;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(FocusChartLinePage.title),
      ),
      body: _buildFocusChartLine(context),
    );
  }

  //FocusLine
  Widget _buildFocusChartLine(context) {
    var chartLine = ChartLineFocus(
      key: _childViewKey,
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.6),
      focusChartBeans: [_focusChartBeanMain],
      isShowHintX: true,
      isShowHintY: false,
      hintLineColor: Colors.blue,
      isHintLineImaginary: false,
      isLeftYDialSub: false,
      xMax: 60,
      yMax: 100.0,
      xDialValues: _xArr,
      yDialValues: _yArr,
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
    _countdownTimer?.cancel();
    _countdownTimer = null;
    print("毁灭");
    super.dispose();
  }
}
