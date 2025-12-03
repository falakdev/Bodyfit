// Achievements feature removed.
// This file is left as a lightweight stub so any lingering imports won't break the build.

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int requirement;
  final bool isUnlocked;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.requirement,
    this.isUnlocked = false,
  });
}

class AchievementsService {
  AchievementsService();

  /// Returns an empty list since achievements were removed.
  List<Achievement> getAchievements() => const [];

  /// No-op
  Future<void> unlockAchievement(String id) async {}

  int getUnlockedCount() => 0;
}
