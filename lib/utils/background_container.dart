import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget child;
  const BackgroundContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('assets/sonovision_bg_homepage.png',height: double.infinity,fit: BoxFit.cover,),

        Positioned.fill(
          child: child,
        ),
      ],
    );
  }
}
