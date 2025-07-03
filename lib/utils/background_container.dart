import 'dart:ui';

import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget child;
  const BackgroundContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('assets/sonovision_bg_homepage.png',
          height: double.infinity,
          width: double.infinity,
          // width:MediaQuery.of(context),
          fit: BoxFit.cover,),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withOpacity(0.2), // Must be non-opaque for blur to show
          ),
        ),
        Positioned.fill(
          child: child,
        ),
      ],
    );
  }
}
