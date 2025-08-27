import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'ThirdPage.dart';

class NextPage extends StatefulWidget {
  const NextPage({super.key});

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  int _userCutCount = 0;
  int _userCutState = 1;
  String _userAccelerometerValues = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Demo Home Page")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(_userCutCount.toString()),
          Text(
            _userAccelerometerValues,
            style: Theme.of(context).textTheme.titleLarge,
          ),

        Center(
          child:ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ThirdPage()),
            );
          },
          child: const Text('3枚目へ'),
        ),
        ),
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
        if (event.x * _userCutState < -10) {
          _userCutCount += 1;
        }
        _userCutState *= -1;
      });
    });
  }
}
