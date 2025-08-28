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
  late int totalScore;
  late final List<int> resultVegetables; // Declare the new variable

    @override
  void initState() {
    super.initState();   
    resultVegetables = widget.curryVegetables.map((int value) => (value ~/ 5) ).toList();
    for (int i = 0; i < resultVegetables.length; i++) {
      if(resultVegetables[i]!=0 || resultVegetables[i]<=5){
      resultVegetables[i] = resultVegetables[i] + 1;
      }
      if(resultVegetables[i]>5){
        resultVegetables[i]=6;
      }
    }
    totalScore = _calculateScore();
  }

  int _calculateScore() {
    int score = 0;
    int count=0;
    for (int value in resultVegetables) {
      count+=1;
      if (count <= 2) {
        if (value == 5) {
          score += 25;
        } else if (value == 4) {
          score += 20;
        } else if (value == 6) {
          score += 15;
        } else if (value == 3) {
          score += 10;
        } else if (value == 2) {
          score += 5;
        } else if (value == 1) {
          score += 1;
        }
        else{
          score+=0;
        }
      } 
     else if(count==3){
     if(value == 6) {
        score += 25;
      } else if (value == 5) {
        score += 20;
      } else if (value == 4) {
        score += 15;
      } else if (value == 3) {
        score += 10;
      } else if (value == 2) {
        score += 5;
      } else if (value == 1) {
        score += 1;
      }
      else {
        score +=0;
      }
     }
     else{
      if(value == 4) {
        score += 25;
      } else if (value == 5) {
        score += 20;
      } else if (value == 3) {
        score += 15;
      } else if (value == 6) {
        score += 10;
      } else if (value == 2) {
        score += 5;
      } else if (value == 1) {
        score += 1;
      }
      else {
        score+=0;
      }
     }
    }
    return score; // Clamp the final score to be between 5 and 100
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Demo Home Page")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
              resultVegetables.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
         Text(
            'Total Score: $totalScore', // Display the total score here
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            _userAccelerometerValues,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(_gyroscopeValues, style: Theme.of(context).textTheme.titleLarge),

          // ElevatedButton(
          //     onPressed: toresult(),
          // ),

      // if (_result)
      // // 半透明の暗幕
      // ModalBarrier(
      //   // ignore: deprecated_member_use
      //   color: Colors.black.withOpacity(0.5), // 黒色で透明度50%
      //   dismissible: false, // タップで閉じないようにする
      // ),
    // 3. リザルト画面
      // if (_result)
      // Center(
      //   child: ResultScreen(),
      // ),
        ],
      ),
    );
  }
}
