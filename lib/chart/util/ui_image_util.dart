/*
 * @Author: Cao Shixin
 * @Date: 2020-07-31 13:42:31
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-07-31 13:44:36
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class UIImageUtil {
  /// 加载canvas绘制的图片
  static Future<ui.Image> loadImage(String path) async {
    var data = await rootBundle.load(path);
    var codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    var info = await codec.getNextFrame();

    return info.image;
  }
}
