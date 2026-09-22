import 'dart:async';

import 'package:flutter/material.dart';

class ClickGame extends StatefulWidget {
  const new({super.key});

  @override
  State<ClickGame> createState() => _ClickGameState();
}

class _ClickGameState extends State<ClickGame> {
  Timer? timer;
  double time = 0.00;
  Stopwatch stopwatch = Stopwatch();
  int clickAmount = 0;

  void click() {
    if (time <= 0) return;
    setState(() {
      clickAmount++;
    });
  }

  void play() {
    stopwatch.reset();
    stopwatch.start();
    clickAmount = 0;
    time = 1;

    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        time = 1 - (stopwatch.elapsedMilliseconds / 1000);
        if (time <= 0) {
          time = 0;
          stopwatch.stop();
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            time.toStringAsFixed(2),
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
          Text('Click = $clickAmount', style: TextStyle(fontSize: 32)),
          Row(
            mainAxisAlignment: .center,
            children: [
              FilledButton(
                onPressed: click,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                ),
                child: Row(
                  children: [
                    Icon(Icons.ads_click),
                    SizedBox(width: 8),
                    Text('Click'),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: play,
                child: Row(
                  children: [
                    Icon(Icons.ads_click, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Play', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
