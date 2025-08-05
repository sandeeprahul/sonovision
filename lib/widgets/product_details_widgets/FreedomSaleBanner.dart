import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';

class FreedomSaleBanner extends StatefulWidget {
  final DateTime saleEndTime;
  final double discountPercent;

  const FreedomSaleBanner({
    super.key,
    required this.saleEndTime,
    required this.discountPercent,
  });

  @override
  State<FreedomSaleBanner> createState() => _FreedomSaleBannerState();
}

class _FreedomSaleBannerState extends State<FreedomSaleBanner>
    with SingleTickerProviderStateMixin {
  // late Timer _timer;
  late Duration _remaining;
  // late AnimationController _controller;
  // late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _remaining = widget.saleEndTime.difference(DateTime.now());


  }


  String _formatTime(Duration d) {
    return "${d.inDays}d ${d.inHours.remainder(24)}h ${d.inMinutes.remainder(60)}m";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric( horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isDark ? Colors.deepPurple.shade800 : Colors.purple.shade300,
            isDark ? Colors.indigo.shade900 : Colors.blue.shade400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      /*  boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],*/
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Sale Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FREEDOM SALE!',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.discountPercent.round()}% OFF',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.amber.shade200,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          // Countdown Timer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Ends in',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(_remaining),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}