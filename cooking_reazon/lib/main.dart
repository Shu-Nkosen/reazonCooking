import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
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
      backgroundColor: const Color.fromARGB(255, 255, 153, 0),
      appBar: AppBar(title: Text("ビストロ・レアゾン",style:TextStyle(fontStyle:FontStyle.italic)),backgroundColor:Color.fromARGB(255, 237, 247, 255)),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
          image: AssetImage('images/back.png'),
          fit: BoxFit.cover,
          //alignment: Alignment.topRight,
          )
        ),

      child:Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NextPage()),
            );
          },
          child: const Text('Start!',style:TextStyle(fontSize:100,color:Colors.red)),
        ),
      ),
      ),
    );
  }
}
