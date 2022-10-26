/*
 * @Author: Cao Shixin
 * @Date: 2021-09-23 17:26:31
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2022-01-21 14:03:39
 * @Description: 
 */

import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';
import 'package:flutter_chart_csx/percent_Indicator/painter/circular_painter.dart';

class CircularPercentIndicator extends StatefulWidget {
  ///通用设置
  final PercentModel percentModel;

  ///动画设置
  final AnimationSet animationSet;

  ///尺寸，宽高
  final double size;

  ///进度线条设置
  final LineModel progressModel;

  ///背景线条设置
  final LineModel backgroundModel;

  ///中间显示widget
  final Widget? center;

  ///线型渐变，设置会覆盖[progressModel]的颜色设置
  final LinearGradient? linearGradient;

  ///在线条末端的一种收尾方式
  final StrokeCap? strokeCap;

  ///开始角度。需为正数默认0,顺时针为正方向 （eg：0.0, 45.0, 90.0）
  final double startAngle;

  /// 是否是逆时针绘制？默认false正时针
  final bool reverse;

  ///展示圆角弧度类型,默认全圆
  final ArcType arcType;

  /// Creates a mask filter that takes the progress shape being drawn and blurs it.
  final MaskFilter? maskFilter;

  /// [LinearGradient]设置的时候，是否是扫描渐变模式【可以自行查看SweepGradient】，对线条越粗，铺满的饼状图效果会比较好，细条进度可以忽略不用设置
  final bool rotateLinearGradient;

  /// 保存状态，避免重复绘制，默认true
  final bool addAutomaticKeepAlive;

  CircularPercentIndicator({
    Key? key,
    this.percentModel = PercentModel.normal,
    this.animationSet = AnimationSet.normal,
    this.startAngle = 0.0,
    required this.size,
    this.progressModel = LineModel.progressModel,
    this.backgroundModel = LineModel.backModel,
    this.linearGradient,
    this.center,
    this.addAutomaticKeepAlive = true,
    this.strokeCap,
    this.arcType = ArcType.FULL,
    this.reverse = false,
    this.maskFilter,
    this.rotateLinearGradient = false,
  }) : super(key: key) {
    assert(startAngle >= 0.0);
    if (percentModel.percent < 0.0 || percentModel.percent > 1.0) {
      throw Exception('Percent value must be a double between 0.0 and 1.0');
    }
  }

  @override
  _CircularPercentIndicatorState createState() =>
      _CircularPercentIndicatorState();
}

class _CircularPercentIndicatorState extends State<CircularPercentIndicator>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController? _animationController;
  Animation? _animation;
  double _percent = 0.0;

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.animationSet.animationDuration > 0) {
      _animationController = AnimationController(
          vsync: this,
          duration:
              Duration(milliseconds: widget.animationSet.animationDuration));
      _animation = Tween(begin: 0.0, end: widget.percentModel.percent).animate(
        CurvedAnimation(
            parent: _animationController!, curve: widget.animationSet.curve),
      )..addListener(() {
          setState(() {
            _percent = _animation!.value;
          });
          if (widget.animationSet.restartAnimation && _percent == 1.0) {
            _animationController!.repeat(min: 0, max: 1.0);
          }
        });
      _animationController!.addStatusListener((status) {
        if (widget.animationSet.onAnimationEnd != null &&
            status == AnimationStatus.completed) {
          widget.animationSet.onAnimationEnd!();
        }
      });
      _animationController!.forward();
    } else {
      _updateProgress();
    }
    super.initState();
  }

  void _checkIfNeedCancelAnimation(CircularPercentIndicator oldWidget) {
    if (oldWidget.animationSet.animationDuration > 0 &&
        widget.animationSet.animationDuration == 0 &&
        _animationController != null) {
      _animationController!.stop();
    }
  }

  @override
  void didUpdateWidget(CircularPercentIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentModel.percent != widget.percentModel.percent ||
        oldWidget.startAngle != widget.startAngle) {
      if (_animationController != null) {
        _animationController!.duration =
            Duration(milliseconds: widget.animationSet.animationDuration);
        _animation = Tween(
                begin: widget.animationSet.animateFromLastPercent
                    ? oldWidget.percentModel.percent
                    : 0.0,
                end: widget.percentModel.percent)
            .animate(
          CurvedAnimation(
              parent: _animationController!, curve: widget.animationSet.curve),
        );
        _animationController!.forward(from: 0.0);
      } else {
        _updateProgress();
      }
    }
    _checkIfNeedCancelAnimation(oldWidget);
  }

  void _updateProgress() {
    setState(() {
      _percent = widget.percentModel.percent;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Material(
      color: widget.percentModel.fillColor,
      child: Container(
        height: widget.size,
        width: widget.size,
        child: Stack(
          children: [
            CustomPaint(
              painter: CirclePainter(
                  progress: _percent * 360,
                  progressColor: widget.progressModel.color,
                  backgroundColor: widget.backgroundModel.color,
                  startAngle: widget.startAngle,
                  strokeCap: widget.strokeCap,
                  radius: (widget.size / 2) - widget.progressModel.width / 2,
                  lineWidth: widget.progressModel.width,
                  backgroundWidth: widget.backgroundModel.width >= 0.0
                      ? widget.backgroundModel.width
                      : widget.progressModel.width,
                  arcType: widget.arcType,
                  reverse: widget.reverse,
                  linearGradient: widget.linearGradient,
                  maskFilter: widget.maskFilter,
                  rotateLinearGradient: widget.rotateLinearGradient),
              child: (widget.center != null)
                  ? Center(child: widget.center)
                  : Container(),
            ),
            if (widget.animationSet.widgetIndicator != null &&
                widget.animationSet.animationDuration > 0)
              Positioned.fill(
                child: Transform.rotate(
                  angle: radians(
                          (widget.strokeCap != StrokeCap.butt && widget.reverse)
                              ? -15
                              : 0)
                      .toDouble(),
                  child: Transform.rotate(
                    angle: radians((widget.reverse ? -360 : 360) * _percent)
                        .toDouble(),
                    child: Transform.translate(
                      offset: Offset(
                        (widget.strokeCap != StrokeCap.butt)
                            ? widget.progressModel.width / 2
                            : 0,
                        (-widget.size / 2 + widget.progressModel.width / 2),
                      ),
                      child: widget.animationSet.widgetIndicator,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.addAutomaticKeepAlive;
}
