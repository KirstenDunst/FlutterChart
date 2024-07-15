/*
 * @Author: Cao Shixin
 * @Date: 2020-07-02 17:04:10
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2021-09-22 08:45:22
 * @Description: 双专注力曲线显示
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */

import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class FNDoubleLinePage extends StatefulWidget {
  static const String routeName = 'focus_chart_double_line';
  static const String title = 'FN大师竞赛双专注力样式图';

  const FNDoubleLinePage({super.key});

  @override
  State<FNDoubleLinePage> createState() => _FNDoubleLinePageState();
}

class _FNDoubleLinePageState extends State<FNDoubleLinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(FNDoubleLinePage.title),
      ),
      body: ChangeNotifierProvider(
        create: (_) => ChartFocusDoubleLineProvider(),
        child: Consumer<ChartFocusDoubleLineProvider>(
            builder: (context, provider, child) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            semanticContainer: true,
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            child: ChartLineFocus(
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height / 5 * 1.6),
              focusChartBeans: provider.focusChartBeanMains,
              baseBean: BaseBean(
                basePadding: const EdgeInsets.only(
                    left: 20, bottom: 10, right: 20, top: 10),
                isShowHintX: true,
                isShowHintY: false,
                hintLineColor: Colors.blue,
                isHintLineImaginary: false,
                xColor: Colors.black,
                yColor: Colors.black,
                yMax: 100.0,
                yMin: 0.0,
                yDialValues: provider.yArr,
                yDialLeftMain: false,
              ),
              xMax: 60,
              xDialValues: provider.xArr,
            ),
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

  late FocusChartBeanMain _focusChartBeanMain1, _focusChartBeanMain2;
  Timer? _countdownTimer;
  late int _index;
  late List<DialStyleX> _xArr;
  late List<DialStyleY> _yArr;
  late List<ChartBeanFocus> _beanList1, _beanList2;

  ChartFocusDoubleLineProvider() {
    _index = 0;
    _yArr = [];
    _xArr = [];
    _beanList1 = [];
    _beanList2 = [];
    //制造假数据
    //制造假数据
    var yValues = ['100', '65', '35', '0'];
    var xValues = ['0', "20'", "40'", "60'"];
    var xPositionRetioy = [0.0, 0.33, 0.66, 1.0];
    var yTexts = ['', '忘我', '一般', '走神'];
    var yTextColors = [
      const Color(0xEE172B88),
      const Color(0xEEF75E36),
      const Color(0xEEFFC278),
      const Color(0xEE172B88),
    ];

    for (var i = 0; i < yValues.length; i++) {
      _xArr.add(DialStyleX(
        titleStyle: const TextStyle(fontSize: 10.0, color: Colors.black),
        title: xValues[i],
        positionRetioy: xPositionRetioy[i],
      ));
      _yArr.add(
        DialStyleY(
          leftSub: DialStyleYSub(
              title: yValues[i],
              titleStyle: const TextStyle(fontSize: 10.0, color: Colors.black)),
          rightSub: DialStyleYSub(
            centerSubTitle: yTexts[i],
            centerSubTextStyle:
                TextStyle(fontSize: 10.0, color: yTextColors[i]),
          ),
          yValue: double.parse(yValues[i]),
          positionRetioy: 1 - double.parse(yValues[i]) / 100.0,
        ),
      );
    }

    _focusChartBeanMain1 = FocusChartBeanMain(
        sectionModel: LineSectionModel(),
        lineShader: LineShaderSetModel(
            baseLineTopGradient: LinearGradientModel(
                shaderColors: [Colors.orange, Colors.orange])),
        lineWidth: 1,
        isLinkBreak: false,
        lineColor: Colors.blue);
    _focusChartBeanMain2 = FocusChartBeanMain(
        // gradualColors: [Color(0xFFFF605C), Color(0x00FF9A97)],
        lineWidth: 1,
        isLinkBreak: true,
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
      if (kDebugMode) {
        print('毁灭定时器4');
      }
    };
    //制造假数据结束
    _loadNewData();
  }

  void _loadNewData() async {
    var image1 = await UIImageUtil.loadImage('assets/head1.png');
    var image2 = await UIImageUtil.loadImage('assets/head2.jpeg');
    _index = 0;
    _beanList1.clear();
    _beanList2.clear();
    _countdownTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_beanList1.isNotEmpty) {
        var model = _beanList1.last;
        model.cellPointSet = CellPointSet.normal;
      }
      if (_beanList2.isNotEmpty) {
        var model = _beanList2.last;
        model.cellPointSet = CellPointSet.normal;
      }
      var value = Random().nextDouble() * 100;
      _beanList1.add(
        ChartBeanFocus(
          focus: value,
          focusMax: value + 5,
          focusMin: value - 5,
          second: _index > 10 ? (10 + _index) : _index,
          cellPointSet: CellPointSet(
            pointType: PointType.PlacehoderImage,
            placehoderImage: image1,
            placeImageSize: const Size(20, 20),
            centerPointOffsetLineColor: Colors.blue,
            centerPointOffset: const Offset(0, -20),
          ),
        ),
      );

      var value2 = Random().nextDouble() * 100;
      _beanList2.add(
        ChartBeanFocus(
          focus: value2,
          second: _index > 10 ? (10 + _index) : _index,
          cellPointSet: CellPointSet(
            pointType: PointType.PlacehoderImage,
            placehoderImage: image2,
            placeImageSize: const Size(20, 20),
            centerPointOffsetLineColor: Colors.red,
            centerPointOffset: const Offset(0, -20),
          ),
        ),
      );
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
    if (kDebugMode) {
      print('毁灭');
    }
    super.dispose();
  }
}
