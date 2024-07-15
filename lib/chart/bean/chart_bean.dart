/*
 * @Author: Cao Shixin
 * @Date: 2020-08-20 20:35:07
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2023-03-28 15:22:48
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/enum/chart_pie_enum.dart';
import 'package:flutter_chart_csx/chart/enum/painter_const.dart';

//xy的显示点位的两员大将
//y轴
class DialStyleY {
  //与最大数值的比率，用来计算绘制刻度的位置使用。
  ///这个也和[centerSubTitle]有关（比如：1.0和最近的下一个比率0.5之间的居中副标题取的是[positionRetioy]为1.0的副标题）
  double positionRetioy;

  ///y轴值,用以计算绘制点落的区间比较使用,在区间放大的折线图中体现
  double yValue;
  //左侧文案设定
  DialStyleYSub? leftSub;
  //右侧文案设定
  DialStyleYSub? rightSub;

  /// 如果有辅助线的时候，需要特殊设置的辅助线颜色，这个参数对标baseBean模型参数中的[hintLineColor]，这里不为空的以后，这个[positionRetioy]的辅助线颜色设置以此为准
  Color? hintLineColor;

  /// 目前只对ChartLineFocus有效，其他图表暂时无意义
  /// 如果FocusChartBeanMain中的参数[gradualColors]参数设置为null的时候，区间渐变从此区间顶topcenter，到区间底部bottomcenter的LinearGradient颜色填充。如果不设置则默认此区间y轴副文本颜色，bottomcenter为此区间y轴副文本颜色的0.3
  List<Color>? fillColors;

  DialStyleY(
      {this.hintLineColor,
      this.fillColors,
      this.leftSub,
      this.rightSub,
      required this.yValue,
      required this.positionRetioy});
}

class DialStyleYSub {
  //刻度标志内容(y轴仅适用于内容为数值类型的)
  String title;
  //刻度标志样式
  TextStyle titleStyle;
  //两个刻度之间的标注文案（y轴在数组中下一个元素之间绘制）,不需要的话不设置
  String centerSubTitle;
  //标注文案样式，centerSubTitle有内容时有效
  TextStyle centerSubTextStyle;
  DialStyleYSub(
      {this.title = '',
      this.titleStyle = defaultTextStyle,
      this.centerSubTitle = '',
      this.centerSubTextStyle = defaultTextStyle});
}

//x轴
class DialStyleX {
  //刻度标志内容
  String? title;
  //刻度标志样式
  TextStyle? titleStyle;
  //与最大数值的比率，用来计算绘制刻度的位置使用。
  double? positionRetioy;
  DialStyleX({this.title, this.titleStyle, this.positionRetioy});
}

//基本的xy轴设置属性参数
class BaseBean {
  //xy轴线条的高度宽度
  double xyLineWidth;
  //x轴的颜色
  Color xColor;
  //y轴的颜色
  Color yColor;
  //顶部的辅助线
  bool isShowBorderTop;
  //右侧的辅助线
  bool isShowBorderRight;
  //y轴左侧刻度显示，传空数组则没有y轴刻度等信息
  List<DialStyleY> yDialValues;
  //y轴两个文案依赖.默认true:左侧为主,兼容之前区间线条颜色显示区间附文本颜色的需求
  bool yDialLeftMain;
  //是否显示x轴文本,
  bool isShowX;
  //y轴最大值
  double yMax;
  //y轴最小值
  double yMin;
  //y轴可容纳的区间值大小
  double get yAdmissSecValue => yMin == yMax ? 1.0 : yMax - yMin;
  //xy轴默认的边距，不包含周围的标注文字高度，只是xy轴的方框距离周围容器的间距
  EdgeInsets basePadding;
  //x轴辅助线
  bool isShowHintX;
  //y轴的辅助线
  bool isShowHintY;
  //辅助线颜色
  Color hintLineColor;
  //辅助线宽度
  double hintLineWidth;
  //辅助线是否为虚线
  bool isHintLineImaginary;
  //是否显示x轴刻度
  bool isShowXScale;
  //是否显示y轴刻度
  bool isShowYScale;
  //xy轴刻度的高度
  double rulerWidth;
  //xy轴的单位。默认null，不绘制单位
  List<UnitXY>? units;

  ///x轴在y轴上的数值，不设置表示x轴在坐标系的最底部（如果不为空，则按照此数值在[yMax]和[yMin]之间的占比对应位置绘制一条水平线）
  double? xBaseLineY;

  BaseBean({
    this.xyLineWidth = 2,
    this.xColor = defaultColor,
    this.yColor = defaultColor,
    this.isShowBorderTop = false,
    this.isShowBorderRight = false,
    required this.yDialValues,
    this.yDialLeftMain = true,
    this.isShowX = true,
    this.yMax = 100.0,
    this.yMin = 0.0,
    this.basePadding = defaultBasePadding,
    this.isShowHintX = false,
    this.isShowHintY = false,
    this.hintLineColor = defaultColor,
    this.hintLineWidth = 1.0,
    this.isHintLineImaginary = false,
    this.isShowXScale = false,
    this.isShowYScale = false,
    this.rulerWidth = 4,
    this.units,
    this.xBaseLineY,
  }) {
    //比率大的在前面排序
    yDialValues
        .sort((v1, v2) => v2.positionRetioy.compareTo(v1.positionRetioy));
  }
}

enum UnitOrientation {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

//x、y轴两侧的单位标记模型
//都是横向展示的文案
class UnitXY {
  //基准点的方位
  UnitOrientation baseOrientation;
  //文案对应基准点的x,y间距差，默认没有间距差.按照常规设计(左上:文案的右下点,左下:文案的右上点,右上:文案的左下点,右下:文案的左上点)分别对应相应的基准点的偏移
  Offset spaceDif;
  //文案内
  String text;
  //内容样式
  TextStyle textStyle;
  UnitXY(
      {required this.baseOrientation,
      this.spaceDif = Offset.zero,
      this.text = '',
      this.textStyle = defaultTextStyle});
}

class CellPointSet {
  //线条点的显示样式,默认矩形模式
  final PointType pointType;
  //线条点的尺寸
  final Size pointSize;
  //线条点的圆角
  final Radius pointRadius;
  //线条点渐变色，从上到下的闭合颜色集
  final List<Color>? pointShaderColors;
  //PointType为PlacehoderImage的时候下面参数才有意义
  //用户当前进行位置的小图标（比如一个小锁），默认没有只显示y轴的值，如果有内容则显示这个小图标，
  final ui.Image? placehoderImage;
  final Size placeImageSize;

  //centerPoint的中心与位置的偏移
  final Offset centerPointOffset;
  //centerPoint的中心与位置的偏移的线颜色（目前是虚线颜色连接）
  final Color centerPointOffsetLineColor;
  //在该点上下左右的辅助线样式，默认不设置就没有辅助线了
  final HintEdgeInset hintEdgeInset;

  const CellPointSet({
    this.pointType = PointType.Rectangle,
    this.pointSize = Size.zero,
    this.pointRadius = Radius.zero,
    this.pointShaderColors,
    this.placehoderImage,
    this.placeImageSize = Size.zero,
    this.centerPointOffset = Offset.zero,
    this.centerPointOffsetLineColor = defaultColor,
    this.hintEdgeInset = HintEdgeInset.none,
  });

  static const CellPointSet normal = CellPointSet();
}

//某点上下左右的辅助线显示类型,不设置某个方位的类型就不会绘制
class HintEdgeInset {
  final PointHintParam? left;
  final PointHintParam? top;
  final PointHintParam? right;
  final PointHintParam? bottom;

  const HintEdgeInset.fromLTRB(this.left, this.top, this.right, this.bottom);

  const HintEdgeInset.all(PointHintParam value)
      : left = value,
        top = value,
        right = value,
        bottom = value;

  const HintEdgeInset.only({
    this.left,
    this.top,
    this.right,
    this.bottom,
  });

  static const HintEdgeInset none = HintEdgeInset.only();

  const HintEdgeInset.symmetric({
    PointHintParam? vertical,
    PointHintParam? horizontal,
  })  : left = horizontal,
        top = vertical,
        right = horizontal,
        bottom = vertical;
}

class PointHintParam {
  //辅助线颜色
  Color hintColor;
  //辅助线是否是虚线
  bool isHintLineImaginary;
  //辅助线宽度
  double hintLineWidth;
  PointHintParam(
      {this.hintColor = defaultColor,
      this.isHintLineImaginary = true,
      this.hintLineWidth = 1.0});
}

class TextSetModel {
  //标题
  String title;
  //标题字体样式
  TextStyle titleStyle;
  TextSetModel({this.title = '', this.titleStyle = defaultTextStyle});
}

class ImgSetModel {
  //图片
  ui.Image img;
  //图片尺寸
  Size imgSize;
  ImgSetModel({required this.img, required this.imgSize});
}
