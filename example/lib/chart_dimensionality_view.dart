/*
 * @Author: Cao Shixin
 * @Date: 2020-07-17 17:42:38
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2022-05-24 11:06:41
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class ChartDimensionalityView extends StatefulWidget {
  static const String routeName = 'chart_dimensionality_view';
  static const String title = '维度图';
  @override
  _ChartDimensionalityViewState createState() =>
      _ChartDimensionalityViewState();
}

class _ChartDimensionalityViewState extends State<ChartDimensionalityView> {
  Timer _timer;
  final GlobalKey<ChartDimensionalityState> globalKey = GlobalKey();
  int _nowIndex;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 3), (time) {
      globalKey.currentState.changeSelectDimension();
    });
    _nowIndex = 0;
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ChartDimensionalityView.title),
      ),
      body: ListView(
        children: [
          _buildWidget(context),
        ],
      ),
    );
  }

  Widget _buildWidget(BuildContext context) {
    var noChangeChartLine = ChartDimensionality(
      dimensionalityDivisions: [
        ChartBeanDimensionality(
          tip: [
            TipModel(
              title: '选择性专注力',
              titleStyle:
                  TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
            )
          ],
          normalStyle: DimensionCellStyle(
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
          ),
        ),
        ChartBeanDimensionality(
          tip: [
            TipModel(
              title: '持续性专注力',
              titleStyle:
                  TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
            )
          ],
          normalStyle: DimensionCellStyle(
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
          ),
        ),
        ChartBeanDimensionality(
          tip: [
            TipModel(
              title: '转换性专注力',
              titleStyle:
                  TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
            )
          ],
          normalStyle: DimensionCellStyle(
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
          ),
        ),
        ChartBeanDimensionality(
          tip: [
            TipModel(
              title: '分配性专注力',
              titleStyle:
                  TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
            )
          ],
          normalStyle: DimensionCellStyle(
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
          ),
        ),
        ChartBeanDimensionality(
            tip: [
              TipModel(
                title: '视觉性专注力',
                titleStyle:
                    TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
              )
            ],
            normalStyle: DimensionCellStyle(
              backgroundColor: Colors.transparent,
              borderColor: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              borderWidth: 0,
            )),
        ChartBeanDimensionality(
          tip: [
            TipModel(
              title: '玩儿呢',
              titleStyle:
                  TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
            )
          ],
          normalStyle: DimensionCellStyle(
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
          ),
        )
      ],
      dimensionalityTags: [
        DimensionalityBean(
          fillColor: Color(0xFFB1E3AD).withOpacity(0.6),
          tagTitleStyle: TextStyle(color: Color(0xFF666666), fontSize: 16.0),
          tagTitle: '初次评测',
          tagContents: [
            DimensionCellModel(value: 0.2),
            DimensionCellModel(value: 0.4),
            DimensionCellModel(value: 0.8),
            DimensionCellModel(value: 1.0),
            DimensionCellModel(value: 0.1),
            DimensionCellModel(value: 0.5)
          ],
        ),
        DimensionalityBean(
          fillColor: Color(0xFFF88282).withOpacity(0.6),
          tagTitleStyle: TextStyle(color: Color(0xFF666666), fontSize: 16.0),
          tagTitle: '本次评测',
          tagContents: [
            DimensionCellModel(value: 0.8),
            DimensionCellModel(value: 0.9),
            DimensionCellModel(value: 0.8),
            DimensionCellModel(value: 1.0),
            DimensionCellModel(value: 0.7),
            DimensionCellModel(value: 0.9)
          ],
        )
      ],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 2),
      bgSet: DimensionBGSet(
        circleLines: [1, 2, 3, 4].map((e) => DimensionBgCircleLine(
              isHintLineImaginary: false,
              lineWidth: 1,
              lineColor: Colors.grey.withOpacity(0.5),
            )).toList(),
      ),
      centerR: 120,
      backgroundColor: Colors.white,
    );
    var changeChartLine = ChartDimensionality(
      key: globalKey,
      dimensionalityDivisions: [
        ChartBeanDimensionality(
          tip: [
            TipModel(
              title: '选择性专注力',
              titleStyle:
                  TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
              selectStyle: TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
          normalStyle: DimensionCellStyle(
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            borderWidth: 0,
          ),
          selectStyle: DimensionCellStyle(
            backgroundColor: Colors.black,
            borderColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            borderWidth: 1,
          ),
        ),
        ChartBeanDimensionality(
          tip: [
            TipModel(
              title: '持续性专注力',
              titleStyle:
                  TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
              selectStyle: TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
          normalStyle: DimensionCellStyle(
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            borderWidth: 0,
          ),
          selectStyle: DimensionCellStyle(
            backgroundColor: Colors.black,
            borderColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            borderWidth: 1,
          ),
        ),
        ChartBeanDimensionality(
          tip: [
            TipModel(
              title: '转换性专注力',
              titleStyle:
                  TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
              selectStyle: TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
          normalStyle: DimensionCellStyle(
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            borderWidth: 0,
          ),
          selectStyle: DimensionCellStyle(
            backgroundColor: Colors.black,
            borderColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            borderWidth: 1,
          ),
        ),
        ChartBeanDimensionality(
          tip: [
            TipModel(
              title: '分配性专注力',
              titleStyle:
                  TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
              selectStyle: TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
          normalStyle: DimensionCellStyle(
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            borderWidth: 0,
          ),
          selectStyle: DimensionCellStyle(
            backgroundColor: Colors.black,
            borderColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            borderWidth: 1,
          ),
        ),
        ChartBeanDimensionality(
          tip: [
            TipModel(
              title: '视觉性专注力',
              titleStyle:
                  TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
              selectStyle: TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
          normalStyle: DimensionCellStyle(
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            borderWidth: 0,
          ),
          selectStyle: DimensionCellStyle(
            backgroundColor: Colors.black,
            borderColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            borderWidth: 1,
          ),
        ),
        ChartBeanDimensionality(
          tip: [
            TipModel(
              title: '玩儿呢',
              titleStyle:
                  TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
              selectStyle: TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
          normalStyle: DimensionCellStyle(
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            borderWidth: 0,
          ),
          selectStyle: DimensionCellStyle(
            backgroundColor: Colors.black,
            borderColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            borderWidth: 1,
          ),
        )
      ],
      dimensionalityTags: [
        DimensionalityBean(
          fillColor: Color(0xFFB1E3AD).withOpacity(0.6),
          tagTitleStyle: TextStyle(color: Color(0xFF666666), fontSize: 16.0),
          tagTitle: '初次评测',
          tagContents: [
            DimensionCellModel(value: 0.2),
            DimensionCellModel(value: 0.4),
            DimensionCellModel(value: 0.8),
            DimensionCellModel(value: 1.0),
            DimensionCellModel(value: 0.1),
            DimensionCellModel(value: 0.5)
          ],
        ),
        DimensionalityBean(
          fillColor: Color(0xFFF88282).withOpacity(0.6),
          tagTitleStyle: TextStyle(color: Color(0xFF666666), fontSize: 16.0),
          tagTitle: '本次评测',
          tagContents: [
            DimensionCellModel(value: 0.8),
            DimensionCellModel(value: 0.9),
            DimensionCellModel(value: 0.8),
            DimensionCellModel(value: 1.0),
            DimensionCellModel(value: 0.7),
            DimensionCellModel(value: 0.9)
          ],
        )
      ],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 2),
      bgSet: DimensionBGSet(
        circleLines: [1, 2, 3, 4].map((e) => DimensionBgCircleLine(
              isHintLineImaginary: false,
              lineWidth: 2,
              lineColor: Colors.blueAccent,
            )).toList(),
      ),
      centerR: 120,
      backgroundColor: Colors.white,
      touchSet: DimensionTouchSet(
        touchBack: (isTouch, point, size, index, value) {
          print(
              '收到反馈结果>>>>$isTouch>>>>>$point>>>>>>$size>>>>>>>>$index>>>>>>$value');
          setState(() {
            _nowIndex = index;
          });
        },
      ),
    );
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('不可点击，不变化的维度图'),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            semanticContainer: true,
            color: Colors.green.withOpacity(0.5),
            child: noChangeChartLine,
            clipBehavior: Clip.antiAlias,
          ),
          Text('可点击，可变化的维度图'),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            semanticContainer: true,
            color: Colors.green.withOpacity(0.5),
            child: changeChartLine,
            clipBehavior: Clip.antiAlias,
          ),
          SizedBox(
            height: 20,
          ),
          Text('当前选中下标$_nowIndex'),
        ],
      ),
    );
  }
}
