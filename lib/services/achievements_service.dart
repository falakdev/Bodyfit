import 'package:shared_preferences/shared_preferences.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int requirement;
  bool isUnlocked;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.requirement,
    this.isUnlocked = false,
  });
}

class AchievementsService {
  static final AchievementsService _instance = AchievementsService._internal();

  factory AchievementsService() {
    return _instance;
  }

  AchievementsService._internal();

  late List<Achievement> achievements;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    achievements = [
      Achievement(
        id: 'first_1000_steps',
        title: '🚶 First Steps',
        description: 'Walk 1000 steps',
        icon: '🚶',
        requirement: 1000,
        isUnlocked: prefs.getBool('first_1000_steps') ?? false,
      ),
      Achievement(
        id: 'five_k_steps',
        title: '🔥 5K Steps',
        description: 'Walk 5000 steps in a day',
        icon: '🔥',
        requirement: 5000,
        isUnlocked: prefs.getBool('five_k_steps') ?? false,
      ),
      Achievement(
        id: 'ten_k_steps',
        title: '⭐ 10K Warrior',
        description: 'Walk 10000 steps in a day',
        icon: '⭐',
        requirement: 10000,
        isUnlocked: prefs.getBool('ten_k_steps') ?? false,
      ),
      Achievement(
        id: 'water_warrior',
        title: '💧 Hydration Master',
        description: 'Drink 8 glasses of water',
        icon: '💧',
        requirement: 8,
        isUnlocked: prefs.getBool('water_warrior') ?? false,
      ),
      Achievement(
        id: 'seven_day_streak',
        title: '📅 Week Warrior',
        description: 'Maintain a 7 day streak',
        icon: '📅',
        requirement: 7,
        isUnlocked: prefs.getBool('seven_day_streak') ?? false,
      ),
      Achievement(
        id: 'timer_master',
        title: '⏱️ Timer Master',
        description: 'Use workout timer 10 times',
        icon: '⏱️',
        requirement: 10,
        isUnlocked: prefs.getBool('timer_master') ?? false,
      ),
    ];
  }

  Future<void> unlockAchievement(String id) async {
    final achievement = achievements.firstWhere((a) => a.id == id);
    achievement.isUnlocked = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(id, true);
  }

  List<Achievement> getAchievements() => achievements;
  int getUnlockedCount() =>
      achievements.where((a) => a.isUnlocked).length;
}
