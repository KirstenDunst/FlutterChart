import 'dart:async';
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
  final GlobalKey<ChartLineFocusState> globalKey = GlobalKey();
  final ValueNotifier<Offset> pointNotifier1 = ValueNotifier(null);
  final ValueNotifier<Offset> pointNotifier2 = ValueNotifier(null);

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
                            key: globalKey,
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
                              isLeftYDialSub: false,
                              yMax: 70.0,
                              yMin: 0.0,
                              yDialValues: provider.yArr,
                            ),
                            xMax: 60,
                            xDialValues: provider.xArr,
                            paintEnd: () {
                              WidgetsBinding.instance
                                  ?.addPostFrameCallback((timeStamp) {
                                var model =
                                    globalKey.currentState.searchWithTag('30');
                                print(
                                    '>>>>>>${model.backValue}>>>>${model.pointOffset}>>>>${model.xyTopLeftOffset}');
                                pointNotifier1.value = model.pointOffset;
                                pointNotifier2.value = model.xyTopLeftOffset;
                              });
                            },
                          ),
                          ValueListenableBuilder<Offset>(
                            valueListenable: pointNotifier1,
                            builder: (context, offset, child) => offset != null
                                ? Positioned(
                                    child: Container(
                                        width: 10,
                                        height: 10,
                                        color: Colors.red),
                                    top: offset.dy,
                                    left: offset.dx)
                                : Container(),
                          ),
                          ValueListenableBuilder<Offset>(
                            valueListenable: pointNotifier2,
                            builder: (context, offset, child) => offset != null
                                ? Positioned(
                                    child: Container(
                                        width: 10,
                                        height: 10,
                                        color: Colors.orange),
                                    top: offset.dy,
                                    left: offset.dx)
                                : Container(),
                          )
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                    ),
                    SizedBox(
                      height: 1000,
                    )
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
  List<FocusChartBeanMain> get focusChartBeanMains => _focusChartBeanMains;

  List<FocusChartBeanMain> _focusChartBeanMains;
  List<DialStyleX> _xArr;
  List<DialStyleY> _yArr;

  ChartFocusLineProvider() {
    _focusChartBeanMains = [];

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
    _loadData();
  }

  Future _loadData() async {
    var image = await UIImageUtil.loadImage('assets/head1.png');
    for (var i = 0; i < 1; i++) {
      var _focusChartBeanMain = FocusChartBeanMain();
      _focusChartBeanMain.gradualColors = [
        Color(0xFF17605C),
        Color(0x00549A97)
      ];
      _focusChartBeanMain.lineWidth = 1;
      _focusChartBeanMain.isLinkBreak = false;
      _focusChartBeanMain.lineColor = Colors.red;
      _focusChartBeanMain.canvasEnd = () {
        print('小伙子，你画到头了');
      };
      var tempArr = [30, 50];
      var _beanList = <ChartBeanFocus>[];
      for (var i = 0; i < 60; i++) {
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
          // centerPointOffsetLineColor: Colors.transparent,
        ));
      }
      _focusChartBeanMain.chartBeans = _beanList;
      _focusChartBeanMains.add(_focusChartBeanMain);
    }
    notifyListeners();
  }
}
