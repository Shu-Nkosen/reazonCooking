import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'ThirdPage.dart';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';

class NextPage extends StatefulWidget {
  const NextPage({super.key});

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  int _userCutCount = 0;
  int _userCutState = 1;

  OverlayEntry? _overlayEntry;

  late AudioPlayer _audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Demo Home Page")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("振ってカット！！", style: Theme.of(context).textTheme.titleLarge),
          if (_userCutCount < 30)
            Image.asset('images/${((_userCutCount / 5) + 1).toInt()}C.png'),
          Text(
            "${_userCutCount.toString()}回！",
            style: Theme.of(context).textTheme.titleLarge,
          ),

          // Text(
          //   _userAccelerometerValues,
          //   style: Theme.of(context).textTheme.titleLarge,
          // ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ThirdPage()),
                );
              },
              child: Column(children: [const Text('3枚目へ')]),
            ),
          ),
          ElevatedButton(
            onPressed: _playCutSound, // ボタンを押したら音声再生メソッドを呼び出す
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange, // ボタンの色をオレンジに
            ),
            child: const Text('【デバッグ用】音声再生テスト'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();
    _audioPlayer.setPlayerMode(PlayerMode.lowLatency);
    // This callback runs after the initial frame is built, avoiding the error.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showKnifeOverlay();
    });

    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        if (event.x * _userCutState < -10) {
          _userCutCount += 1;
          _playCutSound();
        }
        _userCutState *= -1;
      });
    });
  }

  void _playCutSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/cut.mp3'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  void _showKnifeOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          bottom: 150,
          right: -50,
          child: Transform.rotate(
            angle: 20 * math.pi / 180,
            child: Image.asset('images/knife.png', width: 300, height: 300),
          ),
        ),
      );

      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _audioPlayer.dispose();
    super.dispose();
  }
}
