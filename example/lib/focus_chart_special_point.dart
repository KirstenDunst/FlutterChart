import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class FocusChartSpecialPointPage extends StatefulWidget {
  static const String routeName = 'focus_chart_special_point';
  static const String title = 'FN专注力特殊点样式图';

  const FocusChartSpecialPointPage({super.key});
  @override
  State<FocusChartSpecialPointPage> createState() => _FocusChartLineState();
}

class _FocusChartLineState extends State<FocusChartSpecialPointPage> {
  final GlobalKey<ChartLineFocusState> globalKey = GlobalKey();
  final ValueNotifier<Offset?> pointNotifier1 = ValueNotifier(null);
  final ValueNotifier<Offset?> pointNotifier2 = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(FocusChartSpecialPointPage.title),
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
                      margin: const EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      semanticContainer: true,
                      color: Colors.white,
                      clipBehavior: Clip.antiAlias,
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
                                yMax: 70.0,
                                yMin: 0.0,
                                yDialValues: provider.yArr,
                                yDialLeftMain: false),
                            xMax: 60,
                            xDialValues: provider.xArr,
                            paintEnd: () {
                              WidgetsBinding.instance
                                  .addPostFrameCallback((timeStamp) {
                                var model =
                                    globalKey.currentState?.searchWithTag('30');
                                if (kDebugMode) {
                                  print(
                                      '>>>>>>${model?.backValue}>>>>${model?.pointOffset}>>>>${model?.xyTopLeftOffset}');
                                }
                                pointNotifier1.value = model?.pointOffset;
                                pointNotifier2.value = model?.xyTopLeftOffset;
                              });
                            },
                          ),
                          ValueListenableBuilder<Offset?>(
                            valueListenable: pointNotifier1,
                            builder: (context, offset, child) => offset != null
                                ? Positioned(
                                    top: offset.dy,
                                    left: offset.dx,
                                    child: Container(
                                        width: 10,
                                        height: 10,
                                        color: Colors.red))
                                : Container(),
                          ),
                          ValueListenableBuilder<Offset?>(
                            valueListenable: pointNotifier2,
                            builder: (context, offset, child) => offset != null
                                ? Positioned(
                                    top: offset.dy,
                                    left: offset.dx,
                                    child: Container(
                                        width: 10,
                                        height: 10,
                                        color: Colors.orange))
                                : Container(),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 1000)
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

  late List<FocusChartBeanMain> _focusChartBeanMains;
  late List<DialStyleX> _xArr;
  late List<DialStyleY> _yArr;

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
        titleStyle: const TextStyle(fontSize: 10.0, color: Colors.black),
        title: xValues[i],
        positionRetioy: xPositionRetioy[i],
      ));
      _yArr.add(DialStyleY(
        leftSub: DialStyleYSub(
          title: yValues[i],
          titleStyle: const TextStyle(fontSize: 10.0, color: Colors.black),
        ),
        rightSub: DialStyleYSub(
          centerSubTitle: yTexts[i],
          centerSubTextStyle: TextStyle(fontSize: 10.0, color: yTextColors[i]),
        ),
        positionRetioy: double.parse(yValues[i]) / 70.0,
        yValue: double.parse(yValues[i]),
      ));
    }
    _loadData();
  }

  Future _loadData() async {
    var image = await UIImageUtil.loadImage('assets/head1.png');
    for (var i = 0; i < 1; i++) {
      var focusChartBeanMain = FocusChartBeanMain();
      focusChartBeanMain.lineShader = LineShaderSetModel(
        baseLineTopGradient: LinearGradientModel(
            shaderColors: [const Color(0xFF17605C), const Color(0x00549A97)]),
        baseLineY: 30,
        baseLineBottomGradient: LinearGradientModel(
            shaderColors: [Colors.red.withOpacity(0.01), Colors.red]),
            // shaderIsContentFill: false
      );
      focusChartBeanMain.lineWidth = 1;
      focusChartBeanMain.isLinkBreak = false;
      focusChartBeanMain.lineColor = Colors.red;
      focusChartBeanMain.canvasEnd = () {
        if (kDebugMode) {
          print('小伙子，你画到头了');
        }
      };
      var tempArr = [30, 50];
      var beanList = <ChartBeanFocus>[];
      for (var i = 0; i < 60; i++) {
        beanList.add(ChartBeanFocus(
          focus: Random().nextDouble() * 100,
          second: i,
          tag: '$i',
          cellPointSet: i == 40
              ? CellPointSet(
                  pointType: PointType.PlacehoderImage,
                  placeImageSize: const Size(15, 15),
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
                      pointSize: const Size(6, 6),
                      pointRadius: const Radius.circular(3),
                      pointShaderColors: i == 30
                          ? [Colors.cyan, Colors.cyan]
                          : [Colors.orange, Colors.orange],
                      hintEdgeInset: HintEdgeInset.only(
                        top: PointHintParam(
                            hintColor: const Color(0xFF779795),
                            isHintLineImaginary: false),
                        bottom: PointHintParam(
                            hintColor: const Color(0xFF779795),
                            isHintLineImaginary: true),
                      ),
                    )
                  : CellPointSet.normal),
          // centerPointOffsetLineColor: Colors.transparent,
        ));
      }
      focusChartBeanMain.chartBeans = beanList;
      _focusChartBeanMains.add(focusChartBeanMain);
    }
    notifyListeners();
  }
}
