/*
 * @Author: Cao Shixin
 * @Date: 2021-09-23 17:28:30
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2021-09-24 17:47:34
 * @Description: 
 */

//默认字体样式
import 'package:flutter/material.dart';

const Color defaultColor = Colors.purple;

const TextStyle defaultTextStyle = TextStyle(color: defaultColor, fontSize: 10);

///圆形进度的展示类型
enum ArcType {
  //半圆
  HALF,
  //全圆
  FULL,
}
