/*
 * @Author: Cao Shixin
 * @Date: 2020-05-27 11:08:14
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2022-06-23 18:41:55
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */

import 'dart:async';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class FocusChartLinePage extends StatefulWidget {
  static const String routeName = 'focus_chart_line';
  static const String title = 'FN单专注力样式图';
  @override
  _FocusChartLineState createState() => _FocusChartLineState();
}

class _FocusChartLineState extends State<FocusChartLinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FocusChartLinePage.title),
      ),
      body: ChangeNotifierProvider(
        create: (_) => ChartFocusLineProvider(),
        child: Consumer<ChartFocusLineProvider>(
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
              focusChartBeans: [provider.focusChartBeanMain],
              baseBean: BaseBean(
                isShowHintX: true,
                isShowHintY: false,
                hintLineColor: Colors.blue,
                isHintLineImaginary: false,
                isLeftYDialSub: false,
                yMax: 70.0,
                yMin: 0.0,
                yDialValues: provider.yArr,
              ),
              xSectionBeans: provider.xSectionBeans,
              ySectionBeans: [
                SectionBeanY(
                    startRatio: 0.0,
                    widthRatio: 0.3,
                    fillColor: Colors.red,
                    borderColor: Colors.orange,
                    borderWidth: 5,
                    isBorderSolid: false),
                SectionBeanY(
                    startRatio: 0.3,
                    widthRatio: 0.3,
                    fillColor: Colors.orange,
                    borderColor: Colors.yellow,
                    borderWidth: 5,
                    isBorderSolid: false),
                SectionBeanY(
                    startRatio: 0.6,
                    widthRatio: 0.4,
                    fillColor: Colors.yellow,
                    borderColor: Colors.blue,
                    borderWidth: 5,
                    isBorderSolid: false)
              ],
              xMax: 60,
              xDialValues: provider.xArr,
            ),
            clipBehavior: Clip.antiAlias,
          );
        }),
      ),
    );
  }
}

class ChartFocusLineProvider extends ChangeNotifier {
  List<SectionBean> get xSectionBeans => _xSectionBeans;
  List<DialStyleX> get xArr => _xArr;
  List<DialStyleY> get yArr => _yArr;
  FocusChartBeanMain get focusChartBeanMain => _focusChartBeanMain;

  List<ChartBeanFocus> _beanList;
  FocusChartBeanMain _focusChartBeanMain;
  Timer _countdownTimer;
  int _index = 0;
  List<DialStyleX> _xArr;
  List<DialStyleY> _yArr;
  List<SectionBean> _xSectionBeans;

  ChartFocusLineProvider() {
    _beanList = [];
    _xArr = [];
    _yArr = [];
    //制造假数据
    var yValues = ['70', '25', '0'];
    var xValues = ['0', "20'", "60'"];
    var xPositionRetioy = [0.0, 0.33, 1.0];
    var yTexts = ['', '一般', '忘我'];
    var yTextColors = [
      Colors.blue,
      Colors.blue,
      Colors.red,
    ];

    for (var i = 0; i < yValues.length; i++) {
      _xArr.add(DialStyleX(
        titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
        title: xValues[i],
        positionRetioy: xPositionRetioy[i],
      ));
      _yArr.add(DialStyleY(
          title: yValues[i],
          titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
          centerSubTitle: yTexts[i],
          positionRetioy: 1 - double.parse(yValues[i]) / 70.0,
          centerSubTextStyle:
              TextStyle(fontSize: 10.0, color: yTextColors[i])));
    }

    _focusChartBeanMain = FocusChartBeanMain();
    for (var i = 0; i < 30; i++) {
      _beanList.add(
          ChartBeanFocus(focus: Random().nextDouble() * 100, second: i + 30));
    }
    _focusChartBeanMain.chartBeans = _beanList;
    // _focusChartBeanMain.gradualColors = [Color(0xFF17605C), Color(0x00549A97)];
    _focusChartBeanMain.lineWidth = 1;
    _focusChartBeanMain.isLinkBreak = false;
    _focusChartBeanMain.lineColor = Colors.red;
    _focusChartBeanMain.canvasEnd = () {
      _countdownTimer?.cancel();
      _countdownTimer = null;
      print('毁灭定时器');
    };

    _xSectionBeans = [
      SectionBean(
          title: '训练1',
          titleStyle: TextStyle(color: Colors.red, fontSize: 10),
          startRatio: 0.1,
          widthRatio: 0.2,
          fillColor: Colors.orange.withOpacity(0.2),
          borderColor: Colors.red,
          borderWidth: 2,
          isBorderSolid: false),
      SectionBean(
          title: '训练2',
          titleStyle: TextStyle(color: Colors.red, fontSize: 10),
          startRatio: 0.4,
          widthRatio: 0.05,
          fillColor: Colors.orange.withOpacity(0.2)),
      SectionBean(
          title: '训练3',
          titleStyle: TextStyle(color: Colors.red, fontSize: 10),
          startRatio: 0.7,
          widthRatio: 0.2,
          fillColor: Colors.orange.withOpacity(0.2))
    ];
    //制造假数据结束
    _loadNewData();
  }

  void _loadNewData() {
    _countdownTimer ??= Timer.periodic(Duration(seconds: 1), (timer) {
      if (_index == 0) {
        _beanList.clear();
      }
      var value = Random().nextDouble() * 100;
      _beanList.add(ChartBeanFocus(
        focus: value,
        second: _index > 10 ? (10 + _index) : _index,
      ));
      _focusChartBeanMain.chartBeans = _beanList;
      _index++;
      notifyListeners();
    });
  }

  // 不要忘记在这里释放掉Timer
  @override
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    print('毁灭');
    super.dispose();
  }
}
