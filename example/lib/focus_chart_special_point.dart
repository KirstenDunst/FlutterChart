import 'dart:math';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class FocusChartSpecialPointPage extends StatefulWidget {
  static const String routeName = 'focus_chart_special_point';
  static const String title = 'FN专注力特殊点样式图';
  @override
  _FocusChartLineState createState() => _FocusChartLineState();
}

class _FocusChartLineState extends State<FocusChartSpecialPointPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FocusChartSpecialPointPage.title),
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

class ChartFocusLineProvider extends ChangeNotifier {
  List<DialStyleX> get xArr => _xArr;
  List<DialStyleY> get yArr => _yArr;
  FocusChartBeanMain get focusChartBeanMain => _focusChartBeanMain;

  List<ChartBeanFocus> _beanList;
  FocusChartBeanMain _focusChartBeanMain;
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
    _focusChartBeanMain.chartBeans = _beanList;
    _focusChartBeanMain.gradualColors = [Color(0xFF17605C), Color(0x00549A97)];
    _focusChartBeanMain.lineWidth = 1;
    _focusChartBeanMain.isLinkBreak = false;
    _focusChartBeanMain.lineColor = Colors.red;
    _focusChartBeanMain.canvasEnd = () {
      print('小伙子，你画到头了');
    };
    UIImageUtil.loadImage('assets/head1.png').then((value) {
      for (var i = 0; i < 60; i++) {
        _beanList.add(ChartBeanFocus(
            focus: Random().nextDouble() * 100,
            second: i,
            centerPoint: i == 40 ? value : null,
            hintEdgeInset: i == 40
                ? HintEdgeInset.only(
                    left: PointHintParam(
                        hintColor: Colors.red, isHintLineImaginary: true),
                    right: PointHintParam(
                        hintColor: Colors.deepPurple,
                        isHintLineImaginary: true),
                    top: PointHintParam(
                        hintColor: Colors.green, isHintLineImaginary: false),
                    bottom: PointHintParam(
                        hintColor: Colors.cyan, isHintLineImaginary: true),
                  )
                : null,
            centerPointSize: Size(15, 15)));
      }
      notifyListeners();
    });
  }
}
