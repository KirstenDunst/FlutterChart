/*
 * @Author: Cao Shixin
 * @Date: 2021-09-23 17:26:52
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2021-09-24 17:47:51
 * @Description: 
 */

import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/percent_Indicator/enum/common_enum.dart';
import 'package:flutter_chart_csx/percent_Indicator/model/linear_model.dart';

class LinearPainter extends CustomPainter {
  final Paint _paintBackground = Paint();
  final Paint _paintLine = Paint();
  final double lineWidth;
  final double progress;
  final bool isRTL;
  final ColorGradientModel progressModel;
  final ColorGradientModel backgroundModel;
  final StrokeCap strokeCap;
  final MaskFilter? maskFilter;
  final bool clipLinearGradient;
  final String centerText;
  final TextStyle centerTextStyle;

  TextPainter? _textPainter;

  LinearPainter({
    required this.lineWidth,
    required this.progress,
    required this.isRTL,
    required this.progressModel,
    required this.backgroundModel,
    this.strokeCap = StrokeCap.butt,
    this.maskFilter,
    required this.clipLinearGradient,
    this.centerText = '',
    this.centerTextStyle = defaultTextStyle,
  }) {
    _paintBackground.color = backgroundModel.color ?? Color(0xFFB8C7CB);
    _paintBackground.style = PaintingStyle.stroke;
    _paintBackground.strokeWidth = lineWidth;
    var tempProgressColor = (progressModel.color ?? Colors.red);
    _paintLine.color = progress.toString() == '0.0'
        ? tempProgressColor.withOpacity(0.0)
        : tempProgressColor;
    _paintLine.style = PaintingStyle.stroke;
    _paintLine.strokeWidth = lineWidth;

    _paintLine.strokeCap = strokeCap;
    if (strokeCap == StrokeCap.square) {
      //这里不存在方形的，转译处理为全部都是圆角收尾
      _paintLine.strokeCap = StrokeCap.round;
      _paintBackground.strokeCap = StrokeCap.round;
    }
    if (centerText.isNotEmpty) {
      _textPainter = TextPainter(
          text: TextSpan(
              text: centerText,
              style: centerTextStyle.copyWith(
                  color: progressModel.color ?? defaultColor)),
          textDirection: TextDirection.ltr);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final start = Offset(0.0, size.height / 2);
    final end = Offset(size.width, size.height / 2);
    canvas.drawLine(start, end, _paintBackground);

    if (maskFilter != null) {
      _paintLine.maskFilter = maskFilter;
    }
    if (backgroundModel.linearGradient != null) {
      var shaderEndPoint =
          clipLinearGradient ? Offset.zero : Offset(size.width, size.height);
      _paintBackground.shader = backgroundModel.linearGradient
          ?.createShader(Rect.fromPoints(Offset.zero, shaderEndPoint));
    }

    if (isRTL) {
      final xProgress = size.width - size.width * progress;
      if (progressModel.linearGradient != null) {
        _paintLine.shader = _createGradientShaderRightToLeft(size, xProgress);
      }
      canvas.drawLine(end, Offset(xProgress, size.height / 2), _paintLine);
    } else {
      final xProgress = size.width * progress;
      if (progressModel.linearGradient != null) {
        _paintLine.shader = _createGradientShaderLeftToRight(size, xProgress);
      }
      canvas.drawLine(start, Offset(xProgress, size.height / 2), _paintLine);
    }

    if (_textPainter != null) {
      var frontPaint = Paint()
        ..color = backgroundModel.color ?? Colors.white
        ..blendMode = BlendMode.srcATop;
      canvas.saveLayer(Offset.zero & size, frontPaint);
      _textPainter!.layout();
      _textPainter!.paint(
          canvas,
          Offset((size.width - _textPainter!.width) / 2,
              (size.height - _textPainter!.height) / 2));
      canvas.drawRRect(
          RRect.fromLTRBR(
              0, 0, size.width * progress, size.height, Radius.circular(999)),
          frontPaint);
      canvas.restore();
    }
  }

  Shader _createGradientShaderRightToLeft(Size size, double xProgress) {
    var shaderEndPoint =
        clipLinearGradient ? Offset.zero : Offset(xProgress, size.height);
    return progressModel.linearGradient!.createShader(
      Rect.fromPoints(
        Offset(size.width, size.height) +
            (strokeCap == StrokeCap.square
                ? Offset(lineWidth / 2, lineWidth / 2)
                : Offset.zero),
        shaderEndPoint,
      ),
    );
  }

  Shader _createGradientShaderLeftToRight(Size size, double xProgress) {
    var shaderEndPoint = clipLinearGradient
        ? Offset(size.width, size.height)
        : Offset(xProgress, size.height);
    return progressModel.linearGradient!.createShader(
      Rect.fromPoints(
        strokeCap == StrokeCap.square
            ? Offset(-lineWidth / 2, lineWidth / 2)
            : Offset.zero,
        shaderEndPoint,
      ),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
