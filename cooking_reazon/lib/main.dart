// main.dart

import 'package:flutter/material.dart';
import 'SecondPage.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Bistro Reazon', home: MyHomePage());
  }
}

//1枚目のページ
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
        title: Text("ビストロ・レアゾン", style: TextStyle(fontStyle: FontStyle.italic, color: Color.fromARGB(255, 0, 0, 0))),
        backgroundColor: Color.fromARGB(255, 245, 211, 90),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(

          image: AssetImage('images/back2.png'),
          fit: BoxFit.cover,
          alignment: Alignment(1.0, 1.0),
          )
        ),

        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NextPage()),
              );
            },
            child: const Text(
              'Start!',
              style: TextStyle(fontSize: 100, color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
