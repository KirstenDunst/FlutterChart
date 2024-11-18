/*
 * @Author: your name
 * @Date: 2020-11-06 17:48:40
 * @LastEditTime: 2021-05-07 09:40:04
 * @LastEditors: Cao Shixin
 * @Description: In User Settings Edit
 * @FilePath: /flutter_chart/lib/chart/enum/painter_const.dart
 */
import 'package:flutter/material.dart';

//多出最大的极值额外的线长
const double overPadding = 0;

//基础偏移量
const double divisionConst = 16.0;
const EdgeInsets defaultBasePadding = EdgeInsets.only(
    left: divisionConst * 2.5,
    bottom: divisionConst * 3.0,
    right: divisionConst * 2.0,
    top: divisionConst * 2.0);

//默认颜色
const Color defaultColor = Colors.deepPurple;

//默认字体样式
const TextStyle defaultTextStyle = TextStyle(color: defaultColor, fontSize: 10);
