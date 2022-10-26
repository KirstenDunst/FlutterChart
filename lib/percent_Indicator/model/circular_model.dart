/*
 * @Author: Cao Shixin
 * @Date: 2021-09-23 17:27:38
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2021-09-24 14:34:31
 * @Description: 
 */

import 'package:flutter/material.dart';

class LineModel {
  //颜色
  final Color color;
  //宽度，背景宽度如果小于或等于0，会按照progress的宽度来替换
  final double width;

  LineModel({this.color = Colors.red, this.width = 5});

  const LineModel.back()
      : color = Colors.grey,
        //负数占位，用来等价进度的设置宽度
        width = -1;

  const LineModel.progress()
      : color = Colors.red,
        width = 5;

  static const LineModel backModel = LineModel.back();
  static const LineModel progressModel = LineModel.progress();
}
