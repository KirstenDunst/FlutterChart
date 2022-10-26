/*
 * @Author: Cao Shixin
 * @Date: 2021-06-05 14:22:15
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2021-06-23 17:24:28
 * @Description: 
 */
import 'package:flutter/material.dart';

//长按、点击回调

/* 
 * 点的处理
 * 相对于起始的偏移point,如果为null则辅助消失，value：触摸外传的参数（自给自足）
 */
typedef PointPressPointBack = Function(Offset? point, dynamic value);

/* 
 * 柱状图的处理
 * 相对于起始的偏移point,如果为null则辅助消失，size：柱体的大小，value：触摸外传的参数（touchBackParam）
 */
typedef BarPointBack = Function(Offset? point, Size size, dynamic value);

/* 
 * 维度图的处理
 * isTouch 是否是点击触发的回调
 * 相对于起始的偏移point,如果为null则辅助消失
 * size：文案cell的大小
 * index: 选中的维度的下标
 * value：触摸外传的参数（touchBackParam）
 */
typedef DimensionaBack = Function(bool isTouch,
    Offset? point, Size size, int index, dynamic value);
