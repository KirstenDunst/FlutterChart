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
