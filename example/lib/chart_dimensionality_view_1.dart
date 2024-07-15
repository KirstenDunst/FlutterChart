/*
 * @Author: Cao Shixin
 * @Date: 2020-07-17 17:42:38
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2022-05-24 11:41:31
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class ChartDimensionaView extends StatefulWidget {
  static const String routeName = 'chart_dimensionality_view1';
  static const String title = '维度图(另一种显示)';

  const ChartDimensionaView({super.key});

  @override
  State<ChartDimensionaView> createState() => _ChartDimensionaViewState();
}

class _ChartDimensionaViewState extends State<ChartDimensionaView> {
  final GlobalKey<ChartDimensionalityState> globalKey = GlobalKey();
  late int _nowIndex;
  Offset? _offset;

  @override
  void initState() {
    _nowIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ChartDimensionaView.title),
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
                title: '社交',
                titleStyle: const TextStyle(color: Colors.red, fontSize: 15)),
            TipModel(
                title: '12324',
                titleStyle: const TextStyle(color: Colors.blue, fontSize: 15))
          ],
          subTip: [
            TipModel(
                title: '50',
                titleStyle: const TextStyle(color: Colors.orange, fontSize: 15))
          ],
          normalStyle: DimensionCellStyle(
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
          ),
        ),
        ChartBeanDimensionality(
          tip: [
            TipModel(
                title: '语言',
                titleStyle: const TextStyle(color: Colors.orange, fontSize: 15))
          ],
          subTip: [
            TipModel(
                title: '50',
                titleStyle: const TextStyle(color: Colors.yellow, fontSize: 15))
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
                titleStyle: const TextStyle(color: Colors.yellow, fontSize: 15))
          ],
          subTip: [
            TipModel(
                title: '60',
                titleStyle: const TextStyle(color: Colors.green, fontSize: 15))
          ],
          normalStyle: DimensionCellStyle(
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
          ),
        ),
        ChartBeanDimensionality(
          tip: [
            TipModel(
                title: '情绪',
                titleStyle: const TextStyle(color: Colors.green, fontSize: 15))
          ],
          subTip: [
            TipModel(
                title: '80',
                titleStyle: const TextStyle(color: Colors.blue, fontSize: 15))
          ],
          normalStyle: DimensionCellStyle(
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
          ),
        ),
        ChartBeanDimensionality(
            tip: [
              TipModel(
                  title: '注意力',
                  titleStyle:
                      const TextStyle(color: Colors.blue, fontSize: 15)),
              TipModel(
                  title: '123534rtewtewr',
                  titleStyle: const TextStyle(color: Colors.red, fontSize: 15))
            ],
            subTip: [
              TipModel(
                  title: '40',
                  titleStyle:
                      const TextStyle(color: Colors.purple, fontSize: 15))
            ],
            normalStyle: DimensionCellStyle(
              backgroundColor: Colors.transparent,
              borderColor: Colors.transparent,
              // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              borderWidth: 0,
            ))
      ],
      dimensionalityTags: [
        DimensionalityBean(
          fillColor: Colors.transparent,
          lineWidth: 3,
          lineColor: Colors.green,
          tagTipWidth: 0,
          tagTipHeight: 0,
          tagContents: [
            [Colors.red, Colors.red],
            [Colors.orange, Colors.orange],
            [Colors.yellow, Colors.yellow],
            [Colors.green, Colors.green],
            [Colors.blue, Colors.blue]
          ]
              .map(
                (e) => DimensionCellModel(
                  value: 1.0,
                  pointShaderColors: e,
                  pointSize: const Size(12, 12),
                  pointRadius: const Radius.circular(6),
                ),
              )
              .toList(),
        ),
        DimensionalityBean(
          fillColor: const Color(0xFFB1E3AD).withOpacity(0.6),
          tagTipWidth: 0,
          tagTipHeight: 0,
          tagContents: [
            DimensionCellModel(value: 0.2),
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
        // isCircle: true,
        circleLines: [1, 2, 3, 4]
            .map((e) => DimensionBgCircleLine(
                  isHintLineImaginary: true,
                  lineWidth: 1,
                  lineColor: Colors.grey.withOpacity(0.5),
                ))
            .toList(),
        dimensionLineColor: Colors.red,
        dimensionLineWidth: 1,
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
              title: '社交',
              titleStyle: const TextStyle(color: Colors.red, fontSize: 15),
              selectStyle: const TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
          subTip: [
            TipModel(
                title: '50',
                titleStyle: const TextStyle(color: Colors.orange, fontSize: 15),
                selectStyle:
                    const TextStyle(color: Colors.purple, fontSize: 15))
          ],
          normalStyle: DimensionCellStyle(
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            borderWidth: 0,
          ),
          selectStyle: DimensionCellStyle(
            backgroundColor: Colors.black,
            borderColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            borderWidth: 1,
          ),
          touchBackParam: '社交',
        ),
        ChartBeanDimensionality(
          tip: [
            TipModel(
              title: '语言',
              titleStyle: const TextStyle(color: Colors.orange, fontSize: 15),
              selectStyle: const TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
          subTip: [
            TipModel(
                title: '50',
                titleStyle: const TextStyle(color: Colors.yellow, fontSize: 15),
                selectStyle:
                    const TextStyle(color: Colors.purple, fontSize: 15))
          ],
          normalStyle: DimensionCellStyle(
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            borderWidth: 0,
          ),
          selectStyle: DimensionCellStyle(
            backgroundColor: Colors.black,
            borderColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            borderWidth: 1,
          ),
          touchBackParam: '语言',
        ),
        ChartBeanDimensionality(
          tip: [
            TipModel(
              title: '行为',
              titleStyle: const TextStyle(color: Colors.yellow, fontSize: 15),
              selectStyle: const TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
          subTip: [
            TipModel(
                title: '60',
                titleStyle: const TextStyle(color: Colors.green, fontSize: 15),
                selectStyle:
                    const TextStyle(color: Colors.purple, fontSize: 15))
          ],
          normalStyle: DimensionCellStyle(
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            borderWidth: 0,
          ),
          selectStyle: DimensionCellStyle(
            backgroundColor: Colors.black,
            borderColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            borderWidth: 1,
          ),
          touchBackParam: '行为',
        ),
        ChartBeanDimensionality(
          tip: [
            TipModel(
              title: '情绪',
              titleStyle: const TextStyle(color: Colors.green, fontSize: 15),
              selectStyle: const TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
          subTip: [
            TipModel(
                title: '80',
                titleStyle: const TextStyle(color: Colors.blue, fontSize: 15),
                selectStyle:
                    const TextStyle(color: Colors.purple, fontSize: 15))
          ],
          normalStyle: DimensionCellStyle(
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            borderWidth: 0,
          ),
          selectStyle: DimensionCellStyle(
            backgroundColor: Colors.black,
            borderColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            borderWidth: 1,
          ),
          touchBackParam: '情绪',
        ),
        ChartBeanDimensionality(
          tip: [
            TipModel(
              title: '注意力',
              titleStyle: const TextStyle(color: Colors.blue, fontSize: 15),
              selectStyle: const TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
          subTip: [
            TipModel(
                title: '40',
                titleStyle: const TextStyle(color: Colors.purple, fontSize: 15),
                selectStyle:
                    const TextStyle(color: Colors.purple, fontSize: 15))
          ],
          normalStyle: DimensionCellStyle(
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            borderWidth: 0,
          ),
          selectStyle: DimensionCellStyle(
            backgroundColor: Colors.black,
            borderColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
          tagTipWidth: 0,
          tagTipHeight: 0,
          tagContents: [
            [Colors.red, Colors.red],
            [Colors.orange, Colors.orange],
            [Colors.yellow, Colors.yellow],
            [Colors.green, Colors.green],
            [Colors.blue, Colors.blue]
          ]
              .map(
                (e) => DimensionCellModel(
                  value: 1.0,
                  pointShaderColors: e,
                  pointSize: const Size(12, 12),
                  pointRadius: const Radius.circular(6),
                ),
              )
              .toList(),
        ),
        DimensionalityBean(
          fillColor: const Color(0xFFB1E3AD).withOpacity(0.6),
          tagTipWidth: 0,
          tagTipHeight: 0,
          tagContents: [
            DimensionCellModel(value: 0.2),
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
          if (kDebugMode) {
            print(
                '收到反馈结果>>>>$isTouch>>>>>$point>>>>>>$size>>>>>>>>$index>>>>>>$value');
          }
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
          const Text('不可点击，不变化的维度图'),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            semanticContainer: true,
            color: Colors.green.withOpacity(0.5),
            clipBehavior: Clip.antiAlias,
            child: noChangeChartLine,
          ),
          const Text('可点击，可变化的维度图'),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            semanticContainer: true,
            color: Colors.green.withOpacity(0.5),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                changeChartLine,
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
          ),
          const SizedBox(
            height: 20,
          ),
          Text('当前选中下标$_nowIndex'),
          InkWell(
            child: const Text(
              '取消选中',
            ),
            onTap: () {
              globalKey.currentState?.clearTouchPoint();
            },
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
