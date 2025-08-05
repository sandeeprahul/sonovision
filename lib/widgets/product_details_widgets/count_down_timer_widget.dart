import 'dart:async';

import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime endTime;
  const CountdownTimer({super.key, required this.endTime});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration remaining;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    // print("Timer initialized with endTime: ${widget.endTime}"); // Debug
    remaining = widget.endTime.difference(DateTime.now());
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final diff = widget.endTime.difference(DateTime.now());
      // print("Time remaining: ${diff.inSeconds}s"); // Debug
      setState(() {
        remaining = diff;
        if (diff.isNegative) timer.cancel();
      });
    });
  }


  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String format(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    if (remaining.isNegative) return const SizedBox();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.symmetric(horizontal: 12,),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "Ends in ${format(remaining)}",
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
