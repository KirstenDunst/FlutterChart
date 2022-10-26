/*
 * @Author: Cao Shixin
 * @Date: 2021-09-23 14:06:44
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2021-10-15 16:08:39
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class PercentIndicatorLine extends StatefulWidget {
  static const String routeName = '/percent_indicator_line';
  static const String title = '线条进度指示器';

  @override
  _PercentIndicatorLineState createState() => _PercentIndicatorLineState();
}

class _PercentIndicatorLineState extends State<PercentIndicatorLine> {
  String stateLine = 'line Animation start';
  bool isRunning = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Percent Indicators Line'),
        actions: [
          IconButton(
              icon: Icon(Icons.stop),
              onPressed: () {
                setState(() {
                  isRunning = false;
                });
              })
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15.0),
            child: LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 50,
              animationSet: AnimationSet(
                animationDuration: 3000,
                animateFromLastPercent:true,
                widgetIndicator: RotatedBox(
                  quarterTurns: 1,
                  child: Icon(Icons.airplanemode_active, size: 50),
                ),
              ),
              percentModel: PercentModel(
                percent: isRunning ? 0.5 : 0.2,
              ),
              lineHeight: 20.0,
              centerSet: CenterSet(center: Text('50.0%')),
              strokeCap: StrokeCap.butt,
              progressGradient: ColorGradientModel(color: Colors.red),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 50,
              lineHeight: 20.0,
              animationSet: AnimationSet(
                animationDuration: 3000,
                animateFromLastPercent: true,
              ),
              percentModel: PercentModel(
                percent: 0.5,
              ),
              centerSet: CenterSet(center: Text('50.0%')),
              strokeCap: StrokeCap.butt,
              progressGradient: ColorGradientModel(
                linearGradient: LinearGradient(
                  colors: <Color>[Color(0xffB07BE6), Color(0xff5BA2E0)],
                ),
              ),
              // clipLinearGradient: true,
              backgroundGradient: ColorGradientModel(
                linearGradient: LinearGradient(
                  colors: <Color>[Color(0xffe5d6fa), Color(0xffc8dff8)],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: FittedBox(
              child: LinearPercentIndicator(
                width: 140.0,
                lineHeight: 14.0,
                percentModel: PercentModel(
                  percent: 0.7,
                  fillColor: Colors.green,
                ),
                centerSet: CenterSet(
                    center: Text(
                  '70.0%',
                  style: TextStyle(fontSize: 12.0),
                )),
                strokeCap: StrokeCap.square,
                backgroundGradient: ColorGradientModel(color: Colors.orange),
                progressGradient: ColorGradientModel(
                  linearGradient: LinearGradient(
                    colors: [Colors.red, Colors.blue],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: FittedBox(
              child: LinearPercentIndicator(
                width: 140.0,
                lineHeight: 14.0,
                percentModel: PercentModel(
                  fillColor: Colors.green,
                  percent: 0.5,
                ),
                centerSet: CenterSet(
                    center: Text(
                  '50.0%',
                  style: TextStyle(fontSize: 12.0),
                )),
                strokeCap: StrokeCap.square,
                backgroundGradient: ColorGradientModel(color: Colors.orange),
                progressGradient: ColorGradientModel(color: Colors.blue),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: LinearPercentIndicator(
              animationSet: AnimationSet(
                animationDuration: 500,
              ),
              lineHeight: 20.0,
              percentModel: PercentModel(
                percent: 0.2,
              ),
              centerSet: CenterSet(center: Text('20.0%')),
              strokeCap: StrokeCap.butt,
              progressGradient: ColorGradientModel(color: Colors.red),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 50,
              animationSet: AnimationSet(
                animationDuration: 2000,
                animateFromLastPercent: true,
                curve: Curves.easeIn,
              ),
              percentModel: PercentModel(
                percent: 0.9,
              ),
              lineHeight: 20.0,
              centerSet: CenterSet(center: Text('90.0%')),
              strokeCap: StrokeCap.square,
              progressGradient: ColorGradientModel(color: Colors.greenAccent),
              maskFilter: MaskFilter.blur(BlurStyle.solid, 3),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 50,
              animationSet: AnimationSet(
                animationDuration: 2500,
              ),
              lineHeight: 20.0,
              percentModel: PercentModel(
                percent: 0.8,
              ),
              centerSet: CenterSet(center: Text('80.0%')),
              strokeCap: StrokeCap.square,
              progressGradient: ColorGradientModel(color: Colors.green),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: LinearPercentIndicator(
              animationSet: AnimationSet(
                animationDuration: 2500,
              ),
              lineHeight: 20.0,
              percentModel: PercentModel(
                percent: 0.55,
              ),
              centerSet: CenterSet(center: Text('55.0%')),
              strokeCap: StrokeCap.square,
              progressGradient: ColorGradientModel(color: Colors.green),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                LinearPercentIndicator(
                  width: 100.0,
                  lineHeight: 8.0,
                  percentModel: PercentModel(
                    percent: 0.2,
                  ),
                  progressGradient: ColorGradientModel(color: Colors.red),
                ),
                SizedBox(
                  height: 10,
                ),
                LinearPercentIndicator(
                  width: 100.0,
                  lineHeight: 8.0,
                  percentModel: PercentModel(
                    percent: 0.5,
                  ),
                  progressGradient: ColorGradientModel(color: Colors.orange),
                ),
                SizedBox(
                  height: 10,
                ),
                LinearPercentIndicator(
                  width: 100.0,
                  lineHeight: 8.0,
                  percentModel: PercentModel(
                    percent: 0.9,
                  ),
                  progressGradient: ColorGradientModel(color: Colors.blue),
                ),
                SizedBox(
                  height: 10,
                ),
                LinearPercentIndicator(
                  width: 100.0,
                  lineHeight: 8.0,
                  percentModel: PercentModel(
                    percent: 1.0,
                  ),
                  progressGradient:
                      ColorGradientModel(color: Colors.lightBlueAccent),
                  animationSet: AnimationSet(
                    animationDuration: 500,
                    restartAnimation: true,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: LinearPercentIndicator(
              lineHeight: 20,
              centerSet: CenterSet(center: Text('50%')),
              progressGradient: ColorGradientModel(color: Colors.blueAccent),
              percentModel: PercentModel(
                percent: .5,
              ),
              animationSet: AnimationSet(
                animationDuration: 5000,
                onAnimationEnd: () =>
                    setState(() => stateLine = 'End Animation at 50%'),
              ),
            ),
          ),
          Text(stateLine),
          Padding(
            padding: EdgeInsets.all(15),
            child: LinearPercentIndicator(
              lineHeight: 20,
              centerSet: CenterSet(
                  centerText: '进度显示: 50%', centerTextStyle: defaultTextStyle.copyWith(fontSize: 20)),
              progressGradient: ColorGradientModel(color: Colors.blueAccent),
              percentModel: PercentModel(
                percent: .5,
              ),
              animationSet: AnimationSet(
                animationDuration: 5000,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
