import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../widgets/fitness_chatbot.dart';
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
          bottomNavigationBar: Container(
            height: 68,
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
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              currentIndex: _selectedIndex,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: Colors.white38,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                setState(() => _selectedIndex = index);
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.directions_walk), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.fitness_center), label: "Workouts"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.auto_graph), label: "Stats"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: "Profile"),
              ],
            ),
          ),
        ),
        FitnessChatbot(
          geminiApiKey: 'AIzaSyAXsYBc0wIEWdvjQrEcGZxq4e8dFHxJbys',
        ),
      ],
    );
  }
}
