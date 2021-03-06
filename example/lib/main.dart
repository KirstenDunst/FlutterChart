/*
 * @Author: Cao Shixin
 * @Date: 2020-03-29 10:26:09
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-12-16 15:57:16
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:example/chart_bar_circle.dart';
import 'package:example/chart_bar_round.dart';
import 'package:example/chart_curve.dart';
import 'package:example/chart_dimensionality_view.dart';
import 'package:example/chart_line.dart';
import 'package:example/chart_pie.dart';
import 'package:example/double_chart_line.dart';
import 'package:example/focus_chart_double_line.dart';
import 'package:example/focus_chart_line.dart';
import 'package:example/focus_chart_special_point.dart';
import 'package:example/step_curve_line.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

final Map<String, WidgetBuilder> _routes = {
  //FN专注力样式图
  FocusChartLinePage.routeName: (_) => FocusChartLinePage(),
  //FN专注力特殊点样式图
  FocusChartSpecialPointPage.routeName: (_) => FocusChartSpecialPointPage(),
  //FN大师竞赛双专注力样式图
  FNDoubleLinePage.routeName: (_) => FNDoubleLinePage(),
  //柱状顶部半圆型
  ChartBarCirclePage.routeName: (_) => ChartBarCirclePage(),
  //柱状图顶部自定义弧角
  ChartBarRoundPage.routeName: (_) => ChartBarRoundPage(),
  //平滑曲线带填充颜色
  ChartCurvePage.routeName: (_) => ChartCurvePage(),
  //折线带填充颜色
  ChartLinePage.routeName: (_) => ChartLinePage(),
  //双折线
  DoubleChartlinePage.routeName: (_) => DoubleChartlinePage(),
  //饼状图
  ChartPiePage.routeName: (_) => ChartPiePage(),
  //维度图
  ChartDimensionalityView.routeName: (_) => ChartDimensionalityView(),
  //步进曲线，可拖拽
  StepCurveLine.routeName: (_) => StepCurveLine(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '绘图图表测试',
      theme: ThemeData(primaryColor: Colors.blue),
      routes: _routes,
      home: Scaffold(
        appBar: AppBar(
          title: Text('绘图图表测试'),
        ),
        body: MyAppPage(),
      ),
    );
  }
}

class MyAppPage extends StatefulWidget {
  @override
  _MyAppPageState createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage> {
  List<CellModel> _demoTitleArr = [];

  @override
  void initState() {
    super.initState();
    _demoTitleArr = [
      CellModel(
          title: FocusChartLinePage.title,
          routeName: FocusChartLinePage.routeName),
      CellModel(
          title: FocusChartSpecialPointPage.title,
          routeName: FocusChartSpecialPointPage.routeName),
      CellModel(
          title: FNDoubleLinePage.title, routeName: FNDoubleLinePage.routeName),
      CellModel(
          title: ChartBarCirclePage.title,
          routeName: ChartBarCirclePage.routeName),
      CellModel(
          title: ChartBarRoundPage.title,
          routeName: ChartBarRoundPage.routeName),
      CellModel(
          title: ChartCurvePage.title, routeName: ChartCurvePage.routeName),
      CellModel(title: ChartLinePage.title, routeName: ChartLinePage.routeName),
      CellModel(
          title: DoubleChartlinePage.title,
          routeName: DoubleChartlinePage.routeName),
      CellModel(title: ChartPiePage.title, routeName: ChartPiePage.routeName),
      CellModel(
          title: ChartDimensionalityView.title,
          routeName: ChartDimensionalityView.routeName),
      CellModel(title: StepCurveLine.title, routeName: StepCurveLine.routeName),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(_demoTitleArr[index].routeName);
          },
          child: ListTile(
            title: Center(
              child: Text(_demoTitleArr[index].title),
            ),
          ),
        );
      },
      itemCount: _demoTitleArr.length,
    );
  }
}

class CellModel {
  //显示标题
  String title;
  //路由地址名
  String routeName;

  CellModel({this.title, this.routeName});
}
