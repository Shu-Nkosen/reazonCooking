// main.dart

import 'package:flutter/material.dart';
import 'SecondPage.dart';
import 'ThirdPage.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bistro Reazon',
      initialRoute: '/', // アプリ起動時の最初のルート
      routes: {
        '/': (context) => const MyHomePage(),
        '/second': (context) => const NextPage(),
        '/third': (context) => const ThirdPage(curryVegetables: []),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ビストロ・レアゾン",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 245, 211, 90),
      ),
      body: Stack(
        children: [
          // 1. 背景画像として表示するコンテナ
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              image: const DecorationImage(
                image: AssetImage('images/back2.png'),
                fit: BoxFit.cover,
                alignment: Alignment(1.0, 1.0),
              ),
            ),
          ),

          // 2. その上に重ねるコンテンツ（ボタンなど）
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 隙間
                  const SizedBox(height: 200),

                  // Start! ボタン
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NextPage(),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Text(
                          'Start!',
                          style: TextStyle(
                            fontSize: 100,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 10
                              ..color = Color.fromARGB(255, 184, 124, 3),
                          ),
                        ),
                        Text(
                          'Start!',
                          style: TextStyle(
                            fontSize: 100,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 隙間
                  const SizedBox(height: 100),

                  // 作り方
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.only(top: 30, bottom: 30),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 246, 231, 176),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          offset: Offset(-10, -10),
                          color: Color.fromARGB(59, 117, 87, 11),
                        ),
                        BoxShadow(
                          blurRadius: 10,
                          offset: Offset(10, 10),
                          color: Color.fromARGB(255, 113, 63, 12),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          const SizedBox(height: 2, width: 100),
                          Text(
                            'カレーの作り方',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 24,
                              color: const Color.fromARGB(255, 134, 92, 1),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '1.スマホを振って具材を切ります。\n2.具材はジャガイモ・人参・玉葱・牛肉です。\n3.具材を切る制限時間は１種類30秒です。\n4.切り具合でスコアが決まります。\n5.100点のカレーを目指して頑張ろう！',
                            style: TextStyle(
                              fontSize: 15,
                              color: const Color.fromARGB(255, 32, 32, 32),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
