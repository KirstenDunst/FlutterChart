/*
 * @Author: Cao Shixin
 * @Date: 2020-07-17 19:06:36
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-07-20 14:39:57
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/material.dart';

//定位维度的分维
class ChartBeanDimensionality {
  // 维度的标题
  String tip;
  // 维度字体的样式
  TextStyle tipStyle;
  ChartBeanDimensionality({this.tip, this.tipStyle});
}

//一个维度图的参数
class DimensionalityBean {
  //一次维度的标记
  String tagTitle;
  //一次维度的标记的字体样式，绘制于右上角
  TextStyle tagTitleStyle;
  //一次维度的标记颜色
  Color tagColor;
  //一次维度的数据数组(尽量数据长度、顺序和维度定义的一致，不一致的绘制的时候后面按照0补上)
  //另外：内部的数组包含的是0～1的比率类型的数值。否则大于1的记为1，小于0的记为0
  List<double> tagContents;

  DimensionalityBean(
      {this.tagColor, this.tagTitleStyle, this.tagContents, this.tagTitle});
}
