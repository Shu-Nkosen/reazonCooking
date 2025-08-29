// secondPage.dart

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'NiruPage.dart';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:vibration/vibration.dart'; // Vibrationパッケージをインポート

class NextPage extends StatefulWidget {
  const NextPage({super.key});

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  // StreamSubscriptionのインスタンスを保持する変数
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  late Timer _timer;
  late Timer _countdownTimer; // 1秒ごとに更新するタイマーを追加
  final int cookTime = 20;
  int _userCutCount = 0;
  int _userCutState = 1;
  int _currentVegetable = 0;
  List<int> curryVegetables = [0, 0, 0, 0];
  Map<int, String> vegetableImages = {0: 'C', 1: 'P', 2: 'O', 3: 'M'};

  OverlayEntry? _overlayEntry;

  late AudioPlayer _cutSoundPlayer;
  late AudioPlayer _bgmPlayer;

  late int _remainingSeconds = cookTime;

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
            Text(
              "残り$_remainingSeconds秒", // 残り秒数を表示するTextウィジェットを追加
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
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
                          _handleNextVegetable();
                          _bgmPlayer.stop();
                          // ここでオーバレイを削除
                          _overlayEntry?.remove();
                          _overlayEntry = null;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NiruPage(
                                // ここでcurryVegetablesリストを渡す
                                curryVegetables:curryVegetables,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Colors.orange[300]!,
                                Colors.orange[500]!,
                                Colors.orange[700]!,
                              ],
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              '煮る！',
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
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
                          _handleNextVegetable(); // 共通のメソッドを呼び出す
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Colors.orange[300]!,
                                Colors.orange[500]!,
                                Colors.orange[700]!,
                              ],
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              '次の野菜へ！',
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
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
                  _bgmPlayer.stop();
                  _overlayEntry?.remove();
                  _overlayEntry = null;
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.orange[300]!,
                        Colors.orange[500]!,
                        Colors.orange[700]!,
                      ],
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'ホームに戻る',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _cutSoundPlayer = AudioPlayer();
    _cutSoundPlayer.setPlayerMode(PlayerMode.lowLatency);

    _bgmPlayer = AudioPlayer();
    _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    _bgmPlayer.setVolume(0.5);
    _bgmPlayer.play(AssetSource('sounds/cookbgm.mp3'));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showKnifeOverlay();
    });

    _timer = Timer(Duration.zero, () {}); // ダミーのタイマーで初期化
    _countdownTimer = Timer(Duration.zero, () {}); // ダミーのタイマーで初期化

    _startTimers(); // タイマーを開始

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

  void _startTimers() {
    // 既存のタイマーがあればキャンセル
    if (_timer.isActive) _timer.cancel();
    if (_countdownTimer.isActive) _countdownTimer.cancel();

    // setStateで秒数をリセットし、UIを即座に更新する
    setState(() {
      _remainingSeconds = cookTime;
    });

    if (this.mounted && _currentVegetable <= 3) {
      _timer = Timer(Duration(seconds: cookTime), () {
        _handleNextVegetable();
      });

      // 1秒ごとにカウントダウンを更新するタイマー
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (
        timer,
      ) async {
        if (_remainingSeconds > 0) {
          setState(() {
            _remainingSeconds--;
          });
          // 1秒になったときにバイブレーションをトリガー
          if (_remainingSeconds == 1) {
            if (await Vibration.hasVibrator()) {
              Vibration.vibrate(duration: 500);
            }
            Future.delayed(const Duration(seconds: 1), () {
              if (_currentVegetable == 3) {
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
              }
            });
          }
        } else {
          timer.cancel();
        }
      });
    }
  }

  void _handleNextVegetable() {
    if (_currentVegetable >= 3) {
      _timer.cancel();
      _countdownTimer.cancel();
      return;
    }
    setState(() {
      curryVegetables[_currentVegetable] = _userCutCount;
      _currentVegetable += 1;
      _userCutCount = 0;
    });
    _startTimers(); // 次の野菜に切り替わったら両方のタイマーをリセット
  }

  void _playCutSound() async {
    try {
      await _cutSoundPlayer.play(AssetSource('sounds/cut.mp3'));
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
    _timer.cancel();
    _countdownTimer.cancel(); // カウントダウンタイマーもキャンセル
    _cutSoundPlayer.dispose();
    _bgmPlayer.dispose();
    super.dispose();
  }
}
