// ThirdPage.dart

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:speech_balloon/speech_balloon.dart';

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
  late final List<int> resultVegetables;
  late final List<int> reI;
  String ojiCo="";

  @override
  void initState() {
    super.initState();
    resultVegetables = widget.curryVegetables
        .map((int value) => (value ~/ 5))
        .toList();
    for (int i = 0; i < resultVegetables.length; i++) {
      if (resultVegetables[i] != 0 && resultVegetables[i] <= 5) {
        resultVegetables[i] = resultVegetables[i] + 1;
      }
      if (resultVegetables[i] > 5) {
        resultVegetables[i] = 6;
      }
    }
    _fifteenScore();
    totalScore = _calculateScore();
    _ojiComment();
  }

  void _fifteenScore() {
    reI = []; // リストを初期化
    for (int value in widget.curryVegetables) {
      if (value - 15 >= 0) {
        reI.add(0);
      } else {
        reI.add(1);
      }
    }
  }

  int _calculateScore() {
    int score = 0;
    int count = 0;
    for (int value in resultVegetables) {
      count += 1;
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
        } else {
          score += 0;
        }
      } else if (count == 3) {
        if (value == 6) {
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
        } else {
          score += 0;
        }
      } else {
        if (value == 4) {
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
        } else {
          score += 0;
        }
      }
    }
    return score; // Clamp the final score to be between 5 and 100
  }

  void _ojiComment(){
    if(totalScore==100){
      setState((){
        ojiCo="完璧じゃ！見事見事！";
      });
    }
    else if(totalScore==0){
      setState((){
        ojiCo="これは料理ではない。毒じゃぜ。";
      });
    }
    else if(widget.curryVegetables.every((element) => element == 7)){
      setState((){
        ojiCo="これは!!伝説のカレーじゃ!!!";
      });
    }
    else if(widget.curryVegetables.every((element) => element >= 50)){
      setState((){
        ojiCo="なんと!?\nシチューが出来上がったぞ!!";
      });
    }
    else if(reI[0]+reI[1]+reI[2]+reI[3]==3){
      setState((){
        ojiCo="大胆な料理じゃ!具材が大きいのう";
      });
    }
    else if(reI[0]+reI[1]+reI[2]+reI[3]==2){
      setState((){
        ojiCo="ダイナミックとミニマムが\n混ざり合っておる!";
      });
    }
    else if(reI[0]==1){
      setState((){
        ojiCo="じゃがいもがそのままじゃ！\n主張が強いのう…";
      });
    }
    else if(reI[1]==1){
      setState((){
        ojiCo="にんじんがそのままじゃ！\n主張が強いのう…";
      });
    }
    else if(reI[2]==1){
      setState((){
        ojiCo="玉ねぎがそのままじゃ！\n主張が強いのう…";
      });
    }
    else if(reI[3]==1){
      setState((){
        ojiCo="肉がそのままじゃ!\n野蛮じゃのう…";
      });
    }
    else{
      setState((){
        ojiCo="細かすぎて見えん！";
      });
    }
  }

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          // Text(
          //     resultVegetables.toString(),
          //     style: Theme.of(context).textTheme.headlineMedium,
          //   ),
         Text(
            'Total Score: $totalScore', // Display the total score here
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color:Colors.black,
            
              // ストロークの設定
            ),
          ),
          Row(children:[
            Image.asset(
              'images/ojisan.png',
              width:100,
              height:100,
            ),
            SpeechBalloon(
              nipLocation: NipLocation.left,
              borderColor: Color.fromARGB(255, 86, 20, 40),
              height: 70, // マルなので同じheightとwidth
              width: 300,
              borderRadius: 40,
              offset: Offset(0, -1), // 棘の位置がずれてしまったのでoffsetで位置を修正してあげる
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$ojiCo',
                    style: TextStyle(color: Color.fromARGB(255, 86, 20, 40),fontSize:18),
                  ),
                ],
              ),
            )
          ]),
          if (totalScore == 100)
            Image.asset(
              'images/curry100.png',
              width: 500, // 画像の幅を調整
              height: 500, // 画像の高さを調整
            )
          else if (totalScore == 0)
            Image.asset(
              'images/curry0.png',
              width: 500, // 画像の幅を調整
              height: 500, // 画像の高さを調整
            )
          else if(widget.curryVegetables.every((element) => element == 7))
            Image.asset(
              'images/curry777.png',
              width: 500, // 画像の幅を調整
              height: 500, // 画像の高さを調整
            )
          else if(widget.curryVegetables.every((element) => element >= 50))
            Image.asset(
              'images/stew.png',
              width: 500, // 画像の幅を調整
              height: 500, // 画像の高さを調整
            )
          else
            Image.asset(
              'images/curry${reI[0]}${reI[1]}${reI[2]}${reI[3]}.png',
              width: 500, // 画像の幅を調整
              height: 500, // 画像の高さを調整
            ),

          Text(
            _userAccelerometerValues,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(_gyroscopeValues, style: Theme.of(context).textTheme.titleLarge),
            // 戻るボタン
            SizedBox(
              width: 250, // ボタンの幅を指定
              height: 80,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
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
