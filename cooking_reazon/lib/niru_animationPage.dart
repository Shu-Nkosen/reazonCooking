import 'dart:async';
import 'package:flutter/material.dart';
import 'ThirdPage.dart';

class AnimationPage extends StatefulWidget {
  final List<int> curryVegetables;

  const AnimationPage({super.key, required this.curryVegetables});

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> {
  bool _isBoiling = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isBoiling = true;
      });
    });

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ThirdPage(curryVegetables: widget.curryVegetables),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset('images/pot.png', width: 300),

                AnimatedPositioned(
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeOut,
                  bottom: _isBoiling ? 200.0 : 50.0,
                  child: AnimatedOpacity(
                    duration: const Duration(seconds: 2),
                    opacity: _isBoiling ? 1.0 : 0.0,
                    child: Image.asset('images/steam.png', width: 100),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              '美味しく煮込み中...',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
