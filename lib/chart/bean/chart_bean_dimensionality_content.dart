/*
 * @Author: Cao Shixin
 * @Date: 2021-06-15 11:02:48
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2022-05-24 11:18:13
 * @Description: 维度内部使用模型
 */

import 'dart:math';

import 'package:flutter/material.dart';

import 'chart_bean_dimensionality.dart';

//维度图每个维度的自带点击处理参数
class DimensionabilityTouchBackModel {
  Offset point;
  Size size;
  int index;
  dynamic param;
  DimensionabilityTouchBackModel(
      {this.point = Offset.zero,
      this.index = 0,
      this.size = Size.zero,
      this.param});

  Map toJson() {
    var data = <String, dynamic>{};
    data['point'] = point;
    data['size'] = size;
    data['index'] = index;
    data['param'] = param;
    return data;
  }
}

class DimensionCellContentModel {
  final Point point;
  final DimensionCellModel model;
  DimensionCellContentModel({required this.point, required this.model});
}
