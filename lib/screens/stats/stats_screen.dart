import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../logic/step_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stepProvider = Provider.of<StepProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Statistics', style: AppTextStyles.heading),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Cards
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Total Steps',
                      value: stepProvider.steps.toString(),
                      icon: Icons.directions_walk,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Total Calories',
                      value: stepProvider.calories.toStringAsFixed(0),
                      icon: Icons.local_fire_department,
                      color: const Color(0xFFFF6B6B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Workouts Done',
                      value: stepProvider.workoutsCompletedThisWeek.toString(),
                      icon: Icons.fitness_center,
                      color: const Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Avg Daily Steps',
                      value: stepProvider.averageWeeklySteps.toStringAsFixed(0),
                      icon: Icons.trending_up,
                      color: const Color(0xFFFFB74D),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Weekly Progress
              Text('Weekly Performance', style: AppTextStyles.subheading),
              const SizedBox(height: 16),
              _buildWeeklyChart(stepProvider),
              const SizedBox(height: 24),

              // Daily Breakdown
              Text('Daily Breakdown', style: AppTextStyles.subheading),
              const SizedBox(height: 12),
              _buildDailyBreakdown(),
              const SizedBox(height: 24),

              // Achievements
              Text('Achievements', style: AppTextStyles.subheading),
              const SizedBox(height: 12),
              _buildAchievements(stepProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(StepProvider provider) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final maxSteps = 10000;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              return Column(
                children: [
                  Container(
                    width: 30,
                    height: (provider.weeklySteps.isNotEmpty ? provider.weeklySteps[index] : 0) / maxSteps * 150,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(days[index], style: const TextStyle(color: Colors.white54, fontSize: 10)),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyBreakdown() {
    final days = ['Today', 'Yesterday', 'Last 3 Days', 'This Week', 'This Month'];
    final values = ['8,234 steps', '7,891 steps', '23,450 steps', '56,780 steps', '245,300 steps'];

    return Column(
      children: List.generate(5, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(days[index], style: const TextStyle(color: Colors.white70)),
                Text(values[index], style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAchievements(StepProvider provider) {
    final achievements = [
      _buildAchievementBadge('🏃 First Steps', 'Walk 1,000 steps', true),
      _buildAchievementBadge('⭐ Consistent', 'Reach goal 7 days in a row', provider.workoutsCompletedThisWeek >= 7),
      _buildAchievementBadge('🔥 On Fire', 'Complete 10 workouts', provider.workoutsCompletedThisWeek >= 10),
      _buildAchievementBadge('💪 Strong', 'Burn 5,000 calories', provider.calories >= 5000),
    ];

    return Column(
      children: achievements,
    );
  }

  Widget _buildAchievementBadge(String name, String description, bool unlocked) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: unlocked ? AppColors.primary : Colors.white24,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Text(name, style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(description, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: unlocked ? AppColors.primary.withOpacity(0.2) : Colors.white10,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                unlocked ? '✓ Unlocked' : 'Locked',
                style: TextStyle(
                  color: unlocked ? AppColors.primary : Colors.white54,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

