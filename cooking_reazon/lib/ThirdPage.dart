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
