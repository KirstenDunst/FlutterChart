/*
 * @Author: Cao Shixin
 * @Date: 2021-09-23 17:27:08
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2021-09-24 16:19:36
 * @Description: 
 */
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/percent_Indicator/enum/common_enum.dart';

class CirclePainter extends CustomPainter {
  final Paint _paintBackground = Paint();
  final Paint _paintLine = Paint();
  final double lineWidth;
  final double backgroundWidth;
  final double progress;
  final double radius;
  final Color progressColor;
  final Color backgroundColor;
  final StrokeCap? strokeCap;
  final double startAngle;
  final LinearGradient? linearGradient;
  final ArcType arcType;
  final bool reverse;
  final MaskFilter? maskFilter;
  final bool rotateLinearGradient;

  CirclePainter({
    required this.lineWidth,
    required this.backgroundWidth,
    required this.progress,
    required this.radius,
    required this.progressColor,
    required this.backgroundColor,
    this.startAngle = 0.0,
    this.strokeCap = StrokeCap.round,
    this.linearGradient,
    required this.reverse,
    this.arcType = ArcType.FULL,
    this.maskFilter,
    required this.rotateLinearGradient,
  }) {
    _paintBackground.color = backgroundColor;
    _paintBackground.style = PaintingStyle.stroke;
    _paintBackground.strokeWidth = backgroundWidth;
    _paintBackground.strokeCap = strokeCap ?? StrokeCap.square;
    _paintLine.color = progressColor;
    _paintLine.style = PaintingStyle.stroke;
    _paintLine.strokeWidth = lineWidth;
    _paintLine.strokeCap = strokeCap ?? StrokeCap.square;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rectForArc = Rect.fromCircle(center: center, radius: radius);
    var fixRadian = 90.0;
    var fixRatio = 1.0;
    if (arcType == ArcType.HALF) {
      fixRadian = 180.0;
      fixRatio = 0.5;
      canvas.drawArc(rectForArc, radians(-fixRadian + startAngle).toDouble(),
          radians(fixRadian).toDouble(), false, _paintBackground);
    } else {
      canvas.drawCircle(center, radius, _paintBackground);
    }

    if (maskFilter != null) {
      _paintLine.maskFilter = maskFilter;
    }
    if (linearGradient != null) {
      if (rotateLinearGradient && progress > 0) {
        var correction = 0.0;
        if (_paintLine.strokeCap == StrokeCap.round ||
            _paintLine.strokeCap == StrokeCap.square) {
          if (reverse) {
            correction = math.atan(_paintLine.strokeWidth / 2 / radius);
          } else {
            correction = math.atan(_paintLine.strokeWidth / 2 / radius);
          }
        }
        if (needDrawStartEndPoint) {
          correction = 0.0;
        }
        _paintLine.shader = SweepGradient(
                transform: reverse
                    ? GradientRotation(
                        radians(-90 - progress + startAngle) - correction)
                    : GradientRotation(
                        radians(-90.0 + startAngle) - correction),
                startAngle: radians(0).toDouble(),
                endAngle: radians(progress).toDouble(),
                tileMode: TileMode.clamp,
                colors: reverse
                    ? linearGradient!.colors.reversed.toList()
                    : linearGradient!.colors)
            .createShader(
          Rect.fromCircle(
            center: center,
            radius: radius,
          ),
        );
      } else if (!rotateLinearGradient) {
        _paintLine.shader = linearGradient!.createShader(
          Rect.fromCircle(
            center: center,
            radius: radius,
          ),
        );
      }
    }

    if (reverse) {
      final start = radians(360 * fixRatio - fixRadian + startAngle).toDouble();
      final end = radians(-progress * fixRatio).toDouble();
      _drawStartPoint(canvas, center, start);
      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
        start,
        end,
        false,
        _paintLine,
      );
      _drawEndPoint(canvas, center, end);
    } else {
      final start = radians(-fixRadian + startAngle).toDouble();
      final end = radians(progress * fixRatio).toDouble();
      _drawStartPoint(canvas, center, start);
      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
        start,
        end,
        false,
        _paintLine,
      );
      _drawEndPoint(canvas, center, end);
    }
  }

  /// 旋转渐变圆形进度条优化，避免在progress接近1时端点不显示半圆
  /// 起点半圆+圆弧+终点半圆
  bool get needDrawStartEndPoint {
    return linearGradient != null &&
        rotateLinearGradient &&
        progress != 0 &&
        strokeCap == StrokeCap.round &&
        arcType == ArcType.FULL &&
        maskFilter == null;
  }

  void _drawEndPoint(Canvas canvas, Offset center, double end) {
    if (!needDrawStartEndPoint) {
      return;
    }
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(end + radians(-90 + startAngle));

    var colors = linearGradient!.colors;
    var pointPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = colors.last;
    var pointRect = Rect.fromCenter(
        center: Offset(radius, 0), width: lineWidth, height: lineWidth);
    canvas.drawArc(pointRect, reverse ? math.pi : 0, math.pi, true, pointPaint);
    canvas.restore();
  }

  void _drawStartPoint(Canvas canvas, Offset center, double start) {
    if (!needDrawStartEndPoint) {
      return;
    }
    _paintLine.strokeCap = StrokeCap.butt;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(start);

    var colors = linearGradient!.colors;
    var pointPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = colors.first;
    var pointRect = Rect.fromCenter(
        center: Offset(radius, 0), width: lineWidth, height: lineWidth);
    canvas.drawArc(pointRect, reverse ? 0 : math.pi, math.pi, true, pointPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

num radians(num deg) => deg * (math.pi / 180.0);
