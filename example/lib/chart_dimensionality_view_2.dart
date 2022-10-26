/*
 * @Author: Cao Shixin
 * @Date: 2020-07-17 17:42:38
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2022-05-24 15:28:27
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class ChartDimensionaView2 extends StatefulWidget {
  static const String routeName = 'chart_dimensionality_view2';
  static const String title = '维度图(第二种显示)';
  @override
  _ChartDimensionaView2State createState() => _ChartDimensionaView2State();
}

class _ChartDimensionaView2State extends State<ChartDimensionaView2> {
  final GlobalKey<ChartDimensionalityState> globalKey = GlobalKey();
  int _nowIndex;
  Offset _offset;

  ui.Image _placeImage1, _placeImage2;

  @override
  void initState() {
    _nowIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ChartDimensionaView2.title),
        actions: [
          InkWell(
            onTap: () async {
              _placeImage1 = await UIImageUtil.loadImage('assets/head1.png');
              _placeImage2 = await UIImageUtil.loadImage('assets/head2.jpeg');
              setState(() {});
            },
            child: Icon(
              Icons.local_activity,
              size: 20,
            ),
          )
        ],
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
      baseBean: BaseBean(basePadding: EdgeInsets.zero, yDialValues: []),
      dimensionalityDivisions: [
        ChartBeanDimensionality(
          tip: [
            TipModel(
                title: '语言',
                titleStyle: TextStyle(color: Colors.orange, fontSize: 15))
          ],
          normalStyle: DimensionCellStyle(
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
          ),
        ),
        ChartBeanDimensionality(
          tip: [
            TipModel(
                title: '行为',
                titleStyle: TextStyle(color: Colors.yellow, fontSize: 15))
          ],
          normalStyle: DimensionCellStyle(
              backgroundColor: Colors.cyanAccent,
              borderColor: Colors.red,
              offset: Offset(20, 10),
              borderWidth: 2),
        ),
        ChartBeanDimensionality(
          tip: [
            TipModel(
                title: '情绪',
                titleStyle: TextStyle(color: Colors.green, fontSize: 15))
          ],
          normalStyle: DimensionCellStyle(
              backgroundColor: Colors.cyanAccent,
              borderColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              borderWidth: 2,
              offset: Offset(0, 10)),
        ),
        ChartBeanDimensionality(
          tip: [
            TipModel(
                title: '注意力',
                titleStyle: TextStyle(color: Colors.blue, fontSize: 15)),
            TipModel(
                title: '123534rtewtewr',
                titleStyle: TextStyle(color: Colors.red, fontSize: 15))
          ],
          normalStyle: DimensionCellStyle(
              backgroundColor: Colors.cyanAccent,
              borderColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              borderWidth: 2,
              borderRadius: 5,
              offset: Offset(-20, 10)),
        )
      ],
      dimensionalityTags: [
        DimensionalityBean(
          fillColor: Color(0xFFB1E3AD).withOpacity(0.6),
          tagTipWidth: 0,
          tagTipHeight: 0,
          tagContents: [
            DimensionCellModel(value: 0.4),
            DimensionCellModel(value: 0.8),
            DimensionCellModel(value: 1.0),
            DimensionCellModel(value: 0.1),
          ],
        ),
        DimensionalityBean(
          fillColor: Colors.red.withOpacity(0.5),
          lineWidth: 3,
          lineColor: Colors.green,
          tagTipWidth: 0,
          tagTipHeight: 0,
          tagContents: [
            [Colors.orange, Colors.orange],
            [Colors.yellow, Colors.yellow],
            [Colors.green, Colors.green],
            [Colors.blue, Colors.blue]
          ]
              .map(
                (e) => DimensionCellModel(
                    value: 1.0,
                    pointType: _placeImage1 != null &&
                            _placeImage2 != null &&
                            (e.contains(Colors.orange) ||
                                e.contains(Colors.yellow))
                        ? PointType.PlacehoderImage
                        : PointType.Rectangle,
                    pointShaderColors: e,
                    pointSize: Size(12, 12),
                    pointRadius: Radius.circular(6),
                    placeImageSize: ui.Size(20, 20),
                    placehoderImage: e.contains(Colors.orange)
                        ? _placeImage1
                        : _placeImage2),
              )
              .toList(),
        )
      ],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 2),
      bgSet: DimensionBGSet(
        isCircle: true,
        circleLines: [1, 2, 3, 4]
            .map((e) => DimensionBgCircleLine(
                  isHintLineImaginary: e != 1,
                  lineWidth: 2,
                  lineColor: e == 1 ? Colors.red : Colors.grey.withOpacity(0.5),
                ))
            .toList(),
        dimensionLineColor: Colors.red,
        dimensionLineWidth: 1,
      ),
      centerR: 250,
      backgroundColor: Colors.white,
    );
    var changeChartLine = ChartDimensionality(
      key: globalKey,
      dimensionalityDivisions: [
        ChartBeanDimensionality(
          tip: [
            TipModel(
              title: '语言',
              titleStyle: TextStyle(color: Colors.orange, fontSize: 15),
              selectStyle: TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
          subTip: [
            TipModel(
                title: '50',
                titleStyle: TextStyle(color: Colors.yellow, fontSize: 15),
                selectStyle: TextStyle(color: Colors.purple, fontSize: 15))
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
          touchBackParam: '语言',
        ),
        ChartBeanDimensionality(
          tip: [
            TipModel(
              title: '行为',
              titleStyle: TextStyle(color: Colors.yellow, fontSize: 15),
              selectStyle: TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
          subTip: [
            TipModel(
                title: '60',
                titleStyle: TextStyle(color: Colors.green, fontSize: 15),
                selectStyle: TextStyle(color: Colors.purple, fontSize: 15))
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
          touchBackParam: '行为',
        ),
        ChartBeanDimensionality(
          tip: [
            TipModel(
              title: '情绪',
              titleStyle: TextStyle(color: Colors.green, fontSize: 15),
              selectStyle: TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
          subTip: [
            TipModel(
                title: '80',
                titleStyle: TextStyle(color: Colors.blue, fontSize: 15),
                selectStyle: TextStyle(color: Colors.purple, fontSize: 15))
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
          touchBackParam: '情绪',
        ),
        ChartBeanDimensionality(
          tip: [
            TipModel(
              title: '注意力',
              titleStyle: TextStyle(color: Colors.blue, fontSize: 15),
              selectStyle: TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
          subTip: [
            TipModel(
                title: '40',
                titleStyle: TextStyle(color: Colors.purple, fontSize: 15),
                selectStyle: TextStyle(color: Colors.purple, fontSize: 15))
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
          touchBackParam: '注意力',
        )
      ],
      dimensionalityTags: [
        DimensionalityBean(
          fillColor: Colors.transparent,
          lineWidth: 3,
          lineColor: Colors.green,
          isHintLineImaginary: true,
          tagTipWidth: 0,
          tagTipHeight: 0,
          tagContents: [
            [Colors.orange, Colors.orange],
            [Colors.yellow, Colors.yellow],
            [Colors.green, Colors.green],
            [Colors.blue, Colors.blue]
          ]
              .map(
                (e) => DimensionCellModel(
                  value: 1.0,
                  pointShaderColors: e,
                  pointSize: Size(12, 12),
                  pointRadius: Radius.circular(6),
                ),
              )
              .toList(),
        ),
        DimensionalityBean(
          fillColor: Color(0xFFB1E3AD).withOpacity(0.6),
          tagTipWidth: 0,
          tagTipHeight: 0,
          tagContents: [
            DimensionCellModel(value: 0.4),
            DimensionCellModel(value: 0.8),
            DimensionCellModel(value: 1.0),
            DimensionCellModel(value: 0.1),
          ],
        )
      ],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 2),
      bgSet: DimensionBGSet(
        isCircle: true,
        circleLines: [1, 2, 3, 4]
            .map((e) => DimensionBgCircleLine(
                  isHintLineImaginary: false,
                  lineWidth: 1,
                  lineColor: Colors.grey.withOpacity(0.5),
                ))
            .toList(),
        dimensionLineColor: Colors.red,
        dimensionLineWidth: 1,
      ),
      centerR: 120,
      backgroundColor: Colors.white,
      touchSet: DimensionTouchSet(
        outsidePointClear: false,
        touchBack: (isTouch, point, size, index, value) {
          print(
              '收到反馈结果>>>>$isTouch>>>>>$point>>>>>>$size>>>>>>>>$index>>>>>>$value');
          setState(() {
            _offset = point;
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
            child: Stack(
              children: [
                changeChartLine,
                if (_offset != null)
                  Positioned(
                    child: IgnorePointer(
                      child: Container(
                        color: Colors.red,
                      ),
                    ),
                    left: _offset.dx,
                    top: _offset.dy,
                    width: 20,
                    height: 20,
                  ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
          ),
          SizedBox(
            height: 20,
          ),
          Text('当前选中下标$_nowIndex'),
          InkWell(
            child: Text(
              '取消选中',
            ),
            onTap: () {
              globalKey.currentState.clearTouchPoint();
            },
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
