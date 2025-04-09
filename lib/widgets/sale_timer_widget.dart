import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'countdown_timer_widget.dart';

class SaleTimerWidget extends StatefulWidget {
  const SaleTimerWidget({super.key});

  @override
  State<SaleTimerWidget> createState() => _SaleTimerWidgetState();
}

class _SaleTimerWidgetState extends State<SaleTimerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade400, Colors.red.shade600],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Flash Sale Ends In',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          CountdownTimer(),
        ],
      ),
    );
  }
}

