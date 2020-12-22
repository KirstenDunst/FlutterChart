/*
 * @Author: Cao Shixin
 * @Date: 2020-08-20 20:35:07
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-12-22 18:12:47
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/enum/painter_const.dart';

//xy的显示点位的两员大将
//y轴
class DialStyleY {
  //刻度标志内容(y轴仅适用于内容为数值类型的)
  String title;
  //y轴获取的值，只读
  double get titleValue {
    if (title == null || title.isEmpty) {
      return 0;
    } else {
      return double.parse(title);
    }
  }

  //刻度标志样式
  TextStyle titleStyle;
  //与最大数值的比率，用来计算绘制刻度的位置使用。
  double positionRetioy;
  //两个刻度之间的标注文案（y轴在数组中下一个元素之间绘制，最后一个元素则在最后一个点上面绘制）,不需要的话不设置
  String centerSubTitle;
  //标注文案样式，centerSubTitle有内容时有效
  TextStyle centerSubTextStyle;
  DialStyleY(
      {this.title,
      this.titleStyle,
      this.centerSubTitle,
      this.centerSubTextStyle,
      this.positionRetioy});
}
//x轴
class DialStyleX {
  //刻度标志内容
  String title;
  //刻度标志样式
  TextStyle titleStyle;
  //与最大数值的比率，用来计算绘制刻度的位置使用。
  double positionRetioy;
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
  //y轴左侧刻度显示，不传则没有
  List<DialStyleY> yDialValues;
  //y轴显示副刻度是在左侧还是在右侧，默认左侧
  bool isLeftYDialSub;
  //是否显示x轴文本,
  bool isShowX;
  //y轴最大值
  double yMax;
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

  BaseBean({
    this.xyLineWidth = 2,
    this.xColor = defaultColor,
    this.yColor = defaultColor,
    this.isShowBorderTop = false,
    this.isShowBorderRight = false,
    this.yDialValues,
    this.isLeftYDialSub = true,
    this.isShowX = true,
    this.yMax = 100.0,
    this.basePadding = defaultBasePadding,
    this.isShowHintX = false,
    this.isShowHintY = false,
    this.hintLineColor = defaultColor,
    this.hintLineWidth = 1.0,
    this.isHintLineImaginary = false,
    this.isShowXScale = false,
    this.isShowYScale = false,
    this.rulerWidth = 4,
  });
}
