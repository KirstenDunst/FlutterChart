/*
 * @Author: Cao Shixin
 * @Date: 2020-07-02 17:04:10
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-07-03 10:43:58
 * @Description: 双专注力曲线显示
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */

import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chart/flutter_chart.dart';

class FNDoubleLinePage extends StatefulWidget {
  static const String routeName = 'focus_chart_double_line';
  static const String title = 'FN大师竞赛双专注力样式图';
  FNDoubleLinePage({Key key}) : super(key: key);

  @override
  _FNDoubleLinePageState createState() => _FNDoubleLinePageState();
}

class _FNDoubleLinePageState extends State<FNDoubleLinePage> {
  GlobalKey<ChartLineFocusState> _childViewKey =
      new GlobalKey<ChartLineFocusState>();
  List<ChartBeanFocus> _beanList1 = [], _beanList2 = [];
  FocusChartBeanMain _focusChartBeanMain1, _focusChartBeanMain2;
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

    _focusChartBeanMain1 = FocusChartBeanMain();
    _focusChartBeanMain2 = FocusChartBeanMain();
    for (var i = 0; i <= 60; i++) {
      _beanList1.add(ChartBeanFocus(focus: Random().nextDouble() * 100, second: i));
      _beanList2.add(ChartBeanFocus(focus: Random().nextDouble() * 100, second: i));
    }
    _focusChartBeanMain1.chartBeans = _beanList1;
    _focusChartBeanMain1.gradualColors = [Color(0xFF17605C), Color(0x00549A97)];
    _focusChartBeanMain1.lineWidth = 1;
    _focusChartBeanMain1.isLinkBreak = false;
    _loadImage('assets/head1.jpg').then((value) {
      _focusChartBeanMain1.centerPoint = value;
      setState(() {});
    });
    _focusChartBeanMain1.lineColor = Colors.blue;
    _focusChartBeanMain1.canvasEnd = () {
      _countdownTimer?.cancel();
      _countdownTimer = null;
      print("毁灭定时器");
    };
    _focusChartBeanMain2.chartBeans = _beanList2;
    _focusChartBeanMain2.gradualColors = [Color(0xFFFF605C), Color(0x00FF9A97)];
    _focusChartBeanMain2.lineWidth = 1;
    _focusChartBeanMain2.isLinkBreak = false;
    _loadImage('assets/head2.jpeg').then((value) {
      _focusChartBeanMain2.centerPoint = value;
      setState(() {});
    });
    _focusChartBeanMain2.lineColor = Colors.red;
    _focusChartBeanMain2.canvasEnd = () {
      _countdownTimer?.cancel();
      _countdownTimer = null;
      print("毁灭定时器");
    };
    //制造假数据结束
  }

  /// 加载图片
  Future<ui.Image> _loadImage(String path) async {
    var data = await rootBundle.load(path);
    var codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    var info = await codec.getNextFrame();
    
    return info.image;
  }

  @override
  Widget build(BuildContext context) {
    if (_countdownTimer == null) {
      _countdownTimer = Timer.periodic(new Duration(seconds: 1), (timer) {
        double value = Random().nextDouble() * 100;
        _beanList1.add(ChartBeanFocus(
            focus: value, second: _index > 10 ? (10 + _index) : _index));

        double value2 = Random().nextDouble() * 100;
        _beanList2.add(ChartBeanFocus(
            focus: value2, second: _index > 10 ? (10 + _index) : _index));
        if (_childViewKey.currentState != null) {
          _focusChartBeanMain1.chartBeans = _beanList1;
          _focusChartBeanMain2.chartBeans = _beanList2;
          _childViewKey.currentState
              .changeBeanList([_focusChartBeanMain1, _focusChartBeanMain2]);
        }
        _index++;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(FNDoubleLinePage.title),
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
      focusChartBeans: [_focusChartBeanMain1, _focusChartBeanMain2],
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
