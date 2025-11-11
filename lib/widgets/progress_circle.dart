import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProgressCircle extends StatelessWidget {
  final double progress;
  final String label;

  const ProgressCircle({super.key, required this.progress, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      height: 230,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Neon Pulse Glow Circle
          Container(
            width: 230,
            height: 230,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.6),
                  blurRadius: 40,
                  spreadRadius: 6,
                ),
              ],
            ),
          ).animate(onPlay: (controller) => controller.repeat())
           .scale(duration: 1600.ms, curve: Curves.easeInOut)
           .then()
           .scale(duration: 1600.ms, begin: const Offset(1.1, 1.1), end: const Offset(0.9, 0.9)),

          CircularProgressIndicator(
            value: progress,
            strokeWidth: 14,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),

          Text(
            label,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: AppColors.primary,
                  blurRadius: 15,
                ),
              ],
            ),
          ).animate().fade(duration: 800.ms).scale(duration: 800.ms),
        ],
      ),
    );
  }
}
