import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'ThirdPage.dart';

class NiruPage extends StatefulWidget {
  final List<int> curryVegetables;

  const NiruPage({super.key, required this.curryVegetables});

  @override
  State<NiruPage> createState() => _NiruPageState();
}

class _NiruPageState extends State<NiruPage> {
  bool _isBoiling = false;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.play(AssetSource('sounds/nikomi.mp3'));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isBoiling = true;
      });
    });

    Timer(const Duration(seconds: 8), () {
      _audioPlayer.stop();
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
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
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
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Image.asset('images/pot.png', width: 300),

                AnimatedPositioned(
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeOut,
                  bottom: _isBoiling ? 200.0 : 50.0,
                  child: AnimatedOpacity(
                    duration: const Duration(seconds: 5),
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
