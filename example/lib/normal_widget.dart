/*
 * @Author: Cao Shixin
 * @Date: 2023-03-28 11:20:41
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2023-03-28 15:11:53
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_chart_csx/flutter_chart_csx.dart';

class NormalWidget extends StatefulWidget {
  static const String routeName = '/normal_widget';
  static const String title = '常用小组件展示';

  const NormalWidget({super.key});

  @override
  State<NormalWidget> createState() => _NormalwidgetState();
}

class _NormalwidgetState extends State<NormalWidget> {
  bool _checked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(NormalWidget.title),
      ),
      body: Column(
        children: [
          const Text('CustomCheckbox show:'),
          CustomCheckbox(
            value: _checked,
            onChanged: _onChange,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              width: 16,
              height: 16,
              child: CustomCheckbox(
                strokeWidth: 1,
                radius: 1,
                value: _checked,
                onChanged: _onChange,
              ),
            ),
          ),
          SizedBox(
            width: 30,
            height: 30,
            child: CustomCheckbox(
              strokeWidth: 3,
              strokeColor: Colors.orange,
              normalBorderColor: Colors.cyan,
              fillColor: Colors.red,
              radius: 3,
              value: _checked,
              onChanged: _onChange,
            ),
          ),
          const Text('DoneWidget show:'),
          DoneWidget(
            value: _checked,
            onChanged: _onChange,
          ),
          DoneWidget(
            outline: true,
            value: _checked,
            onChanged: _onChange,
          ),
          DoneWidget(
            outline: true,
            value: _checked,
            color: Colors.orange,
            normalBorderColor: Colors.cyan,
            onChanged: _onChange,
          ),
        ],
      ),
    );
  }

  void _onChange(value) {
    setState(() => _checked = value);
  }
}
