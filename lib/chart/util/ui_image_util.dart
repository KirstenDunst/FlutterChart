/*
 * @Author: Cao Shixin
 * @Date: 2020-07-31 13:42:31
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-12-10 15:03:42
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

  //获取网络图片 返回ui.Image
  static Future<ui.Image> getNetImage(String url, {width, height}) async {
    var data = await NetworkAssetBundle(Uri.parse(url)).load(url);
    var codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    var fi = await codec.getNextFrame();
    return fi.image;
  }
}
