<!--
 * @Author: Cao Shixin
 * @Date: 2020-07-07 10:38:30
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-12-29 10:46:11
 * @Description: version log
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
-->
## 0.0.3 202001229
* To improve scores

## 0.0.2 202001222
* chart_line_focus
    * Fixed a problem with Y-axis subheadings not centered in reverse order

## 0.0.1 20200917
* chart_line_focus
    * The curve is smoother
    * Solve the problem of dividing lines between columns of concentration
    * Compatible with multiple drawing modes of the same type
    * Add avatar support for the most recently drawn point (missing a centerPoint, widget type, customizable incoming)
    * Fix focuses on table drawing callbacks

* chart_dimensionality
    * Dimensions need to be greater than or equal to 3 to be usable
    * ChartDimensionality

* chart_line
    * Adjust the calculation mode of coordinate axes
    * Add point position magnification
    * Add custom capture site function  

* chart_bar
    * rectangular roof
    * Curved transition Angle flat roof
    * arc roof
    
* chart_pie
    * Add pie chart add instruction label to explain UI


* example:
    * chart_line_focus: **FocusChartLinePage**
    * Columnar top semicircle: **ChartBarCirclePage**
    * Customize the arc Angle at the top of the bar chart: **ChartBarRoundPage**
    * Smooth curve with fill color: **ChartCurvePage**
    * Polyline with fill color: **ChartLinePage**
    * Double broken line: **DoubleChartlinePage**
    * The pie chart: **ChartPiePage**
    * The dimension figure: **ChartDimensionalityView**
    * Drag the stock curve： **StepCurveLine**
    * Highlight custom auxilaries around a point：**FocusChartSpecialPointPage**



