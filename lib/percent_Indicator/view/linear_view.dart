/*
 * @Author: Cao Shixin
 * @Date: 2021-09-23 17:26:14
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2023-03-28 15:07:57
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/percent_Indicator/model/linear_model.dart';
import 'package:flutter_chart_csx/percent_Indicator/model/percent_model.dart';
import 'package:flutter_chart_csx/percent_Indicator/painter/linear_painter.dart';

class LinearPercentIndicator extends StatefulWidget {
  ///通用基础设置
  final PercentModel percentModel;

  ///动画设置
  final AnimationSet animationSet;

  /// 是否要求动画从右向左，默认false，从左向右绘制
  final bool isRTL;

  ///线条宽度，可以不指定，区域内填满
  final double? width;

  ///线条高度
  final double lineHeight;

  ///背景色值设置
  final ColorGradientModel backgroundGradient;

  ///进度色值设置
  final ColorGradientModel progressGradient;

  ///线条上的widget，居中显示
  final CenterSet centerSet;

  ///完成放置在线的末端绘制类型。这里不存在方形收尾，[StrokeCap.square]处理为背景线条和进度线条弧形收尾
  final StrokeCap strokeCap;

  /// Creates a mask filter that takes the progress shape being drawn and blurs it.
  final MaskFilter? maskFilter;

  /// [progressGradient.linearGradient] 设置的时候进度颜色渐变范围，默认false：progress的长度内渐变，true：整个进度条背景长度的范围内，
  final bool clipLinearGradient;

  /// 保存状态，避免重复绘制，默认true
  final bool addAutomaticKeepAlive;

  LinearPercentIndicator(
      {Key? key,
      this.percentModel = PercentModel.normal,
      this.animationSet = AnimationSet.normal,
      this.isRTL = false,
      this.width,
      this.lineHeight = 5.0,
      this.backgroundGradient = ColorGradientModel.backModel,
      this.progressGradient = ColorGradientModel.progressModel,
      this.centerSet = CenterSet.normal,
      this.strokeCap = StrokeCap.butt,
      this.maskFilter,
      this.clipLinearGradient = false,
      this.addAutomaticKeepAlive = true})
      : super(key: key) {
    if (percentModel.percent < 0.0 || percentModel.percent > 1.0) {
      throw Exception('Percent value must be a double between 0.0 and 1.0');
    }
  }

  @override
  _LinearPercentIndicatorState createState() => _LinearPercentIndicatorState();
}

class _LinearPercentIndicatorState extends State<LinearPercentIndicator>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController? _animationController;
  Animation? _animation;
  double _percent = 0.0;
  final _containerKey = GlobalKey();
  final _keyIndicator = GlobalKey();
  double _containerWidth = 0.0;
  double _containerHeight = 0.0;
  double _indicatorWidth = 0.0;
  double _indicatorHeight = 0.0;

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _containerWidth = _containerKey.currentContext?.size?.width ?? 0.0;
          _containerHeight = _containerKey.currentContext?.size?.height ?? 0.0;
          if (_keyIndicator.currentContext != null) {
            _indicatorWidth = _keyIndicator.currentContext?.size?.width ?? 0.0;
            _indicatorHeight =
                _keyIndicator.currentContext?.size?.height ?? 0.0;
          }
        });
      }
    });
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

  void _checkIfNeedCancelAnimation(LinearPercentIndicator oldWidget) {
    if (oldWidget.animationSet.animationDuration > 0 &&
        widget.animationSet.animationDuration == 0 &&
        _animationController != null) {
      _animationController!.stop();
    }
  }

  @override
  void didUpdateWidget(LinearPercentIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentModel.percent != widget.percentModel.percent) {
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
    final percentPositionedHorizontal =
        _containerWidth * _percent - _indicatorWidth / 3;
    var containerWidget = SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.lineHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            key: _containerKey,
            painter: LinearPainter(
              isRTL: widget.isRTL,
              progress: _percent,
              progressModel: widget.progressGradient,
              backgroundModel: widget.backgroundGradient,
              strokeCap: widget.strokeCap,
              lineWidth: widget.lineHeight,
              maskFilter: widget.maskFilter,
              clipLinearGradient: widget.clipLinearGradient,
              centerText: widget.centerSet.center == null
                  ? widget.centerSet.centerText
                  : '',
              centerTextStyle: widget.centerSet.centerTextStyle,
            ),
            child: (widget.centerSet.center != null)
                ? Center(child: widget.centerSet.center)
                : Container(),
          ),
          if (widget.animationSet.widgetIndicator != null &&
              _indicatorWidth == 0)
            Opacity(
              opacity: 0.0,
              key: _keyIndicator,
              child: widget.animationSet.widgetIndicator,
            ),
          if (widget.animationSet.widgetIndicator != null &&
              _containerWidth > 0 &&
              _indicatorWidth > 0)
            Positioned(
              right: widget.isRTL ? percentPositionedHorizontal : null,
              left: !widget.isRTL ? percentPositionedHorizontal : null,
              top: _containerHeight / 2 - _indicatorHeight,
              child: widget.animationSet.widgetIndicator!,
            ),
        ],
      ),
    );

    return Material(
      color: Colors.transparent,
      child: Container(
        color: widget.percentModel.fillColor,
        child: containerWidget,
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.addAutomaticKeepAlive;
}
