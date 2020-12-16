/*
 * @Author: your name
 * @Date: 2020-09-30 10:40:00
 * @LastEditTime: 2020-12-16 16:01:56
 * @LastEditors: Cao Shixin
 * @Description: In User Settings Edit
 * @FilePath: /flutter_chart/example/lib/step_curve_line.dart
 */
import 'dart:async';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class StepCurveLine extends StatefulWidget {
  static const String routeName = 'step_curve_line';
  static const String title = '折线可点击拖拽显示该点的tip标签';

  @override
  _StepCurveLineState createState() => _StepCurveLineState();
}

class _StepCurveLineState extends State<StepCurveLine> {
  Offset _offset;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StepCurveLine.title),
      ),
      body: ChangeNotifierProvider(
        create: (_) => ChartFocusLineProvider(),
        child: Consumer<ChartFocusLineProvider>(
            builder: (context, provider, child) {
          return Stack(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
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
                    isLeftYDialSub: true,
                    yMax: 70.0,
                    yDialValues: provider.yArr,
                  ),
                  xMax: 20,
                  xDialValues: provider.xArr,
                  isPressedHintDottedLine: true,
                  pressedHintLineColor: Colors.blue,
                  pressedHintLineWidth: 2,
                  pressedPointRadius: 5,
                  pointBack: (point, value) {
                    setState(() {
                      _offset = point;
                    });
                    print('结果返回：${point}>>>>${value}');
                  },
                ),
                clipBehavior: Clip.antiAlias,
              ),
              Positioned(
                child: IgnorePointer(
                  child: Container(
                    color: Colors.red,
                    // width: 20,
                    // height: 20,
                  ),
                ),
                left: _offset == null ? 100.0 : _offset.dx,
                top: _offset == null ? 100.0 : _offset.dy,
                width: 20,
                height: 20,
              ),
            ],
          );
        }),
      ),
    );
  }
}

class ChartFocusLineProvider extends ChangeNotifier {
  List<DialStyleX> get xArr => _xArr;
  List<DialStyleY> get yArr => _yArr;
  FocusChartBeanMain get focusChartBeanMain => _focusChartBeanMain;

  List<ChartBeanFocus> _beanList;
  FocusChartBeanMain _focusChartBeanMain;
  Timer _countdownTimer;
  int _index = 0;
  List<DialStyleX> _xArr;
  List<DialStyleY> _yArr;

  ChartFocusLineProvider() {
    _beanList = [];
    _xArr = [];
    _yArr = [];
    //制造假数据
    var yValues = ['70', '25', '0'];
    var xValues = ['0', "20'", "60'"];
    var xPositionRetioy = [0.0, 0.33, 1.0];
    var yTexts = ['忘我', '一般', ''];
    var yTextColors = [
      Colors.red,
      Colors.blue,
      Colors.blue,
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
          positionRetioy: double.parse(yValues[i]) / 70.0,
          centerSubTextStyle:
              TextStyle(fontSize: 10.0, color: yTextColors[i])));
    }

    _focusChartBeanMain = FocusChartBeanMain();
    for (var i = 0; i <= 20; i++) {
      var value = Random().nextDouble() * 100;
      _beanList.add(
          ChartBeanFocus(focus: value, second: i, touchBackValue: '测试传递$i'));
    }
    _focusChartBeanMain.chartBeans = _beanList;
    _focusChartBeanMain.gradualColors = [Color(0xFF17605C), Color(0x00549A97)];
    _focusChartBeanMain.lineWidth = 1;
    _focusChartBeanMain.isCurve = false;
    _focusChartBeanMain.touchEnable = true;
    _focusChartBeanMain.showSite = true;
    _focusChartBeanMain.isLinkBreak = false;
    _focusChartBeanMain.lineColor = Colors.red;
    _focusChartBeanMain.canvasEnd = () {
      _countdownTimer?.cancel();
      _countdownTimer = null;
      print('毁灭定时器');
    };
    //制造假数据结束
    // _loadNewData();
  }

  void _loadNewData() {
    _beanList.clear();
    _countdownTimer ??= Timer.periodic(Duration(seconds: 1), (timer) {
      if (_index == 0) {
        _beanList.clear();
      }
      var value = Random().nextDouble() * 100;
      _beanList.add(ChartBeanFocus(
          focus: value, second: _index > 10 ? (10 + _index) : _index));
      _focusChartBeanMain.chartBeans = _beanList;
      _index++;
      notifyListeners();
    });
    _countdownTimer?.cancel();
    _countdownTimer = null;
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
