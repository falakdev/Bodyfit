import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_gradients.dart';

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
        gradient: AppGradients.mainGradient,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // On web many SVG assets are not included; avoid noisy 404s by
          // using a simple icon fallback on web. On mobile, load the SVG.
          if (kIsWeb)
            const Icon(Icons.fitness_center, size: 120, color: Colors.white70)
          else
            SvgPicture.asset(image, height: 240),
          const SizedBox(height: 40),
          Text(title, style: AppTextStyles.heading, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(subtitle, style: AppTextStyles.subheading, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
