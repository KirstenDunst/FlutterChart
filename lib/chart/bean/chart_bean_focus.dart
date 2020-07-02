/*
 * @Author: Cao Shixin
 * @Date: 2020-03-29 10:26:09
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-07-01 18:33:02
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */ 
import 'package:flutter/material.dart';

class ChartBeanFocus {
  //这个专注值开始的时间，以秒为单位
  int second;
  //数值
  double focus;
  
  ChartBeanFocus({@required this.focus, this.second});
}

class DialStyle {
  //刻度标志内容(y轴仅适用于内容为数值类型的，x轴不限制)
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
  //两个刻度之间的标注文案（向前绘制即x轴在该刻度左侧绘制，y轴在该刻度下面绘制）,不需要的话不设置
  String centerSubTitle;
  //标注文案样式
  TextStyle centerSubTextStyle;
  //与最大数值的比率，用来计算绘制刻度的位置使用。
  double positionRetioy;

  DialStyle({this.title,this.titleStyle, this.centerSubTitle, this.centerSubTextStyle,this.positionRetioy});
}

enum CenterSubTitlePosition {
  //没有解释文案
  None,
  //解释文案在左侧y轴
  Left,
  //解释文案在右侧y轴
  Right,
}