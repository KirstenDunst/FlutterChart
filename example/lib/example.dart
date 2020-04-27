import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chart/flutter_chart.dart';

//how to use chart
class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //性能调优可视化
      // showPerformanceOverlay:true,
      //手动关闭debug角标
      // debugShowCheckedModeBanner: false,
      home: AnnotatedRegion(
        child: RandomWords(),
        value: SystemUiOverlayStyle.light
            .copyWith(statusBarBrightness: Brightness.dark),
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
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
    return Scaffold(body:
    ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        //FN专注力样式图
        _buildFocusChartLine(context),
        //柱状顶部半圆型
        _buildChartBarCircle(context),
        //柱状图顶部自定义弧角
        _buildChartBarRound(context),
        //平滑曲线带填充颜色
        _buildChartCurve(context),
        //折线带填充颜色
        _buildChartLine(context),
        //双折线
        _buildDoubleChartLine(context),
        //饼状图
        _buildChartPie(context),
      ],
    ) ,);
  }

  @override
  void initState() {
    super.initState();
  }

  // 不要忘记在这里释放掉Timer
  @override
  void dispose() {
    countdownTimer?.cancel();
    countdownTimer = null;
    print("毁灭");
    super.dispose();
  }

  //FocusLine
  Widget _buildFocusChartLine(context) {
    //制造假数据
    _beanList.clear();
    for (var i = 0; i < 60; i++) {
      // _beanList.add(ChartBeanFocus(focus: Random().nextDouble()*100));
    }
    List yValues = ['100', '65', '35', '0'];
    List xValues = ["0", "20'", "40'", "60'"];
    List yTexts = ["忘我","一般","走神",''];
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
          title: xValues[i]));

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
      xMax: 60,
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

  ///curve
  Widget _buildChartCurve(context) {
    var chartLine = ChartLine(
      chartBeans: [
        ChartBean(x: '12-01', y: 30),
        ChartBean(x: '12-02', y: 88),
        ChartBean(x: '12-03', y: 20),
        ChartBean(x: '12-04', y: 67),
        ChartBean(x: '12-05', y: 10),
        ChartBean(x: '12-06', y: 40),
        ChartBean(x: '12-07', y: 10),
      ],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.6),
      isCurve: true,
      lineWidth: 4,
      lineColor: Colors.blueAccent,
      fontColor: Colors.white,
      xyColor: Colors.white,
      shaderColors: [
        Colors.blueAccent.withOpacity(0.3),
        Colors.blueAccent.withOpacity(0.1)
      ],
      fontSize: 12,
      yNum: 8,
      isAnimation: true,
      isReverse: false,
      isCanTouch: true,
      isShowPressedHintLine: true,
      pressedPointRadius: 4,
      pressedHintLineWidth: 0.5,
      pressedHintLineColor: Colors.white,
      duration: Duration(milliseconds: 2000),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.green.withOpacity(0.5),
      child: chartLine,
      clipBehavior: Clip.antiAlias,
    );
  }

  ///line
  Widget _buildChartLine(context) {
    var chartLine = ChartLine(
      chartBeans: [
        ChartBean(x: '12-01', y: 30),
        ChartBean(x: '12-02', y: 88),
        ChartBean(x: '12-03', y: 20),
        ChartBean(x: '12-04', y: 67),
        ChartBean(x: '12-05', y: 10),
        ChartBean(x: '12-06', y: 40),
        ChartBean(x: '12-07', y: 10),
      ],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.6),
      isCurve: false,
      lineWidth: 2,
      lineColor: Colors.yellow,
      fontColor: Colors.white,
      xyColor: Colors.white,
      shaderColors: [
        Colors.yellow.withOpacity(0.3),
        Colors.yellow.withOpacity(0.1)
      ],
      fontSize: 12,
      yNum: 8,
      isAnimation: true,
      isReverse: false,
      isCanTouch: true,
      isShowPressedHintLine: true,
      pressedPointRadius: 4,
      pressedHintLineWidth: 0.5,
      pressedHintLineColor: Colors.white,
      duration: Duration(milliseconds: 2000),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.yellow.withOpacity(0.4),
      child: chartLine,
      clipBehavior: Clip.antiAlias,
    );
  }

  Widget _buildDoubleChartLine(context) {
    var chartLine = ChartLine(
      chartBeans: [
        ChartBean(x: '3-01', y: 30, subY: 70),
        ChartBean(x: '3-02', y: 88, subY: 20),
        ChartBean(x: '3-03', y: 20, subY: 30),
        ChartBean(x: '3-04', y: 67, subY: 50),
        ChartBean(x: '3-05', y: 10, subY: 100),
        ChartBean(x: '3-06', y: 40, subY: 30),
        ChartBean(x: '3-07', y: 10, subY: 0),
      ],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.6),
      isCurve: false,
      lineWidth: 2,
      lineColor: Colors.cyan,
      subLineColor: Colors.red,
      fontColor: Colors.white,
      xyColor: Colors.white,
      fontSize: 12,
      yNum: 5,
      isAnimation: true,
      isReverse: false,
      isCanTouch: true,
      isShowPressedHintLine: true,
      isShowHintX: true,
      pressedPointRadius: 4,
      pressedHintLineWidth: 0.5,
      pressedHintLineColor: Colors.white,
      duration: Duration(milliseconds: 2000),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.blue.withOpacity(0.4),
      child: chartLine,
      clipBehavior: Clip.antiAlias,
    );
  }

  ///bar-circle
  Widget _buildChartBarCircle(context) {
    var chartBar = ChartBar(
      xDialValues: [
        ChartBeanX(title: '12-01', value: 30, gradualColor: [Colors.red,Colors.red]),
        ChartBeanX(title: '12-02', value: 100, gradualColor: [Colors.yellow,Colors.yellow]),
        ChartBeanX(title: '12-03', value: 70, gradualColor: [Colors.green,Colors.green]),
        ChartBeanX(title: '12-04', value: 70, gradualColor: [Colors.blue,Colors.blue]),
        ChartBeanX(title: '12-05', value: 30, gradualColor: [Colors.deepPurple,Colors.deepPurple]),
        ChartBeanX(title: '12-06', value: 90, gradualColor: [Colors.deepOrange,Colors.deepOrange]),
        ChartBeanX(title: '12-07', value: 50, gradualColor: [Colors.greenAccent,Colors.greenAccent])
      ],
      yDialValues: [
      ChartBeanY(
          title: '100',
          titleStyle: TextStyle(color: Colors.lightBlue, fontSize: 10),
          centerSubTitle: 'Calm',
          centerSubTextStyle: TextStyle(color: Colors.red, fontSize: 10),
          positionRetioy: 100 / 100),
      ChartBeanY(
          title: '65',
          titleStyle: TextStyle(color: Colors.lightBlue, fontSize: 10),
          centerSubTitle: 'Aware',
          centerSubTextStyle: TextStyle(color: Colors.red, fontSize: 10),
          positionRetioy: 65 / 100),
      ChartBeanY(
          title: '35',
          titleStyle: TextStyle(color: Colors.lightBlue, fontSize: 10),
          centerSubTitle: 'Focused',
          centerSubTextStyle: TextStyle(color: Colors.red, fontSize: 10),
          positionRetioy: 35 / 100)
    ],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.8),
      isShowX: true,
      yMax: 100.0,
      rectWidth: 50.0,
      fontColor: Colors.white,
      rectShadowColor: Colors.white.withOpacity(0.5),
      isReverse: false,
      isCanTouch: true,
      isShowTouchShadow: true,
      isShowTouchValue: true,
      rectRadiusTopLeft: 50,
      rectRadiusTopRight: 50,
      offsetLeftX: 16.0,
      duration: Duration(milliseconds: 1000),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.blue.withOpacity(0.4),
      child: chartBar,
      clipBehavior: Clip.antiAlias,
    );
  }

  ///bar-round
  Widget _buildChartBarRound(context) {
    var chartBar = ChartBar(
      xDialValues: [
        ChartBeanX(title: '12-01', value: 30, gradualColor: [Colors.red,Colors.red]),
        ChartBeanX(title: '12-02', value: 100, gradualColor: [Colors.yellow,Colors.yellow]),
        ChartBeanX(title: '12-03', value: 70, gradualColor: [Colors.green,Colors.green]),
        ChartBeanX(title: '12-04', value: 70, gradualColor: [Colors.blue,Colors.blue]),
        ChartBeanX(title: '12-05', value: 30, gradualColor: [Colors.deepPurple,Colors.deepPurple]),
        ChartBeanX(title: '12-06', value: 90, gradualColor: [Colors.deepOrange,Colors.deepOrange]),
        ChartBeanX(title: '12-07', value: 50, gradualColor: [Colors.greenAccent,Colors.greenAccent])
      ],
      yDialValues: [
      ChartBeanY(
          title: '100',
          titleStyle: TextStyle(color: Colors.lightBlue, fontSize: 10),
          centerSubTitle: 'Calm',
          centerSubTextStyle: TextStyle(color: Colors.red, fontSize: 10),
          positionRetioy: 100 / 100),
      ChartBeanY(
          title: '65',
          titleStyle: TextStyle(color: Colors.lightBlue, fontSize: 10),
          centerSubTitle: 'Aware',
          centerSubTextStyle: TextStyle(color: Colors.red, fontSize: 10),
          positionRetioy: 65 / 100),
      ChartBeanY(
          title: '35',
          titleStyle: TextStyle(color: Colors.lightBlue, fontSize: 10),
          centerSubTitle: 'Focused',
          centerSubTextStyle: TextStyle(color: Colors.red, fontSize: 10),
          positionRetioy: 35 / 100)
    ],
     size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.8),
      isShowX: true,
      yMax: 100.0,
      rectWidth: 50.0,
      fontColor: Colors.white,
      rectShadowColor: Colors.white.withOpacity(0.5),
      isReverse: false,
      isCanTouch: true,
      isShowTouchShadow: true,
      isShowTouchValue: true,
      rectRadiusTopLeft: 4,
      rectRadiusTopRight: 4,
      offsetLeftX: 16.0,
      duration: Duration(milliseconds: 1000),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.brown.withOpacity(0.6),
      child: chartBar,
      clipBehavior: Clip.antiAlias,
    );
  }

  ///pie
  Widget _buildChartPie(context) {
    var chartPie = ChartPie(
      chartBeans: [
        ChartPieBean(
            type: '话费',
            value: 180,
            color: Colors.blueGrey,
            assistTextStyle: TextStyle(fontSize: 12, color: Colors.blueGrey)),
        ChartPieBean(
            type: '零食',
            value: 10,
            color: Colors.deepPurple,
            assistTextStyle: TextStyle(fontSize: 12, color: Colors.deepPurple)),
        ChartPieBean(
            type: '衣服',
            value: 1,
            color: Colors.green,
            assistTextStyle: TextStyle(fontSize: 12, color: Colors.green)),
        ChartPieBean(
            type: '早餐',
            value: 10,
            color: Colors.blue,
            assistTextStyle: TextStyle(fontSize: 12, color: Colors.blue)),
        ChartPieBean(
            type: '水果',
            value: 10,
            color: Colors.red,
            assistTextStyle: TextStyle(fontSize: 12, color: Colors.red)),
        ChartPieBean(
            type: '你猜',
            value: 20,
            color: Colors.orange,
            assistTextStyle: TextStyle(fontSize: 12, color: Colors.red)),
      ],
      assistTextShowType: AssistTextShowType.CenterNamePercentage,
      assistBGColor: Color(0xFFF6F6F6),
      decimalDigits: 1,
      divisionWidth: 2,
      size: Size(
          MediaQuery.of(context).size.width, MediaQuery.of(context).size.width),
      R: MediaQuery.of(context).size.width / 3,
      centerR: 6,
      duration: Duration(milliseconds: 2000),
      centerColor: Colors.white,
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      color: Colors.orangeAccent.withOpacity(0.6),
      clipBehavior: Clip.antiAlias,
      borderOnForeground: true,
      child: chartPie,
    );
  }
}
