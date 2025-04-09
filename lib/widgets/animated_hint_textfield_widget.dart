import 'dart:async';

import 'package:flutter/material.dart';
class AnimatedHintTextField extends StatefulWidget {
  const AnimatedHintTextField({super.key});

  @override
  State<AnimatedHintTextField> createState() => _AnimatedHintTextFieldState();
}

class _AnimatedHintTextFieldState extends State<AnimatedHintTextField> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  final hints = ['Search Coolers...', 'Laptops...', 'TVs...'];
  int index = 0;

  @override
  void initState() {
    super.initState();
    // Rotate hint every 3 seconds
    Timer.periodic(const Duration(seconds: 3), (_) {
      if (!focusNode.hasFocus && controller.text.isEmpty) {
        setState(() {
          index = (index + 1) % hints.length;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        if (controller.text.isEmpty && !focusNode.hasFocus)
          Padding(
            padding: const EdgeInsets.only(left: 48), // space for icon
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                hints[index],
                key: ValueKey(hints[index]),
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
      ],
    );
  }
}
