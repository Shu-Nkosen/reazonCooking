// secondPage.dart

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'NiruPage.dart';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class NextPage extends StatefulWidget {
  const NextPage({super.key});

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  // StreamSubscriptionのインスタンスを保持する変数
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  int _userCutCount = 0;
  int _userCutState = 1;
  int _currentVegetable = 0;
  List<int> curryVegetables = [0, 0, 0, 0];
  Map<int, String> vegetableImages = {0: 'C', 1: 'P', 2: 'O', 3: 'M'};

  OverlayEntry? _overlayEntry;

  late AudioPlayer _audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ビストロ・レアゾン",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Color.fromARGB(255, 251, 250, 250),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 86, 20, 40),
      ),
      body: Container(
        color: Color.fromARGB(133, 209, 209, 206),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "振ってカット！！",
              style: TextStyle(
                fontSize: 30, // ここに好きなサイズを数値で指定
              ),
            ),
            if (_userCutCount < 30)
              Image.asset(
                'images/${((_userCutCount / 5) + 1).toInt()}${vegetableImages[_currentVegetable]}.png',
              ),
            Text(
              "${_userCutCount.toString()}回！",
              style: TextStyle(
                fontSize: 30, // ここに好きなサイズを数値で指定
              ),
            ),
            Center(
              child: _currentVegetable == 3
                  ? SizedBox(
                      width: 250, // ボタンの幅を指定
                      height: 80,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            curryVegetables[_currentVegetable] = _userCutCount;
                          });
                          // ここでオーバレイを削除
                          _overlayEntry?.remove();
                          _overlayEntry = null;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NiruPage(
                                // ここでcurryVegetablesリストを渡す
                                curryVegetables: curryVegetables,
                              ),
                            ),
                          );
                        },
                        child: Center(
                          child: const Text(
                            '煮る！',
                            style: TextStyle(
                              fontSize: 25,
                              color: Color.fromARGB(255, 75, 196, 91),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 250, // ボタンの幅を指定
                      height: 80,
                      child: ElevatedButton(
                        onPressed: () {
                          // ここでオーバレイを削除
                          _overlayEntry?.remove();
                          _overlayEntry = null;
                          setState(() {
                            curryVegetables[_currentVegetable] = _userCutCount;
                            _currentVegetable += 1;
                            _userCutCount = 0;
                          });
                        },
                        child: Center(
                          child: const Text(
                            '次の野菜へ！',
                            style: TextStyle(
                              fontSize: 25,
                              color: Color.fromARGB(255, 75, 196, 91),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
            // 戻るボタン
            SizedBox(
              width: 250, // ボタンの幅を指定
              height: 80,
              child: ElevatedButton(
                onPressed: () {
                  _overlayEntry?.remove();
                  _overlayEntry = null;
                  Navigator.pop(context);
                },
                child: Center(
                  child: const Text(
                    '戻る',
                    style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 75, 196, 91),
                    ),
                  ),
                ),
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
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();
    _audioPlayer.setPlayerMode(PlayerMode.lowLatency);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showKnifeOverlay();
    });

    // リスナーを_accelerometerSubscriptionに格納
    _accelerometerSubscription = userAccelerometerEvents.listen((
      UserAccelerometerEvent event,
    ) {
      if (mounted) {
        setState(() {
          if (event.x * _userCutState < -10) {
            _userCutCount += 1;
            _playCutSound();
          }
          _userCutState *= -1;
        });
      }
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
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 250,
        right: -50,
        child: Transform.rotate(
          angle: 20 * math.pi / 180,
          child: Image.asset('images/knife.png', width: 300, height: 300),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;
    _audioPlayer.dispose();
    super.dispose();
  }
}
