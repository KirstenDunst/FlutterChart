/*
 * @Author: Cao Shixin
 * @Date: 2020-07-02 17:04:10
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-08-05 12:42:50
 * @Description: 双专注力曲线显示
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */

import 'dart:async';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart/flutter_chart.dart';

class FNDoubleLinePage extends StatefulWidget {
  static const String routeName = 'focus_chart_double_line';
  static const String title = 'FN大师竞赛双专注力样式图';
  FNDoubleLinePage({Key key}) : super(key: key);

  @override
  _FNDoubleLinePageState createState() => _FNDoubleLinePageState();
}

class _FNDoubleLinePageState extends State<FNDoubleLinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FNDoubleLinePage.title),
      ),
      body: ChangeNotifierProvider(
        create: (_) => ChartFocusDoubleLineProvider(),
        child: Consumer<ChartFocusDoubleLineProvider>(
            builder: (context, provider, child) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            semanticContainer: true,
            color: Colors.white,
            child: ChartLineFocus(
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height / 5 * 1.6),
              focusChartBeans: provider.focusChartBeanMains,
              isShowHintX: true,
              isShowHintY: false,
              hintLineColor: Colors.blue,
              isHintLineImaginary: false,
              isLeftYDialSub: false,
              xMax: 60,
              yMax: 100.0,
              xDialValues: provider.xArr,
              yDialValues: provider.yArr,
            ),
            clipBehavior: Clip.antiAlias,
          );
        }),
      ),
    );
  }
}

class ChartFocusDoubleLineProvider extends ChangeNotifier {
  List<DialStyle> get xArr => _xArr;
  List<DialStyle> get yArr => _yArr;
  List<FocusChartBeanMain> get focusChartBeanMains =>
      [_focusChartBeanMain1, _focusChartBeanMain2];

  FocusChartBeanMain _focusChartBeanMain1, _focusChartBeanMain2;
  Timer _countdownTimer;
  int _index = 0;
  List<DialStyle> _yArr = [], _xArr = [];
  List<ChartBeanFocus> _beanList1 = [], _beanList2 = [];

  ChartFocusDoubleLineProvider() {
    //制造假数据
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
      _beanList1
          .add(ChartBeanFocus(focus: Random().nextDouble() * 100, second: i));
      _beanList2
          .add(ChartBeanFocus(focus: Random().nextDouble() * 100, second: i));
    }
    _focusChartBeanMain1.chartBeans = _beanList1;
    _focusChartBeanMain1.gradualColors = [Color(0xFF17605C), Color(0x00549A97)];
    _focusChartBeanMain1.lineWidth = 1;
    _focusChartBeanMain1.isLinkBreak = false;
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

    _focusChartBeanMain2.lineColor = Colors.red;
    _focusChartBeanMain2.canvasEnd = () {
      _countdownTimer?.cancel();
      _countdownTimer = null;
      print("毁灭定时器");
    };
    //制造假数据结束
    _loadNewData();
  }

  void _loadNewData() async {
    await UIImageUtil.loadImage('assets/head1.jpg').then((value) {
      _focusChartBeanMain1.centerPoint = value;
    });
    await UIImageUtil.loadImage('assets/head2.jpeg').then((value) {
      _focusChartBeanMain2.centerPoint = value;
    });

    if (_countdownTimer == null) {
      _countdownTimer = Timer.periodic(new Duration(seconds: 1), (timer) {
        double value = Random().nextDouble() * 100;
        _beanList1.add(ChartBeanFocus(
            focus: value, second: _index > 10 ? (10 + _index) : _index));

        double value2 = Random().nextDouble() * 100;
        _beanList2.add(ChartBeanFocus(
            focus: value2, second: _index > 10 ? (10 + _index) : _index));
        _focusChartBeanMain1.chartBeans = _beanList1;
        _focusChartBeanMain2.chartBeans = _beanList2;
        _index++;
        notifyListeners();
      });
    }
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
