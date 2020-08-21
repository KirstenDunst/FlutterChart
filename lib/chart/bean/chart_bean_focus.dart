/*
 * @Author: Cao Shixin
 * @Date: 2020-03-29 10:26:09
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-08-20 20:01:37
 * @Description: 头环绘制曲线属性设置区
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class FocusChartBeanMain {
  //数据显示点集合
  List<ChartBeanFocus> chartBeans;
  //曲线或折线的颜色
  Color lineColor = Colors.lightBlueAccent;
  //曲线或折线的线宽
  double lineWidth = 4;
  //内部的渐变颜色。不设置的话默认按照解释文案的分层显示，如果设置，即为整体颜色渐变显示
  List<Color> gradualColors;
  //beans的时间轴如果断开，true： 是继续上一个有数值的值绘制，还是 false：断开。按照多条绘制,默认true
  bool isLinkBreak = true;

  //用户当前进行位置的widget（比如一个小头像），默认没有，什么也不显示
  ui.Image centerPoint;
  //结束回调
  VoidCallback canvasEnd;

  FocusChartBeanMain(
      {this.chartBeans,
      this.lineColor,
      this.lineWidth,
      this.gradualColors,
      this.isLinkBreak,
      this.centerPoint,
      this.canvasEnd});
}

class ChartBeanFocus {
  //这个专注值开始的时间，以秒为单位
  int second;
  //数值
  double focus;

  ChartBeanFocus({@required this.focus, this.second = 0});
}

class DialStyle {
  //刻度标志内容(y轴仅适用于内容为数值类型的，x轴不限制)
  String title;
  //y轴获取的值，只读
  double get titleValue {
    if (title == null || title.isEmpty) {
      return 0;
    } else {
      return double.parse(title);
    }
  }

  //刻度标志样式
  TextStyle titleStyle;
  //与最大数值的比率，用来计算绘制刻度的位置使用。
  double positionRetioy;

  /// 下面标注文案独属y轴使用，目前还没有x轴扩展需求，x轴设置下面参数无效，后期有需要再扩展
  //两个刻度之间的标注文案（向前绘制即x轴在该刻度左侧绘制，y轴在该刻度下面绘制）,不需要的话不设置
  String centerSubTitle;
  //标注文案样式，centerSubTitle有内容时有效
  TextStyle centerSubTextStyle;
  //标注文案位置是否是在左侧，false表示在右侧，centerSubTitle有内容时有效
  bool isLeft;

  DialStyle(
      {this.title,
      this.titleStyle,
      this.centerSubTitle,
      this.centerSubTextStyle,
      this.positionRetioy,
      this.isLeft = true});
}

//颜色区间
class SectionBean {
  //标题
  String title;
  //标题字体样式
  TextStyle titleStyle;
  //开始绘制的起始位置占总长度的比例
  double startRatio;
  //绘制的宽度与总宽度的比较
  double widthRatio;
  //内部填充颜色
  Color fillColor;
  //边框颜色,默认没有颜色
  Color borderColor;
  //边框线宽度，默认宽度为1
  double borderWidth;
  //边框线是否为实线还是虚线，默认实线
  bool isBorderSolid;

  SectionBean(
      {this.title = '',
      this.titleStyle,
      this.startRatio = 0,
      this.widthRatio = 0,
      this.fillColor,
      this.borderColor,
      this.borderWidth = 1,
      this.isBorderSolid = true});
}
