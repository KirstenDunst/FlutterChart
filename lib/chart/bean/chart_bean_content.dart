/*
 * @Author: Cao Shixin
 * @Date: 2021-09-18 18:18:10
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2021-09-18 18:18:10
 * @Description: 
 */
//线上面点模型
import 'package:flutter/material.dart';

import 'chart_bean.dart';

class PointModel {
  //位置偏移
  Offset offset;
  //点设置
  CellPointSet cellPointSet;
  //专注力值区间颜色(暂时没有用到，专注力曲线的值在区间的颜色，留作后面扩展)
  Color? sectionColor;
  PointModel(
      {required this.offset,
      this.cellPointSet = CellPointSet.normal,
      this.sectionColor});
}