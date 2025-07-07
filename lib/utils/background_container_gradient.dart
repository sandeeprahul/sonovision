import 'dart:ui';

import 'package:flutter/material.dart';

class BackgroundContainerGradient extends StatelessWidget {
  final Widget child;
  const BackgroundContainerGradient({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}
