/*
 * @Author: Cao Shixin
 * @Date: 2020-07-02 17:04:10
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-12-08 16:31:06
 * @Description: 双专注力曲线显示
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */

import 'dart:async';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

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
              baseBean: BaseBean(
                basePadding:
                    EdgeInsets.only(left: 20, bottom: 10, right: 20, top: 10),
                isShowHintX: true,
                isShowHintY: false,
                hintLineColor: Colors.blue,
                isHintLineImaginary: false,
                isLeftYDialSub: false,
                xColor: Colors.black,
                yColor: Colors.black,
                yMax: 100.0,
                yDialValues: provider.yArr,
              ),
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

class ChartFocusDoubleLineProvider extends ChangeNotifier {
  List<DialStyleX> get xArr => _xArr;
  List<DialStyleY> get yArr => _yArr;
  List<FocusChartBeanMain> get focusChartBeanMains => [
        _focusChartBeanMain1,
        _focusChartBeanMain2,
      ];

  FocusChartBeanMain _focusChartBeanMain1, _focusChartBeanMain2;
  Timer _countdownTimer;
  int _index = 0;
  List<DialStyleX> _xArr;
  List<DialStyleY> _yArr;
  List<ChartBeanFocus> _beanList1, _beanList2;

  ChartFocusDoubleLineProvider() {
    _yArr = [];
    _xArr = [];
    _beanList1 = [];
    _beanList2 = [];
    //制造假数据
    //制造假数据
    var yValues = ['100', '65', '35', '0'];
    var xValues = ['0', "20'", "40'", "60'"];
    var xPositionRetioy = [0.0, 0.33, 0.66, 1.0];
    var yTexts = ['忘我', '一般', '走神', ''];
    var yTextColors = [
      Color(0xEEF75E36),
      Color(0xEEFFC278),
      Color(0xEE172B88),
      Color(0xEE172B88),
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
          positionRetioy: double.parse(yValues[i]) / 100.0,
          centerSubTextStyle:
              TextStyle(fontSize: 10.0, color: yTextColors[i])));
    }

    _focusChartBeanMain1 = FocusChartBeanMain(
        showLineSection: true,
        sectionModel: LineSectionModel(),
        gradualColors: [Colors.orange, Colors.orange],
        lineWidth: 1,
        isLinkBreak: false,
        lineColor: Colors.blue);
    _focusChartBeanMain2 = FocusChartBeanMain(
        gradualColors: [Color(0xFFFF605C), Color(0x00FF9A97)],
        lineWidth: 1,
        isLinkBreak: false,
        lineColor: Colors.red,
        isLineImaginary: true);
    for (var i = 0; i <= 30; i++) {
      var focusValue = Random().nextDouble() * 100;
      _beanList1.add(ChartBeanFocus(focus: focusValue, second: i));
      _beanList2
          .add(ChartBeanFocus(focus: Random().nextDouble() * 100, second: i));
    }
    _focusChartBeanMain1.chartBeans = _beanList1;
    _focusChartBeanMain2.chartBeans = _beanList2;
    _focusChartBeanMain2.canvasEnd = () {
      _countdownTimer?.cancel();
      _countdownTimer = null;
      print('毁灭定时器4');
    };
    //制造假数据结束
    _loadNewData();
  }

  void _loadNewData() async {
    var _image1 = await UIImageUtil.loadImage('assets/head1.png');
    var _image2 = await UIImageUtil.loadImage('assets/head2.jpeg');
    _index = 0;
    _beanList1.clear();
    _beanList2.clear();
    _countdownTimer ??= Timer.periodic(Duration(seconds: 1), (timer) {
      if (_beanList1.isNotEmpty) {
        var model = _beanList1.last;
        model.centerPoint = null;
      }
      if (_beanList2.isNotEmpty) {
        var model = _beanList2.last;
        model.centerPoint = null;
      }
      var value = Random().nextDouble() * 100;
      _beanList1.add(ChartBeanFocus(
          focus: value,
          focusMax: value + 5,
          focusMin: value - 5,
          second: _index > 10 ? (10 + _index) : _index,
          centerPoint: _image1,
          centerPointSize: Size(20, 20),
          centerPointOffsetLineColor: Colors.blue,
          centerPointOffset: Offset(0, -20)));

      var value2 = Random().nextDouble() * 100;
      _beanList2.add(ChartBeanFocus(
          focus: value2,
          second: _index > 10 ? (10 + _index) : _index,
          centerPoint: _image2,
          centerPointSize: Size(20, 20),
          centerPointOffsetLineColor: Colors.red,
          centerPointOffset: Offset(0, -20)));
      _focusChartBeanMain1.chartBeans = _beanList1;
      _focusChartBeanMain2.chartBeans = _beanList2;
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
