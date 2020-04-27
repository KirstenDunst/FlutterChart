import 'package:flutter/material.dart';

class ChartBean {
  String x;
  double y;
  double subY;
  int millisSeconds;
  Color color;
  ChartBean(
      {@required this.x, @required this.y, this.subY = 0, this.millisSeconds, this.color});
}

class ChartBeanY {
  //刻度标志内容(y轴仅适用于内容为数值类型的)
  String title;
  //y轴获取的值，只读
  double get titleValue {
    if (title  == null || title.length == 0) {
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

  ChartBeanY({this.title,this.titleStyle, this.centerSubTitle, this.centerSubTextStyle,this.positionRetioy});
}

class ChartBeanX {
  //x轴显示的内容
  String title;
  //数值，用来处理柱体的高度。这里不用比值来操作是因为如果外部没有传最大值内部会有最大y值计算。
  double value;
  //柱体的渐变色数组
  List<Color> gradualColor;

  ChartBeanX({this.title, this.value, this.gradualColor});
}