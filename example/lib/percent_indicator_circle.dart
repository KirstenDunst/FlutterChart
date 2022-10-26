/*
 * @Author: Cao Shixin
 * @Date: 2021-09-23 14:06:44
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2021-10-15 14:48:00
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class PercentIndicatorCircle extends StatefulWidget {
  static const String routeName = '/percent_indicator_circle';
  static const String title = '圆圈进度指示器';

  @override
  _PercentIndicatorCircleState createState() => _PercentIndicatorCircleState();
}

class _PercentIndicatorCircleState extends State<PercentIndicatorCircle> {
  String stateCircle = 'circle Animation start';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Percent Indicators Circle'),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10),
          children: <Widget>[
            CircularPercentIndicator(
              size: 120.0,
              progressModel: LineModel(
                width: 13.0,
                color: Colors.purple,
              ),
              percentModel: PercentModel(
                percent: 0.7,
              ),
              animationSet: AnimationSet(
                animationDuration: 3000,
                animateFromLastPercent: true,
                widgetIndicator: RotatedBox(
                  quarterTurns: 1,
                  child: Icon(Icons.airplanemode_active, size: 30),
                ),
              ),
              center: Text(
                '70.0%',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              strokeCap: StrokeCap.round,
            ),
            CircularPercentIndicator(
              size: 100.0,
              percentModel: PercentModel(
                percent: 0.5,
              ),
              progressModel: LineModel(width: 10.0),
              backgroundModel: LineModel(
                color: Colors.grey,
              ),
              center: Text('50%'),
              strokeCap: StrokeCap.round,
              maskFilter: MaskFilter.blur(BlurStyle.solid, 3),
              linearGradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.orange, Colors.yellow],
              ),
              rotateLinearGradient: true,
            ),
            CircularPercentIndicator(
              size: 100.0,
              percentModel: PercentModel(
                percent: 1,
              ),
              progressModel: LineModel(width: 10.0),
              backgroundModel: LineModel(
                color: Colors.grey,
              ),
              strokeCap: StrokeCap.round,
              animationSet: AnimationSet(
                animationDuration: 3000,
                animateFromLastPercent: true,
              ),
              center: Text('100%'),
              linearGradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.orange, Colors.yellow],
              ),
              rotateLinearGradient: true,
            ),
            CircularPercentIndicator(
              size: 100.0,
              percentModel: PercentModel(
                percent: 0.8,
              ),
              progressModel: LineModel(
                width: 10.0,
                color: Colors.blue,
              ),
              backgroundModel: LineModel(
                color: Colors.grey,
              ),
              center: Icon(
                Icons.person_pin,
                size: 50.0,
                color: Colors.blue,
              ),
              animationSet: AnimationSet(animationDuration: 500),
              reverse: true,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              CircularPercentIndicator(
                size: 100.0,
                percentModel: PercentModel(
                  percent: 0.5,
                ),
                animationSet: AnimationSet(
                  animationDuration: 2000,
                ),
                progressModel: LineModel(
                  width: 10.0,
                  color: Colors.red,
                ),
                backgroundModel: LineModel(
                  color: Colors.orange,
                ),
                arcType: ArcType.HALF,
                center: Text(
                  '40 hours',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
                strokeCap: StrokeCap.butt,
              ),
              CircularPercentIndicator(
                size: 120.0,
                percentModel: PercentModel(
                  percent: 0.5,
                ),
                animationSet: AnimationSet(
                  animationDuration: 2000,
                ),
                progressModel: LineModel(width: 10.0, color: Colors.red),
                backgroundModel: LineModel(color: Colors.yellow),
                reverse: true,
                center: Text(
                  '20 hours',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
                strokeCap: StrokeCap.butt,
              ),
            ]),
            CircularPercentIndicator(
              size: 100.0,
              percentModel: PercentModel(percent: 0.5),
              animationSet: AnimationSet(
                animationDuration: 2000,
              ),
              progressModel: LineModel(width: 10.0, color: Colors.red),
              backgroundModel: LineModel(color: Colors.grey),
              startAngle: 90,
              center: Text(
                'Start angle 90',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
              ),
              strokeCap: StrokeCap.butt,
            ),
            CircularPercentIndicator(
              size: 120.0,
              percentModel: PercentModel(percent: 0.7),
              progressModel: LineModel(width: 13.0, color: Colors.purple),
              animationSet: AnimationSet(
                animationDuration: 3000,
                animateFromLastPercent: true,
              ),
              center: Text(
                '70.0%',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              strokeCap: StrokeCap.round,
            ),
            Container(
              padding: EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularPercentIndicator(
                      size: 45.0,
                      percentModel: PercentModel(percent: 0.10),
                      progressModel: LineModel(width: 4.0, color: Colors.red),
                      center: Text('10%'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                    ),
                    CircularPercentIndicator(
                      size: 45.0,
                      percentModel: PercentModel(percent: 0.2),
                      progressModel:
                          LineModel(width: 4.0, color: Colors.orangeAccent),
                      backgroundModel: LineModel(width: 1.0),
                      animationSet: AnimationSet(animationDuration: 500),
                      center: Text('20%'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                    ),
                    CircularPercentIndicator(
                      size: 45.0,
                      percentModel: PercentModel(percent: 0.30),
                      progressModel:
                          LineModel(width: 4.0, color: Colors.orange),
                      center: Text('30%'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                    ),
                    CircularPercentIndicator(
                      size: 45.0,
                      percentModel: PercentModel(percent: 0.60),
                      animationSet: AnimationSet(animationDuration: 200),
                      progressModel:
                          LineModel(color: Colors.yellow, width: 4.0),
                      backgroundModel: LineModel(width: 8),
                      center: Text('60%'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                    ),
                    CircularPercentIndicator(
                      size: 45.0,
                      percentModel: PercentModel(percent: 0.90),
                      progressModel: LineModel(width: 4.0, color: Colors.green),
                      center: Text('90%'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                    ),
                    CircularPercentIndicator(
                      size: 45.0,
                      percentModel: PercentModel(percent: 1.0),
                      animationSet: AnimationSet(
                        animationDuration: 500,
                        restartAnimation: true,
                      ),
                      progressModel:
                          LineModel(width: 4.0, color: Colors.redAccent),
                      center: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CircularPercentIndicator(
              size: 80.0,
              percentModel: PercentModel(percent: .5),
              animationSet: AnimationSet(
                animationDuration: 2500,
                animateFromLastPercent: true,
                onAnimationEnd: () =>
                    setState(() => stateCircle = 'End Animation at 50%'),
              ),
              progressModel: LineModel(width: 5.0, color: Colors.blueAccent),
              center: Text(
                '50.0%',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              strokeCap: StrokeCap.round,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(stateCircle),
              ],
            ),
            SizedBox(height: 20),
            CircularPercentIndicator(
              size: 80.0,
              percentModel: PercentModel(
                percent: .7,
                fillColor: Colors.transparent,
              ),
              progressModel: LineModel(width: 10),
              backgroundModel: LineModel(width: 15, color: Colors.green),
              strokeCap: StrokeCap.round,
              arcType: ArcType.HALF,
            ),
          ],
        ),
      ),
    );
  }
}
