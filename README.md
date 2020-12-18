# flutter_chart

** 图表库集合：<a href="#柱状图">柱状图</a>、<a href="#饼状图">饼状图</a>、<a href="#折线图">折线图</a>、<a href="#多维图">多维图</a>、<a href="#专注力曲线图">专注力曲线图</a>、

# 统一设置
#### BaseBean 作为统一对外暴漏参数定义，适用于所有基础坐标轴的参数设置（不涉及坐标轴的可以不设置，例如：饼状图，多维图）
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

#### xy设置的参数（xy的显示点位的两员大将）
##### y轴
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
      //两个刻度之间的标注文案（y轴在该刻度下面绘制）,不需要的话不设置
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
##### x轴
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
# 单独使用方法（参数解析）
1.柱状图 <a id="柱状图"></a>
![柱状图](https://github.com/KirstenDunst/Resource/blob/main/flutter_chart/bar.png)
![柱状图](https://github.com/KirstenDunst/Resource/blob/main/flutter_chart/bar_1.png)
```flutter
///bar-circle
  Widget _buildChartBarCircle(context) {
    var chartBar = ChartBar(
    //x轴刻度显示，不传则没有，均匀分布x轴
      xDialValues: [
        ChartBarBeanX(
            title: '12-02',
            value: 100,
            titleStyle: TextStyle(color: Colors.white, fontSize: 10),
            gradualColor: [Colors.yellow, Colors.yellow]),
        ChartBarBeanX(
            title: '12-03',
            value: 70,
            titleStyle: TextStyle(color: Colors.red, fontSize: 10),
            gradualColor: [Colors.green, Colors.green])
      ],
      baseBean: BaseBean(
        yDialValues: [
          DialStyleY(
              title: '100',
              titleStyle: TextStyle(color: Colors.lightBlue, fontSize: 10),
              centerSubTitle: 'Calm',
              centerSubTextStyle: TextStyle(color: Colors.red, fontSize: 10),
              positionRetioy: 100 / 100),
          DialStyleY(
              title: '65',
              titleStyle: TextStyle(color: Colors.lightBlue, fontSize: 10),
              centerSubTitle: 'Aware',
              centerSubTextStyle: TextStyle(color: Colors.red, fontSize: 10),
              positionRetioy: 65 / 100),
          DialStyleY(
              title: '35',
              titleStyle: TextStyle(color: Colors.lightBlue, fontSize: 10),
              centerSubTitle: 'Focused',
              centerSubTextStyle: TextStyle(color: Colors.red, fontSize: 10),
              positionRetioy: 35 / 100)
        ],
        yMax: 100.0,
      ),
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.8),
    //柱状图的宽度,如果小的话按照这个显示，如果过于宽，则按照平均宽度减去最小间距5得出的宽度
      rectWidth: 50.0,
      //柱体四周圆角,默认没有圆角
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50), topRight: Radius.circular(50)),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.blue.withOpacity(0.4),
      child: chartBar,
      clipBehavior: Clip.antiAlias,
    );
  }
```
2.饼状图 <a id="饼状图"></a>
![饼状图](https://github.com/KirstenDunst/Resource/blob/main/flutter_chart/pie.png)
```flutter
///pie
  Widget _buildChartPie(context) {
    var chartPie = ChartPie(
      chartBeans: [
        ChartPieBean(
            type: '话费',
            value: 180,
            color: Colors.blueGrey,
            assistTextStyle: TextStyle(fontSize: 12, color: Colors.blueGrey)),
        ChartPieBean(
            type: '零食',
            value: 10,
            color: Colors.deepPurple,
            assistTextStyle: TextStyle(fontSize: 12, color: Colors.deepPurple)),
        ChartPieBean(
            type: '衣服',
            value: 1,
            color: Colors.green,
            assistTextStyle: TextStyle(fontSize: 12, color: Colors.green))
      ],
      //辅助性文案显示的样式
      assistTextShowType: AssistTextShowType.OnlyName,
      //开始画圆的位置（枚举）
      arrowBegainLocation: ArrowBegainLocation.Right,
      backgroundColor: Colors.white,
      assistBGColor: Color(0xFFF6F6F6),
      //辅助性百分比显示的小数位数,（饼状图还是真实的比例）
      decimalDigits: 1,
      //各个占比之间的分割线宽度，默认为0即不显示分割
      divisionWidth: 2,
      size: Size(
          MediaQuery.of(context).size.width, MediaQuery.of(context).size.width),
          // 圆盘的半径，设置太长会按照可承受（除去basebean的basepadding的限制之后）最小的宽或者高的长度的一半
      globalR: MediaQuery.of(context).size.width / 3,
      //中心的圆半径
      centerR: 6,
      centerColor: Colors.white,
      centerWidget: Text(
        '测试中心widget',
        style: TextStyle(color: Colors.black, fontSize: 20),
      ),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      color: Colors.orangeAccent.withOpacity(0.6),
      clipBehavior: Clip.antiAlias,
      borderOnForeground: true,
      child: chartPie,
    );
  }
```

3.折线图<a id="折线图"></a>
![折线图](https://github.com/KirstenDunst/Resource/blob/main/flutter_chart/line.png)
![折线图](https://github.com/KirstenDunst/Resource/blob/main/flutter_chart/line_1.png)
![双折线](https://github.com/KirstenDunst/Resource/blob/main/flutter_chart/double_line.png)
```flutter
class _ChartLineState extends State<ChartLinePage> {
  ChartBeanSystem _chartLineBeanSystem;

  @override
  void initState() {
    _chartLineBeanSystem = ChartBeanSystem(
      //x轴的字体样式
      xTitleStyle: TextStyle(color: Colors.grey, fontSize: 12),
      //是否显示x轴的文字，用来处理多个线条绘制的时候，同一x轴坐标不需要绘制多次，则只需要将多条线中一个标记绘制即可
      isDrawX: true,
      lineWidth: 2,
      //线条点的特殊处理，如果内容不为空，则在点上面会绘制，这个是圆点半径参数
      pointRadius: 0,
        //标记是否为曲线
      isCurve: false,
        //点集合
      chartBeans: [
        ChartLineBean(x: '12-01', y: 30),
        ChartLineBean(x: '12-02', y: 88),
        ChartLineBean(x: '12-03', y: 20),
        ChartLineBean(x: '12-04', y: 67),
        ChartLineBean(x: '12-05', y: 10),
        ChartLineBean(x: '12-06', y: 40),
        ChartLineBean(x: '12-07', y: 10),
      ],
      //Line渐变色，从曲线到x轴从上到下的闭合颜色集
      shaderColors: [
        Colors.blue.withOpacity(0.3),
        Colors.blue.withOpacity(0.1)
      ],
      //曲线或折线的颜色
      lineColor: Colors.red,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ChartLinePage.title),
      ),
      body: _buildChartLine(context),
    );
  }

  ///line
  Widget _buildChartLine(context) {
    var chartLine = ChartLine(
      chartBeanSystems: [_chartLineBeanSystem],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.6),
      baseBean: BaseBean(
        xColor: Colors.black,
        yColor: Colors.white,
        yDialValues: [
          DialStyleY(
            title: '0',
            titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
            positionRetioy: 0 / 100.0,
          ),
          DialStyleY(
            title: '35',
            titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
            positionRetioy: 35 / 100.0,
          ),
          DialStyleY(
            title: '65',
            titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
            positionRetioy: 65 / 100.0,
          ),
          DialStyleY(
            title: '100',
            titleStyle: TextStyle(fontSize: 10.0, color: Colors.black),
            positionRetioy: 100 / 100.0,
          )
        ],
        yMax: 100,
        isShowHintX: true,
        isHintLineImaginary: true,
      ),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.yellow.withOpacity(0.4),
      child: chartLine,
      clipBehavior: Clip.antiAlias,
    );
  }
}
```

4.多维图<a id="多维图"></a>
![多维图](https://github.com/KirstenDunst/Resource/blob/main/flutter_chart/dimensionality.png)
```flutter
Widget _buildWidget(BuildContext context) {
    var chartLine = ChartDimensionality(
    //维度划分的重要参数
      dimensionalityDivisions: [
        ChartBeanDimensionality(
          tip: '选择性专注力',
          tipStyle: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
        ),
        ChartBeanDimensionality(
          tip: '持续性专注力',
          tipStyle: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
        ),
        ChartBeanDimensionality(
          tip: '转换性专注力',
          tipStyle: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
        ),
        ChartBeanDimensionality(
          tip: '分配性专注力',
          tipStyle: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
        ),
        ChartBeanDimensionality(
          tip: '视觉性专注力',
          tipStyle: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
        ),
        ChartBeanDimensionality(
          tip: '玩儿呢',
          tipStyle: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
        )
      ],
     //维度填充数据的重要内容
      dimensionalityTags: [
        DimensionalityBean(
          tagColor: Color(0xFFB1E3AD).withOpacity(0.6),
          tagTitleStyle: TextStyle(color: Color(0xFF666666), fontSize: 16.0),
          tagTitle: '初次评测',
          tagContents: [0.2, 0.4, 0.8, 1.0, 0.1, 0.5],
        ),
        DimensionalityBean(
          tagColor: Color(0xFFF88282).withOpacity(0.6),
          tagTitleStyle: TextStyle(color: Color(0xFF666666), fontSize: 16.0),
          tagTitle: '本次评测',
          tagContents: [0.8, 0.9, 0.8, 1.0, 0.7, 0.9],
        )
      ],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.6),
     //背景网是否为虚线
      isDotted: false,
      //线宽
      lineWidth: 2,
      centerR: 150,
      backgroundColor: Colors.white,
      //线条颜色
      lineColor: Colors.blueAccent,
      //阶层：维度图从中心到最外层有几圈
      dimensionalityNumber: 4,
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.green.withOpacity(0.5),
      child: chartLine,
      clipBehavior: Clip.antiAlias,
    );
  }
```

5.专注力曲线图<a id="专注力曲线图"></a>
![专注力曲线图](https://github.com/KirstenDunst/Resource/blob/main/flutter_chart/focus.png)
![专注力曲线gif](https://github.com/KirstenDunst/Resource/blob/main/flutter_chart/focus.gif)

```flutter
class _FNDoubleLinePageState extends State<FNDoubleLinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FNDoubleLinePage.title),
      ),
      body: ChangeNotifierProvider(
        create: (_) => ChartFocusDoubleLineProvider(),
        child: Consumer<ChartFocusDoubleLineProvider>(
            builder: (context, provider, child) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            semanticContainer: true,
            color: Colors.white,
            child: ChartLineFocus(
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height / 5 * 1.6),
                  //专注力曲线的数组，数组中的每一个元素都是一条线，支持多条曲线绘制
              focusChartBeans: provider.focusChartBeanMains,
              //这里的参数不再赘述，基础设置已介绍完备
              baseBean: BaseBean(
                isShowHintX: true,
                isShowHintY: false,
                hintLineColor: Colors.blue,
                isHintLineImaginary: false,
                isLeftYDialSub: false,
                yMax: 100.0,
                yDialValues: provider.yArr,
              ),
              xMax: 60,
              xDialValues: provider.xArr,
            ),
            clipBehavior: Clip.antiAlias,
          );
        }),
      ),
    );
  }
}

//专注力曲线的每一条线的模型内容
class FocusChartBeanMain {
  //数据显示点集合
  List<ChartBeanFocus> chartBeans;
  //曲线或折线的颜色
  Color lineColor = Colors.lightBlueAccent;
  //曲线或折线的线宽
  double lineWidth = 4;
  //是否是曲线
  bool isCurve = true;
  //是否需要触摸(针对静态图),触摸之后的显示参数在ChartLineFocus里面有设置,目前仅支持一条触摸线显示，多条线的话只显示第一条支持触摸的线的触摸
  bool touchEnable = false;
  //是否显示占位点（每一个值的位置以空心点的形式展示,占位点的颜色目前按照y轴辅助文案的颜色显示）
  bool showSite = false;
  //内部的渐变颜色。不设置的话默认按照解释文案的分层显示，如果设置，即为整体颜色渐变显示
  List<Color> gradualColors;
  //beans的时间轴如果断开，true： 是继续上一个有数值的值绘制，还是 false：断开。按照多条绘制,默认true
  bool isLinkBreak = true;
  //结束回调
  VoidCallback canvasEnd;

  FocusChartBeanMain(
      {this.chartBeans,
      this.lineColor,
      this.lineWidth,
      this.isCurve = true,
      this.touchEnable = false,
      this.showSite = false,
      this.gradualColors,
      this.isLinkBreak,
      this.canvasEnd});
}
```


