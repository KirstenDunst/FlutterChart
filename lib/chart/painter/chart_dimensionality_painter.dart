/*
 * @Author: Cao Shixin
 * @Date: 2020-07-17 17:38:37
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2022-06-23 09:26:08
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/chart/base/chart_bean.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_content.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_dimensionality.dart';
import 'package:flutter_chart_csx/chart/bean/chart_bean_dimensionality_content.dart';
import '../base/painter_const.dart';
import 'package:flutter_chart_csx/chart/base/base_painter.dart';
import 'package:path_drawing/path_drawing.dart';

import '../util/base_painter_tool.dart';

class ChartDimensionalityPainter extends BasePainter {
  //维度划分的重要参数(决定有几个内容就是几个维度，从正上方顺时针方向绘制)
  List<ChartBeanDimensionality> dimensionalityDivisions;
  //选中的index
  int? selectDimensionIndex;
  //维度填充数据的重要内容
  List<DimensionalityBean> dimensionalityTags;
  //背景设置
  DimensionBGSet bgSet;
  //圆半径，不传则容器内最大范围显示
  double? centerR;
  //圆心
  late double _centerX, _centerY, _averageAngle, _centerR;
  List<DimensionabilityTouchBackModel>? _cellModel;
  late List<DimensionBgCircleLine> _simensionBgCircleLines;

  ChartDimensionalityPainter({
    required this.dimensionalityDivisions,
    required this.dimensionalityTags,
    this.selectDimensionIndex,
    this.bgSet = DimensionBGSet.normal,
    this.centerR,
  });

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    //初始化数据
    _init(size);
    // 绘制基础网状结构
    _createBase(canvas);
    //绘制内部多边形彩色区域
    _createPaintShadowPath(canvas, size);
  }

  /// 初始化
  void _init(Size size) {
    _initValue();
    _initlizeData(size);
  }

  /// 初始化数据
  void _initValue() {
    _simensionBgCircleLines =
        bgSet.circleLines ?? [DimensionBgCircleLine.normal];
    if (selectDimensionIndex != null) {
      selectDimensionIndex =
          selectDimensionIndex!.clamp(0, dimensionalityDivisions.length - 1);
    }
  }

  /// 初始化角度
  void _initlizeData(Size size) {
    var startX = baseBean.basePadding.left;
    var endX = size.width - baseBean.basePadding.right;
    var endY = baseBean.basePadding.top;
    var startY = size.height - endY - baseBean.basePadding.bottom;
    _centerX = startX + (endX - startX) / 2;
    _centerY = endY + (startY - endY) / 2;
    var xR = endX - _centerX;
    var yR = startY - _centerY;
    var tempCenterR = min(xR, yR);
    _centerR = tempCenterR;
    if (centerR != null && centerR! < tempCenterR) {
      _centerR = centerR!;
    }
    _averageAngle = 2 * pi / dimensionalityDivisions.length;
  }

  /// 绘制基本角
  void _createBase(Canvas canvas) {
    _cellModel = <DimensionabilityTouchBackModel>[];

    //基础经度网状绘制
    var speaceIndex = _centerR / _simensionBgCircleLines.length;
    var basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;
    for (var i = 0; i < _simensionBgCircleLines.length; i++) {
      var tempModel = _simensionBgCircleLines[i];
      var tempLength = _centerR - speaceIndex * i;
      basePaint
        ..strokeWidth = tempModel.lineWidth
        ..color = tempModel.lineColor;
      var baseLinePath = Path();
      if (bgSet.isCircle) {
        baseLinePath.addArc(
            Rect.fromCenter(
                center: Offset(_centerX, _centerY),
                width: tempLength * 2,
                height: tempLength * 2),
            0,
            pi * 2);
      } else {
        late Point firstPoint;
        for (var j = 0; j < dimensionalityDivisions.length; j++) {
          var tempPoint =
              _getBaseCenterLengthAnglePoint(tempLength, _averageAngle * j);
          if (j == 0) {
            firstPoint = Point(tempPoint.x, tempPoint.y);
            baseLinePath.moveTo(tempPoint.x.toDouble(), tempPoint.y.toDouble());
          } else {
            baseLinePath..lineTo(tempPoint.x.toDouble(), tempPoint.y.toDouble());
          }
        }
        baseLinePath
          ..lineTo(firstPoint.x.toDouble(), firstPoint.y.toDouble())
          ..close();
      }
      canvas.drawPath(
          tempModel.isHintLineImaginary
              ? dashPath(
                  baseLinePath,
                  dashArray: CircularIntervalList<double>(<double>[5.0, 4.0]),
                )
              : baseLinePath,
          basePaint);
    }

    //是否需要绘制纬度的柱体（从中心到文字的线）
    var needDimensionLine = bgSet.dimensionLineWidth > 0 &&
        bgSet.dimensionLineColor != Colors.transparent;
    var dimensionLinePaint = Paint()
      ..strokeWidth = bgSet.dimensionLineWidth
      ..color = bgSet.dimensionLineColor
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;
    //角度线
    for (var j = 0; j < dimensionalityDivisions.length; j++) {
      //纬度文案绘制
      var model = dimensionalityDivisions[j];
      _createTextWithPara(
          model.tip,
          model.subTip,
          model.normalStyle,
          model.selectStyle,
          (selectDimensionIndex != null && j == selectDimensionIndex),
          _averageAngle * j,
          canvas,
          model.touchBackParam,
          j);
      if (needDimensionLine) {
        //纬度柱体绘制(这里绘制防止受等级圈线条的遮挡)
        var tempPoint =
            _getBaseCenterLengthAnglePoint(_centerR, _averageAngle * j);
        canvas.drawPath(
            Path()
              ..moveTo(_centerX, _centerY)
              ..lineTo(tempPoint.x.toDouble(), tempPoint.y.toDouble()),
            dimensionLinePaint);
      }
    }
  }

  /// 获取对应弧度在圆边角的对应点
  /// length：长度
  /// angle：角度
  Point _getBaseCenterLengthAnglePoint(double length, double angle) {
    return Point(
        _centerX + sin(angle) * length, _centerY - cos(angle) * length);
  }

  /// 绘制维度文字
  /// text：文案
  /// textStyle：文案样式
  /// angle：角度
  /// canvas：
  /// size：
  void _createTextWithPara(
      List<TipModel>? text,
      List<TipModel>? subText,
      DimensionCellStyle normalStyle,
      DimensionCellStyle selectStyle,
      bool isSelect,
      double angle,
      Canvas canvas,
      dynamic param,
      int index) {
    var cellStyle = isSelect ? selectStyle : normalStyle;
    var titleTp = TextPainter(
        textAlign: TextAlign.center,
        ellipsis: '.',
        maxLines: 1,
        text: text != null
            ? TextSpan(
                children: text
                    .map((e) => TextSpan(
                        text: e.title,
                        style: isSelect ? e.selectStyle : e.titleStyle))
                    .toList(),
              )
            : TextSpan(
                style: defaultTextStyle.copyWith(fontSize: 0),
              ),
        textDirection: TextDirection.ltr)
      ..layout();
    var temPoint =
        _getBaseCenterLengthAnglePoint(_centerR + bgSet.extensionRadius, angle);
    var tempOffset = Offset(0, 0);
    var sinAngle = sin(angle), cosAngle = cos(angle);
    //double的精度处理问题，这里给一定的伸缩范围
    if ((sinAngle * 100000000).floor() == 0) {
      if (cosAngle > 0) {
        //顶角
        tempOffset = Offset(
            temPoint.x - titleTp.size.width / 2 - cellStyle.padding.left,
            temPoint.y - titleTp.size.height - cellStyle.padding.vertical);
      } else {
        //底角
        tempOffset = Offset(
            temPoint.x - titleTp.size.width / 2 - cellStyle.padding.left,
            temPoint.y.toDouble());
      }
    } else if (sinAngle > 0) {
      //右侧
      tempOffset = Offset(
          temPoint.x.toDouble(),
          temPoint.y -
              titleTp.size.height / 2 -
              cellStyle.padding.vertical / 2);
    } else {
      //左侧
      tempOffset = Offset(
          temPoint.x - titleTp.size.width - cellStyle.padding.horizontal,
          temPoint.y -
              titleTp.size.height / 2 -
              cellStyle.padding.vertical / 2);
    }
    var subTitleTp = TextPainter(
        textAlign: TextAlign.center,
        ellipsis: '.',
        maxLines: 1,
        text: subText != null
            ? TextSpan(
                children: subText
                    .map((e) => TextSpan(
                        text: e.title,
                        style: isSelect ? e.selectStyle : e.titleStyle))
                    .toList(),
              )
            : TextSpan(
                style: defaultTextStyle.copyWith(fontSize: 0),
              ),
        textDirection: TextDirection.ltr)
      ..layout();
    var space = cosAngle > 0
        ? -(cellStyle.tipSpace + subTitleTp.size.height)
        : (titleTp.size.height + cellStyle.tipSpace);
    var addHeight = subTitleTp.size.height + cellStyle.tipSpace;
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..color = cellStyle.backgroundColor
      ..style = PaintingStyle.fill;
    var rrect = RRect.fromLTRBR(
        tempOffset.dx + cellStyle.offset.dx,
        tempOffset.dy - (cosAngle > 0 ? addHeight : 0) + cellStyle.offset.dy,
        tempOffset.dx +
            titleTp.width +
            cellStyle.padding.horizontal +
            cellStyle.offset.dx,
        tempOffset.dy +
            titleTp.height +
            cellStyle.padding.vertical +
            (cosAngle > 0 ? 0 : addHeight) +
            cellStyle.offset.dy,
        Radius.circular(cellStyle.borderRadius ??
            (titleTp.height + cellStyle.padding.vertical)));
    _cellModel?.add(DimensionabilityTouchBackModel(
        point: Offset(rrect.center.dx - rrect.width / 2,
            rrect.center.dy - rrect.height / 2),
        size: Size(rrect.width, rrect.height),
        index: index,
        param: param));
    canvas.drawRRect(rrect, paint);
    paint
      ..strokeWidth = cellStyle.borderWidth
      ..color = cellStyle.borderColor
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(rrect, paint);
    titleTp.paint(
        canvas,
        Offset(tempOffset.dx + cellStyle.padding.left,
                tempOffset.dy + cellStyle.padding.top) +
            cellStyle.offset);
    subTitleTp.paint(
        canvas,
        Offset(
                tempOffset.dx +
                    cellStyle.padding.left +
                    titleTp.size.width / 2 -
                    subTitleTp.width / 2,
                tempOffset.dy + cellStyle.padding.top + space) +
            cellStyle.offset);
  }

//绘制内部阴影区域
  void _createPaintShadowPath(Canvas canvas, Size size) {
    var begainDy = divisionConst;
    for (var i = 0; i < dimensionalityTags.length; i++) {
      var tempBean = dimensionalityTags[i];
      var shadowPath = Path();
      var pointArr = <DimensionCellContentModel>[];
      for (var j = 0; j < dimensionalityDivisions.length; j++) {
        var length = 0.0;
        var cellModel = tempBean.tagContents[j];
        if (j < tempBean.tagContents.length) {
          length = _centerR * cellModel.value;
        }
        var point = _getBaseCenterLengthAnglePoint(length, _averageAngle * j);
        pointArr.add(DimensionCellContentModel(point: point, model: cellModel));
        if (j == 0) {
          shadowPath.moveTo(point.x.toDouble(), point.y.toDouble());
        } else {
          shadowPath..lineTo(point.x.toDouble(), point.y.toDouble());
        }
      }
      shadowPath
        ..lineTo(
            pointArr.first.point.x.toDouble(), pointArr.first.point.y.toDouble())
        ..close();
      var shadowPaint = Paint()
        ..strokeWidth = 1
        ..color = tempBean.fillColor
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
      canvas.drawPath(shadowPath, shadowPaint);
      //绘制右上角标记(小弧边矩形+文字tag)
      var tp = TextPainter(
          textAlign: TextAlign.center,
          ellipsis: '.',
          maxLines: 1,
          text: TextSpan(
            text: tempBean.tagTitle,
            style: tempBean.tagTitleStyle,
          ),
          textDirection: TextDirection.ltr)
        ..layout(minWidth: 0, maxWidth: size.width);
      _drawDimensionText(canvas, size, tp, begainDy, tempBean, shadowPaint);
      begainDy += (tp.height + 7);

      //绘制线条
      var linePaint = Paint()
        ..strokeWidth = tempBean.lineWidth
        ..color = tempBean.lineColor
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true;
      canvas.drawPath(
          tempBean.isHintLineImaginary
              ? dashPath(
                  shadowPath,
                  dashArray: CircularIntervalList<double>(<double>[5.0, 4.0]),
                )
              : shadowPath,
          linePaint);

      //绘制纬度点
      pointArr.forEach((element) {
        PainterTool.drawSpecialPoint(
            canvas,
            PointModel(
                offset: Offset(
                    element.point.x.toDouble(), element.point.y.toDouble()),
                cellPointSet: CellPointSet(
                    pointType: element.model.pointType,
                    pointSize: element.model.pointSize,
                    pointRadius: element.model.pointRadius,
                    pointShaderColors: element.model.pointShaderColors,
                    placehoderImage: element.model.placehoderImage,
                    placeImageSize: element.model.placeImageSize)),
            Offset.zero);
      });
    }
  }

  void _drawDimensionText(Canvas canvas, Size size, TextPainter tp,
      double begainDy, DimensionalityBean tempBean, Paint shadowPaint) {
    tp.paint(canvas,
        Offset(size.width - tp.width - baseBean.basePadding.right, begainDy));
    //绘制标记小椭圆
    var rightBegainCenterX =
        size.width - tp.width - baseBean.basePadding.right - 5;
    var height = tempBean.tagTipHeight ?? 15;
    var width = tempBean.tagTipWidth ?? 5;
    var tipPath = Path()
      ..moveTo(rightBegainCenterX, begainDy + tp.height / 2 - height / 2)
      ..addArc(
          Rect.fromCircle(
              center: Offset(rightBegainCenterX, begainDy + tp.height / 2),
              radius: height / 2),
          -pi / 2,
          pi)
      ..lineTo(
          rightBegainCenterX - width, begainDy + tp.height / 2 + height / 2)
      ..addArc(
          Rect.fromCircle(
              center:
                  Offset(rightBegainCenterX - width, begainDy + tp.height / 2),
              radius: height / 2),
          pi / 2,
          pi)
      ..lineTo(rightBegainCenterX, begainDy + tp.height / 2 - height / 2)
      ..close();
    canvas.drawPath(tipPath, shadowPaint);
  }

  //外部拖拽获取触摸点最近的点位, 点击坐标轴以外区域直接返回空offset，和取消一样的效果
  DimensionabilityTouchBackModel? getNearbyPoint(
    Offset localPosition,
  ) {
    if (_cellModel == null || _cellModel!.isEmpty) {
      return null;
    }
    DimensionabilityTouchBackModel? touchModel;
    for (var i = 0; i < _cellModel!.length; i++) {
      var tempModel = _cellModel![i];
      if (localPosition.dx >= tempModel.point.dx &&
          localPosition.dx <= (tempModel.point.dx + tempModel.size.width) &&
          localPosition.dy >= tempModel.point.dy &&
          localPosition.dy <= (tempModel.point.dy + tempModel.size.height)) {
        touchModel = tempModel;
        break;
      }
    }
    return touchModel;
  }

  DimensionabilityTouchBackModel? getNearbyIndex(int index) {
    if (_cellModel == null || _cellModel!.isEmpty) {
      return null;
    }
    DimensionabilityTouchBackModel? touchModel;
    index = index.clamp(0, _cellModel!.length - 1);
    touchModel = _cellModel![index];
    return touchModel;
  }
}
