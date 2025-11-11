import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart' show rootBundle;
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
          // Try to load SVG asset; if missing, fallback to an icon so web run doesn't crash.
          FutureBuilder(
            future: rootBundle.load(image),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                return SvgPicture.asset(image, height: 240);
              }
              // Fallback visual
              return const Icon(Icons.fitness_center, size: 120, color: Colors.white70);
            },
          ),
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
