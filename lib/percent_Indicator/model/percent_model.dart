/*
 * @Author: Cao Shixin
 * @Date: 2021-09-23 17:30:08
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2021-09-24 11:07:17
 * @Description: 
 */
import 'package:flutter/material.dart';

class PercentModel {
  ///进度 0.0～1.0
  final double percent;

  ///背景色 , 默认透明
  final Color fillColor;

  PercentModel({this.percent = 0.0, this.fillColor = Colors.transparent});

  const PercentModel.none()
      : percent = 0.0,
        fillColor = Colors.transparent;

  static const PercentModel normal = PercentModel.none();
}

class AnimationSet {
  ///动画的时长， 单位milliseconds
  final int animationDuration;

  /// 动画结束回调
  final VoidCallback? onAnimationEnd;

  /// 当动画开启的时候，放置在动画进度的位置的一个指示器
  final Widget? widgetIndicator;

  ///是否无限重复动画 默认 false
  final bool restartAnimation;

  ///让动画从上次的百分比开始
  final bool animateFromLastPercent;

  /// set a linear curve animation type
  final Curve curve;

  AnimationSet({
    this.animationDuration = 0,
    this.onAnimationEnd,
    this.widgetIndicator,
    this.restartAnimation = false,
    this.animateFromLastPercent = false,
    this.curve = Curves.linear,
  });

  const AnimationSet.normalSet()
      : animationDuration = 0,
        onAnimationEnd = null,
        widgetIndicator = null,
        restartAnimation = false,
        animateFromLastPercent = false,
        curve = Curves.linear;

  static const AnimationSet normal = AnimationSet.normalSet();
}
