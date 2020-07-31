import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ChartBean {
  //x轴坐标显示字段
  String x;
  //y轴的值
  double y;
  //是否显示占位图，目前只结合线定义的placehoderImage使用
  bool isShowPlaceImage;

  ChartBean({
    this.x = '',
    this.y = 0,
    this.isShowPlaceImage = false,
  });
}

//每条线的定义
class ChartBeanSystem {
  //x轴的字体样式
  TextStyle xTitleStyle;
  //是否显示x轴的文字，用来处理多个线条绘制的时候，同一x轴坐标不需要绘制多次，则只需要将多条线中一个标记绘制即可
  bool isDrawX;
  //线宽
  double lineWidth;
  //线条点的特殊处理，如果内容不为空，则在点上面会绘制一个圆点，这个是圆点半径参数
  double pointRadius;
  //标记是否为曲线
  bool isCurve;
  //点集合
  List<ChartBean> chartBeans;
  //Line渐变色，从曲线到x轴从上到下的闭合颜色集
  List<Color> shaderColors;
  //曲线或折线的颜色
  Color lineColor;
  //占位图是否需要打断线条绘制，如果打断的话这个点的y值将没有意义，只有x轴有效，如果不打断的话，y轴值有效
  bool placehoderImageBreak;
  //用户当前进行位置的小图标（比如一个小锁），默认没有只显示y轴的值，如果有内容则显示这个小图标，
  ui.Image placehoderImage;
  ChartBeanSystem(
      {this.xTitleStyle,
      this.isDrawX = false,
      this.lineWidth = 2,
      this.pointRadius = 0,
      this.isCurve = false,
      this.chartBeans,
      this.shaderColors,
      this.lineColor = Colors.purple,
      this.placehoderImageBreak = true,
      this.placehoderImage});
}

class ChartBeanY {
  //刻度标志内容(y轴仅适用于内容为数值类型的)
  String title;
  //y轴获取的值，只读
  double get titleValue {
    if (title == null || title.length == 0) {
      return 0;
    } else {
      return double.parse(title);
    }
  }

  //刻度标志样式
  TextStyle titleStyle;
  //两个刻度之间的标注文案（y轴在该刻度下面绘制）,不需要的话不设置
  String centerSubTitle = '';
  //标注文案样式
  TextStyle centerSubTextStyle;
  //与最大y轴数值的比率，用来计算绘制刻度的位置使用。
  double positionRetioy;

  ChartBeanY(
      {this.title,
      this.titleStyle,
      this.centerSubTitle,
      this.centerSubTextStyle,
      this.positionRetioy});
}

class ChartBeanX {
  //x轴显示的内容
  String title;
  //刻度标志样式
  TextStyle titleStyle;
  //数值，用来处理柱体的高度。这里不用比值来操作是因为如果外部没有传最大值内部会有最大y值计算。
  double value;
  //柱体的渐变色数组
  List<Color> gradualColor;

  ChartBeanX({this.title, this.titleStyle, this.value, this.gradualColor});
}
