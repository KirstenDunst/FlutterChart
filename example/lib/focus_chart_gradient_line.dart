/*
 * @Author: Cao Shixin
 * @Date: 2022-10-21 14:02:45
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2023-03-28 15:16:30
 * @Description: 
 */
import 'dart:async';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class FocusChartGradientLinePage extends StatefulWidget {
  static const String routeName = 'focus_chart_gradient_line';
  static const String title = 'FN专注力颜色渐变曲线';
  @override
  _FocusChartGradientLineState createState() => _FocusChartGradientLineState();
}

class _FocusChartGradientLineState extends State<FocusChartGradientLinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(FocusChartGradientLinePage.title)),
      body: ChangeNotifierProvider(
        create: (_) => ChartFocusLineProvider(),
        child: Consumer<ChartFocusLineProvider>(
            builder: (context, provider, child) {
          return provider.focusChartBeanMains.isEmpty
              ? Container()
              : ListView(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      margin: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      semanticContainer: true,
                      color: Colors.white,
                      child: Stack(
                        children: [
                          ChartLineFocus(
                            size: Size(MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height / 5 * 2.5),
                            focusChartBeans: [
                              provider.focusChartBeanMains.first
                            ],
                            baseBean: BaseBean(
                              isShowHintX: true,
                              isShowHintY: false,
                              hintLineColor: Colors.blue,
                              isHintLineImaginary: false,
                              isLeftYDial: false,
                              isLeftYDialSub: false,
                              yMax: 70.0,
                              yMin: 0.0,
                              rulerWidth: -4,
                              isShowXScale: true,
                              yDialValues: provider.yArr,
                            ),
                            xMax: 60,
                            xDialValues: provider.xArr,
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                    ),
                    SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      margin: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      semanticContainer: true,
                      color: Colors.white,
                      child: Stack(
                        children: [
                          ChartLineFocus(
                            size: Size(MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height / 5 * 2.5),
                            focusChartBeans: [
                              provider.focusChartBeanMains.first
                            ],
                            baseBean: BaseBean(
                              isShowHintX: true,
                              isShowHintY: false,
                              hintLineColor: Colors.blue,
                              isHintLineImaginary: false,
                              isLeftYDial: false,
                              isLeftYDialSub: false,
                              rulerWidth: -4,
                              isShowXScale: true,
                              yDialValues: provider.reverseYarr,
                            ),
                            xMax: 60,
                            xDialValues: provider.xArr,
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
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
  List<DialStyleY> get reverseYarr => _reverseYarr;
  List<FocusChartBeanMain> get focusChartBeanMains => _focusChartBeanMains;

  List<FocusChartBeanMain> _focusChartBeanMains;
  List<DialStyleX> _xArr;
  List<DialStyleY> _yArr, _reverseYarr;

  ChartFocusLineProvider() {
    _focusChartBeanMains = [];

    _xArr = [];
    _yArr = [];
    _reverseYarr = [];
    //制造假数据
    var yValues = ['100', '66', '33', '0'];
    var xValues = ['0', "20'", "40'", "60'"];
    var xPositionRetioy = [0.0, 0.33, 0.66, 1.0];
    var yTexts = ['Relaxed', 'Neutral', 'Active', ''];
    var yTextColors = [
      Colors.blue,
      Colors.yellow,
      Colors.red,
      Colors.red,
    ];

    for (var i = 0; i < yValues.length; i++) {
      _xArr.add(DialStyleX(
        titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
        title: xValues[i],
        positionRetioy: xPositionRetioy[i],
      ));
      _reverseYarr.add(DialStyleY(
          title: yValues[i],
          titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
          centerSubTitle: yTexts[yTexts.length - 1 - i],
          positionRetioy: 1 - double.parse(yValues[i]) / 100.0,
          hintLineColor: i == yValues.length - 1
              ? Colors.transparent
              : (i == yValues.length - 2 ? Colors.orange : null),
          fillColors: yTexts[yTexts.length - 1 - i] == 'Relaxed'
              ? [Colors.blue.withOpacity(0.3), Colors.blue.withOpacity(0.1)]
              : null,
          centerSubTextStyle: TextStyle(
              fontSize: 10.0, color: yTextColors[yTextColors.length - 1 - i])));

      _yArr.add(DialStyleY(
          title: yValues[i],
          titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
          centerSubTitle: yTexts[i],
          positionRetioy: double.parse(yValues[i]) / 100.0,
          centerSubTextStyle:
              TextStyle(fontSize: 10.0, color: yTextColors[i])));
    }
    _loadData();
  }

  Future _loadData() async {
    var image = await UIImageUtil.loadImage('assets/head1.png');
    for (var i = 0; i < 1; i++) {
      var _focusChartBeanMain = FocusChartBeanMain();
      // _focusChartBeanMain.gradualColors = [
      //   Colors.transparent,
      //   Colors.transparent
      // ];
      _focusChartBeanMain.lineWidth = 5;
      _focusChartBeanMain.isLinkBreak = false;
      _focusChartBeanMain.lineColor = Colors.red;
      //此处设置lineGradient,则上面的lineColor已经意义不大了
      _focusChartBeanMain.lineGradient = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          tileMode: TileMode.mirror,
          colors: [
            Colors.red,
            Colors.red,
            Colors.yellow,
            Colors.yellow,
            Colors.blue,
            Colors.blue
          ],
          stops: [
            0.0,
            0.32,
            0.34,
            0.65,
            0.67,
            1.0
          ]);
      _focusChartBeanMain.canvasEnd = () {
        print('小伙子，你画到头了');
      };
      var tempArr = [30, 50];
      var _beanList = <ChartBeanFocus>[];
      for (var i = 0; i < 60; i++) {
        if (i < 10) {
          continue;
        }
        _beanList.add(ChartBeanFocus(
          focus: Random().nextDouble() * 100,
          second: i,
          tag: '$i',
          cellPointSet: i == 40
              ? CellPointSet(
                  pointType: PointType.PlacehoderImage,
                  placeImageSize: Size(15, 15),
                  placehoderImage: image,
                  hintEdgeInset: HintEdgeInset.only(
                    left: PointHintParam(
                        hintColor: Colors.red, isHintLineImaginary: true),
                    right: PointHintParam(
                        hintColor: Colors.deepPurple,
                        isHintLineImaginary: true),
                    top: PointHintParam(
                        hintColor: Colors.green, isHintLineImaginary: false),
                    bottom: PointHintParam(
                        hintColor: Colors.cyan, isHintLineImaginary: true),
                  ),
                )
              : (tempArr.contains(i)
                  ? CellPointSet(
                      pointSize: Size(6, 6),
                      pointRadius: Radius.circular(3),
                      pointShaderColors: i == 30
                          ? [Colors.cyan, Colors.cyan]
                          : [Colors.orange, Colors.orange],
                      hintEdgeInset: HintEdgeInset.only(
                        top: PointHintParam(
                            hintColor: Color(0xFF779795),
                            isHintLineImaginary: false),
                        bottom: PointHintParam(
                            hintColor: Color(0xFF779795),
                            isHintLineImaginary: true),
                      ),
                    )
                  : CellPointSet.normal),
        ));
      }
      _focusChartBeanMain.chartBeans = _beanList;
      _focusChartBeanMains.add(_focusChartBeanMain);
    }
    notifyListeners();
  }
}
