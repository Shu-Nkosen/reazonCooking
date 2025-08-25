import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Todo App', home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _userAccelerometerValues = "";
  String _gyroscopeValues = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Demo Home Page")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            _userAccelerometerValues,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(_gyroscopeValues, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _userAccelerometerValues =
            "加速度センサー\n${event.x}\n${event.y}\n${event.z}";
      });
    });
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = "ジャイロセンサー\n${event.x}\n${event.y}\n${event.z}";
      });
    });
  }
}
