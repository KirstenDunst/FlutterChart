/*
 * @Author: your name
 * @Date: 2020-09-30 10:40:00
 * @LastEditTime: 2021-09-22 10:35:07
 * @LastEditors: Cao Shixin
 * @Description: In User Settings Edit
 * @FilePath: /flutter_chart/example/lib/step_curve_line.dart
 */
import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class StepCurveLine extends StatefulWidget {
  static const String routeName = 'step_curve_line';
  static const String title = 'FN可点击拖拽显示该点的tip标签';

  const StepCurveLine({super.key});

  @override
  State<StepCurveLine> createState() => _StepCurveLineState();
}

class _StepCurveLineState extends State<StepCurveLine>
    with TickerProviderStateMixin {
  Offset? _offset;
  final GlobalKey<ChartLineFocusState> globalKey = GlobalKey();
  late ValueNotifier<ShowModel> _valueNotifier;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _valueNotifier = ValueNotifier(ShowModel(
        scale: 1.0,
        xArr: ['0', "30'", "60'"]
            .asMap()
            .map((key, value) => MapEntry(
                  key,
                  DialStyleX(
                    titleStyle:
                        const TextStyle(fontSize: 10.0, color: Colors.black),
                    title: value,
                    positionRetioy: key / 2,
                  ),
                ))
            .values
            .toList()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StepCurveLine.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ChangeNotifierProvider(
            create: (_) => ChartFocusLineProvider(),
            child: Consumer<ChartFocusLineProvider>(
                builder: (context, provider, child) {
              return provider.image == null
                  ? const SizedBox()
                  : SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: Stack(
                        children: [
                          GestureDetector(
                            onScaleUpdate: (details) {
                              if (kDebugMode) {
                                print(
                                    '>2>>>>>${details.horizontalScale}>>>>>>>>${details.localFocalPoint}');
                              }
                              var scale = (_valueNotifier.value.scale *
                                      details.horizontalScale)
                                  .clamp(1.0, 4.0);

                              _valueNotifier.value = ShowModel(
                                  scale: scale,
                                  xArr: scale > 3
                                      ? provider._xArr3
                                      : (scale > 2
                                          ? provider._xArr2
                                          : provider._xArr1));
                              if (_offset != null) {
                                globalKey.currentState?.clearTouchPoint();
                              }
                            },
                            child: ValueListenableBuilder<ShowModel>(
                              valueListenable: _valueNotifier,
                              builder: (context, value, child) => Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                margin: const EdgeInsets.only(
                                    left: 0, right: 0, top: 0, bottom: 0),
                                semanticContainer: true,
                                color: Colors.white,
                                clipBehavior: Clip.antiAlias,
                                child: RepaintBoundary(
                                  child: ChartLineFocus(
                                    key: globalKey,
                                    touchEnableNormalselect: false,
                                    size: Size(
                                        MediaQuery.of(context).size.width *
                                            value.scale,
                                        MediaQuery.of(context).size.height /
                                            5 *
                                            1.6),
                                    focusChartBeans: [
                                      provider.focusChartBeanMain
                                    ],
                                    baseBean: BaseBean(
                                      isShowHintX: true,
                                      isShowHintY: false,
                                      hintLineColor: Colors.blue,
                                      isHintLineImaginary: false,
                                      yMax: 70.0,
                                      yMin: 0.0,
                                      yDialValues: provider.yArr,
                                    ),
                                    xMax: 600,
                                    xDialValues: value.xArr,
                                    xSectionBeans: [
                                      SectionBean(
                                          textTitle: TextSetModel(
                                            title: '2314',
                                            titleStyle: const TextStyle(
                                                fontSize: 10.0,
                                                color: Colors.black),
                                          ),
                                          startRatio: 0.2,
                                          widthRatio: 0.01,
                                          fillColor: Colors.red,
                                          borderColor: Colors.orange,
                                          borderWidth: 5),
                                      SectionBean(
                                        imgTitle: ImgSetModel(
                                            img: provider.image!,
                                            imgSize: const Size(20, 20)),
                                        startRatio: 0.2,
                                        widthRatio: 0.01,
                                        fillColor: Colors.red,
                                        borderColor: Colors.orange,
                                      )
                                    ],
                                    touchSet: FocusLineTouchSet(
                                      outsidePointClear: false,
                                      pointSet: CellPointSet(
                                        pointShaderColors: [
                                          Colors.yellow,
                                          Colors.yellow
                                        ],
                                        pointSize: const Size(10, 10),
                                        pointRadius: const Radius.circular(5),
                                        hintEdgeInset: HintEdgeInset.all(
                                          PointHintParam(
                                              hintColor: Colors.blue,
                                              hintLineWidth: 2),
                                        ),
                                      ),
                                      touchBack: (point, value) {
                                        setState(() {
                                          _offset = point;
                                        });
                                        if (kDebugMode) {
                                          print('结果返回：$point>>>>$value');
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (_offset != null)
                            Positioned(
                              left: _offset!.dx,
                              top: _offset!.dy,
                              width: 20,
                              height: 20,
                              child: IgnorePointer(
                                child: Container(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
            }),
          ),
          const SizedBox(height: 50),
          GestureDetector(
            child: Container(
              width: 200,
              height: 60,
              color: Colors.orange,
              alignment: Alignment.center,
              child: const Text('点击取消图表标记'),
            ),
            onTap: () => globalKey.currentState?.clearTouchPoint(),
          ),
        ],
      ),
    );
  }
}

class ShowModel {
  double scale;
  List<DialStyleX> xArr;
  ShowModel({required this.scale, required this.xArr});
}

class ChartFocusLineProvider extends ChangeNotifier {
  List<DialStyleX> get xArr1 => _xArr1;
  List<DialStyleX> get xArr2 => _xArr2;
  List<DialStyleX> get xArr3 => _xArr3;
  List<DialStyleY> get yArr => _yArr;
  ui.Image? get image => _image;
  FocusChartBeanMain get focusChartBeanMain => _focusChartBeanMain;

  late List<ChartBeanFocus> _beanList;
  late FocusChartBeanMain _focusChartBeanMain;
  Timer? _countdownTimer;
  // int _index = 0;
  late List<DialStyleX> _xArr1, _xArr2, _xArr3;
  late List<DialStyleY> _yArr;
  ui.Image? _image;

  ChartFocusLineProvider() {
    _beanList = [];
    _xArr1 = [];
    _xArr2 = [];
    _xArr3 = [];
    _yArr = [];
    UIImageUtil.loadImage('assets/head1.png').then((value) {
      _image = value;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        notifyListeners();
      });
    });
    //制造假数据
    ['0', "30'", "60'"].asMap().forEach((key, value) {
      _xArr1.add(DialStyleX(
        titleStyle: const TextStyle(fontSize: 10.0, color: Colors.black),
        title: value,
        positionRetioy: key / 2,
      ));
    });
    ['0', "15'", "30'", "45'", "60'"].asMap().forEach((key, value) {
      _xArr2.add(DialStyleX(
        titleStyle: const TextStyle(fontSize: 10.0, color: Colors.black),
        title: value,
        positionRetioy: key / 4,
      ));
    });
    ['0', "8'", "15'", "23'", "30'", "38'", "45'", "53'", "60'"]
        .asMap()
        .forEach((key, value) {
      _xArr3.add(DialStyleX(
        titleStyle: const TextStyle(fontSize: 10.0, color: Colors.black),
        title: value,
        positionRetioy: key / 8,
      ));
    });
    var yValues = ['70', '25', '0'];
    var yTexts = ['忘我', '一般', ''];
    var yTextColors = [
      Colors.red,
      Colors.blue,
      Colors.blue,
    ];

    for (var i = 0; i < yValues.length; i++) {
      _yArr.add(DialStyleY(
          leftSub: DialStyleYSub(
              title: yValues[i],
              titleStyle: const TextStyle(fontSize: 10.0, color: Colors.black),
              centerSubTitle: yTexts[i],
              centerSubTextStyle:
                  TextStyle(fontSize: 10.0, color: yTextColors[i])),
          positionRetioy: double.parse(yValues[i]) / 70.0,
          yValue: double.parse(yValues[i])));
    }

    _focusChartBeanMain = FocusChartBeanMain();
    for (var i = 0; i <= 600; i++) {
      var value = Random().nextDouble() * 100;
      _beanList.add(
          ChartBeanFocus(focus: value, second: i, touchBackValue: '测试传递$i'));
    }
    _focusChartBeanMain.chartBeans = _beanList;
    _focusChartBeanMain.lineShader = LineShaderSetModel(
        baseLineTopGradient: LinearGradientModel(
            shaderColors: [const Color(0xFF17605C), const Color(0x00549A97)]));
    _focusChartBeanMain.lineWidth = 1;
    _focusChartBeanMain.isCurve = false;
    _focusChartBeanMain.touchEnable = true;
    _focusChartBeanMain.isLinkBreak = false;
    _focusChartBeanMain.lineColor = Colors.red;
    _focusChartBeanMain.canvasEnd = () {
      _countdownTimer?.cancel();
      _countdownTimer = null;
      if (kDebugMode) {
        print('毁灭定时器');
      }
    };
    //制造假数据结束
    // _loadNewData();
  }

  // void _loadNewData() {
  //   _beanList.clear();
  //   _countdownTimer ??= Timer.periodic(Duration(seconds: 1), (timer) {
  //     if (_index == 0) {
  //       _beanList.clear();
  //     }
  //     var value = Random().nextDouble() * 100;
  //     _beanList.add(ChartBeanFocus(
  //         focus: value, second: _index > 10 ? (10 + _index) : _index));
  //     _focusChartBeanMain.chartBeans = _beanList;
  //     _index++;
  //     notifyListeners();
  //   });
  //   _countdownTimer?.cancel();
  //   _countdownTimer = null;
  // }

  // 不要忘记在这里释放掉Timer
  @override
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    if (kDebugMode) {
      print('毁灭');
    }
    super.dispose();
  }
}
