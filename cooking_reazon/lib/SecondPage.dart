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
  int _userCutCount = 0;
  int _userCutState = 1;
  int _currentVegetable = 0;
  List<int> curryVegetables = [0, 0, 0, 0];
  Map<int, String> vegetableImages = {0: 'C', 1: 'P', 2: 'O', 3: 'M'};

  OverlayEntry? _overlayEntry;

  late AudioPlayer _audioPlayer;

  int _remainingSeconds = 20; // 残り秒数を保持する状態変数を追加

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
                          _handleNextVegetable(); // 共通のメソッドを呼び出す
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
                    'ホームに戻る',
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

    _remainingSeconds = 10; // 秒数をリセット

    if (this.mounted && _currentVegetable < 3) {
      // 20秒後に実行するタイマー
      _timer = Timer(const Duration(seconds: 20), () {
        _handleNextVegetable();
      });

      // 1秒ごとにカウントダウンを更新するタイマー
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (_remainingSeconds > 0) {
          setState(() {
            _remainingSeconds--;
          });
          // 0秒になったときにバイブレーションをトリガー
          if (_remainingSeconds == 0) {
             if (await Vibration.hasVibrator()) { // バイブレーション機能の有無をチェック
                Vibration.vibrate(duration: 500); // 500msのバイブレーションを実行
             }
          }
        } else {
          timer.cancel();
        }
      });
    }
  }

  void _handleNextVegetable() {
    if (_currentVegetable >= 3) { // 最後の野菜の場合は何もしない
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
    _timer.cancel();
    _countdownTimer.cancel(); // カウントダウンタイマーもキャンセル
    super.dispose();
  }
}