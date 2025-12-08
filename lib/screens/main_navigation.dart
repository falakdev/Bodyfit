import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../widgets/fitness_chatbot.dart';
import '../config/api_config.dart';
import '../widgets/food_camera_button.dart';
import 'home/home_screen.dart';
import 'stats/stats_screen.dart';
import 'profile/profile_screen.dart';
import 'workouts/workouts_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const WorkoutsScreen(),
    const StatsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.background,
          body: _screens[_selectedIndex],
          bottomNavigationBar: _buildCustomBottomNav(),
        ),
        FitnessChatbot(
          geminiApiKey: ApiConfig.geminiApiKey,
        ),
        const FoodCameraButton(),
      ],
    );
  }

  Widget _buildCustomBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, 'Home', Icons.directions_walk),
          _buildNavItem(1, 'Exercise', Icons.fitness_center),
          _buildNavItem(2, 'Stats', Icons.auto_graph),
          _buildNavItem(3, 'Profile', Icons.person),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 26,
            color: isSelected ? AppColors.primary : Colors.white54,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isSelected ? AppColors.primary : Colors.white54,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
