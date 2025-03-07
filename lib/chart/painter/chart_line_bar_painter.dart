import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/base/painter_const.dart';

import '../base/base_painter.dart';
import '../base/chart_bean.dart';
import '../bean/chart_bean_bar_line.dart';
import '../bean/chart_bean_bar_line_content.dart';
import '../bean/chart_bean_content.dart';
import '../util/base_painter_tool.dart';

class ChartLineBarPainter extends BasePainter {
  //x轴刻度显示，不传则没有
  List<DialStyleX>? xDialValues;
  //柱线模型
  List<ChartLineBarBeanSystem> lineBarSystems;
  //触摸选中点
  Offset? touchLocalPosition;
  //触摸点设置
  CellPointSet pointSet;
  //选中
  RectModel? rectModel;
  LineBarSelectSet? selectModelSet;

  late double _fixedHeight, _fixedWidth, _startX, _endX, _startY, _endY;
  late List<LineBarTouchCellModel> _touchCellModels;

  ChartLineBarPainter(
    this.lineBarSystems, {
    this.xDialValues,
    this.touchLocalPosition,
    this.pointSet = CellPointSet.normal,
    this.rectModel,
    this.selectModelSet,
  });

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    _init(size);
    //xy轴
    _drawXy(canvas, size);
    //柱状线图
    _drawLineBar(canvas, size);
    //选中背景
    _drawSelectBg(canvas);
    //拖拽+点击的特殊点显示
    _drawTouchSpecialPointAndHitLine(canvas);
  }

  //初始化
  void _init(Size size) {
    _startX = baseBean.basePadding.left;
    _endX = size.width - baseBean.basePadding.right;
    _startY = size.height - baseBean.basePadding.bottom;
    _endY = baseBean.basePadding.top;
    _fixedHeight = _startY - _endY;
    _fixedWidth = _endX - _startX;
    _touchCellModels = <LineBarTouchCellModel>[];
  }

  //x,y轴绘制
  void _drawXy(Canvas canvas, Size size) {
    PainterTool.drawCoordinateAxis(
        canvas,
        CoordinateAxisModel(
          _fixedHeight,
          _fixedWidth,
          baseBean: baseBean,
          xDialValues: xDialValues ?? [],
          xyCoordinate: XYCoordinate.All,
        ));
  }

  //柱状线图
  void _drawLineBar(Canvas canvas, Size size) {
    if (lineBarSystems.isEmpty) return;
    if (baseBean.yAdmissSecValue <= 0) return;
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    lineBarSystems.forEach((e) {
      var lineBarBeans = e.lineBarBeans;
      //排序，小的在前面
      lineBarBeans.sort((a, b) => a.startRatio.compareTo(b.startRatio));
      //处理两端null的数据
      lineBarBeans = _trimNulls(lineBarBeans);

      var paths = <Path>[];
      Path? _path;
      for (var i = 0; i < lineBarBeans.length; i++) {
        var ele = lineBarBeans[i];
        if (ele.value != null) {
          var contentHeight = (ele.value! - baseBean.yMin) /
              baseBean.yAdmissSecValue *
              _fixedHeight;
          var offsetY = _startY - contentHeight;
          var lineStartX = _startX + ele.startRatio * _fixedWidth;
          var contentWidth = ele.widthRatio * _fixedWidth;
          var lineEndX = lineStartX + contentWidth;
          if (_path == null) {
            _path = Path()..moveTo(lineStartX, offsetY);
          } else {
            _path.lineTo(lineStartX, offsetY);
          }
          _path.lineTo(lineEndX, offsetY);
          if (e.enableTouch) {
            _touchCellModels.add(
              LineBarTouchCellModel(
                  begainPoint: Offset(lineStartX, offsetY),
                  size: Size(contentWidth, contentHeight),
                  param: ele.param),
            );
          }
        } else if (_path != null) {
          paths.add(_path);
          _path = null;
        }
      }
      if (_path != null) {
        paths.add(_path);
        _path = null;
      }

      if (paths.isNotEmpty) {
        if (e.segmentationModel != null) {
          var baseLineY = _startY -
              (e.segmentationModel!.baseLineY - baseBean.yMin) /
                  (baseBean.yMax - baseBean.yMin) *
                  _fixedHeight;
          var topPath = Path()
            ..moveTo(_startX, baseLineY)
            ..lineTo(_endX, baseLineY)
            ..lineTo(_endX, _endY)
            ..lineTo(_startX, _endY)
            ..lineTo(_startX, baseLineY)
            ..close();
          canvas.save();
          canvas.clipPath(topPath);
          paint
            ..strokeWidth = e.lineWidth
            ..color = e.segmentationModel!.baseLineTopColor;
          paths.forEach((e) => canvas.drawPath(e, paint));
          canvas.restore();

          var bottomPath = Path()
            ..moveTo(_startX, baseLineY)
            ..lineTo(_endX, baseLineY)
            ..lineTo(_endX, _startY)
            ..lineTo(_startX, _startY)
            ..lineTo(_startX, baseLineY)
            ..close();
          canvas.save();
          canvas.clipPath(bottomPath);
          paint
            ..strokeWidth = e.lineWidth
            ..color = e.segmentationModel!.baseLineBottomColor;
          paths.forEach((e) => canvas.drawPath(e, paint));
          canvas.restore();
        } else {
          paint
            ..strokeWidth = e.lineWidth
            ..color = e.lineColor ?? defaultColor;
          paths.forEach((e) => canvas.drawPath(e, paint));
        }
      }
    });
  }

  List<LineBarSectionBean> _trimNulls(List<LineBarSectionBean> array) {
    // 移除前面连续的 null 元素
    int start = 0;
    while (start < array.length && array[start].value == null) {
      start++;
    }
    // 移除结尾连续的 null 元素
    int end = array.length - 1;
    while (end >= start && array[end].value == null) {
      end--;
    }
    // 截取非 null 的部分并返回
    return array.sublist(start, end + 1);
  }

  //绘制特殊点
  void _drawTouchSpecialPointAndHitLine(Canvas canvas) {
    if (_touchCellModels.isNotEmpty && touchLocalPosition != null) {
      //表示有设置可以触摸的线条
      PainterTool.drawSpecialPointHintLine(
          canvas,
          PointModel(offset: touchLocalPosition!, cellPointSet: pointSet),
          _startX,
          _endX,
          _startY,
          _endY);
    }
  }

  //选中柱，添加背景色
  void _drawSelectBg(Canvas canvas) {
    if (rectModel != null && selectModelSet != null) {
      canvas.drawRect(
          Rect.fromLTWH(
              rectModel!.offsetX, _endY, rectModel!.sizeWidth, _fixedHeight),
          Paint()
            ..isAntiAlias = true
            ..strokeCap = StrokeCap.round
            ..color = selectModelSet!.highLightColor
            ..style = PaintingStyle.fill);
    }
  }

  //外部拖拽获取触摸点最近的点位, 点击坐标轴以外区域直接返回空offset，和取消一样的效果
  LineBarTouchBackModel getNearbyPoint(Offset localPosition,
      {bool defaultCancelTouchChoose = true}) {
    if (localPosition.dx <= _startX ||
        localPosition.dx >= _endX ||
        localPosition.dy >= _startY ||
        localPosition.dy <= _endY) {
      //不在坐标轴内部的点击
      if (defaultCancelTouchChoose) {
        return LineBarTouchBackModel(startOffset: null, size: Size.zero);
      } else {
        return LineBarTouchBackModel(
            needRefresh: false, startOffset: null, size: Size.zero);
      }
    }
    _touchCellModels.sort((a, b) => a.centerX.compareTo(b.centerX));
    LineBarTouchCellModel? _touchModel;
    if (_touchCellModels.length <= 1) {
      _touchModel = _touchCellModels.isEmpty ? null : _touchCellModels.first;
    } else {
      for (var i = 0; i < _touchCellModels.length - 1; i++) {
        var currentX = _touchCellModels[i].centerX;
        var nextX = _touchCellModels[i + 1].centerX;
        if (i == 0 && localPosition.dx < currentX) {
          _touchModel = _touchCellModels.first;
          break;
        }
        if (i == _touchCellModels.length - 2 && localPosition.dx >= nextX) {
          _touchModel = _touchCellModels.last;
          break;
        }
        if (localPosition.dx >= currentX && localPosition.dx < nextX) {
          var speaceWidth = nextX - currentX;
          if (localPosition.dx <= currentX + speaceWidth / 2) {
            _touchModel = _touchCellModels[i];
          } else {
            _touchModel = _touchCellModels[i + 1];
          }
          break;
        }
      }
    }
    if (_touchModel == null) {
      return LineBarTouchBackModel(startOffset: null, size: Size.zero);
    } else {
      return LineBarTouchBackModel(
          startOffset: _touchModel.begainPoint,
          size: _touchModel.size,
          backParam: _touchModel.param);
    }
  }
}
