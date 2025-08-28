// ThirdPage.dart

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ThirdPage extends StatefulWidget {
  final List<int> curryVegetables;

  const ThirdPage({super.key, required this.curryVegetables});

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  String _userAccelerometerValues = "";
  String _gyroscopeValues = "";
  bool _result=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Demo Home Page")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[Text(
              widget.curryVegetables.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          Text(
            _userAccelerometerValues,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(_gyroscopeValues, style: Theme.of(context).textTheme.titleLarge),

          // ElevatedButton(
          //     onPressed: toresult(),
          // ),

      // if (_result)
      // // 半透明の暗幕
      // ModalBarrier(
      //   // ignore: deprecated_member_use
      //   color: Colors.black.withOpacity(0.5), // 黒色で透明度50%
      //   dismissible: false, // タップで閉じないようにする
      // ),
    // 3. リザルト画面
      // if (_result)
      // Center(
      //   child: ResultScreen(),
      // ),
        ],
      ),
    );
  }

  void toresult(){
    setState((){
      _result=true;
    });
  }

}
