import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/bean/chart_bean.dart';

class BasePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  ///计算极值 最大值,最小值
  List<double> calculateMaxMin(List<ChartBean> chartBeans) {
    if (chartBeans == null || chartBeans.length == 0) return [0, 0];
    double maxY = 0.0, minY = 0.0;
    for (ChartBean bean in chartBeans) {
      if (maxY < max(bean.y, bean.subY)) {
        maxY = max(bean.y, bean.subY);
      }
      if (minY > min(bean.y, bean.subY)) {
        minY = min(bean.y, bean.subY);
      }
    }
    return [max(maxY, 1), minY];
  }

  ///计算极值 最大值,最小值
  List<double> calculateMaxMinNew(List<ChartBeanX> chartBeans) {
    if (chartBeans == null || chartBeans.length == 0) return [0, 0];
    double maxY = 0.0, minY = 0.0;
    for (ChartBeanX bean in chartBeans) {
      if (maxY < bean.value) {
        maxY = bean.value;
      }
      if (minY > bean.value) {
        minY = bean.value;
      }
    }
    return [maxY, minY];
  }
}
