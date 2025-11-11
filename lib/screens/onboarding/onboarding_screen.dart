import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../auth/login_screen.dart';
import 'onboarding_page_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      "image": "assets/svg/running_person.svg",
      "title": "Track Your Steps",
      "subtitle": "Automatically count your steps and monitor daily activity."
    },
    {
      "image": "assets/svg/workout_man.svg",
      "title": "Burn More Calories",
      "subtitle": "See how many calories you burn and stay motivated!"
    },
    {
      "image": "assets/svg/yoga_pose.svg",
      "title": "Stay Fit & Healthy",
      "subtitle": "Build consistency and achieve your fitness goals."
    },
  ];

  Future<void> finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("onboarding_done", true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) {
                setState(() => currentPage = index);
              },
              itemCount: pages.length,
              itemBuilder: (_, index) {
                final p = pages[index];
                return OnboardingPage(
                  image: p["image"]!,
                  title: p["title"]!,
                  subtitle: p["subtitle"]!,
                );
              },
            ),
          ),

          // Dots Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                height: 8,
                width: currentPage == index ? 22 : 8,
                decoration: BoxDecoration(
                  color: currentPage == index ? AppColors.primary : Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),

          // Button
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: ElevatedButton(
              onPressed: currentPage == pages.length - 1
                  ? finishOnboarding
                  : () => _controller.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.ease),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(currentPage == pages.length - 1 ? "Get Started" : "Next"),
            ),
          )
        ],
      ),
    );
  }
}
