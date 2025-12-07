import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/progress_circle.dart';
import '../../widgets/all_features_widget.dart';
import '../../widgets/sticker_widget.dart';
import '../../widgets/weekly_steps_chart_widget.dart';
import '../../logic/step_provider.dart';
import '../workouts/workouts_screen.dart';
import '../stats/stats_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stepProvider = Provider.of<StepProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('BodyFit', style: AppTextStyles.heading),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                _buildWelcomeSection(stepProvider),
                const SizedBox(height: 20),

                // Average Steps Card Sticker
                AverageStepsCardSticker(
                  averageSteps: stepProvider.averageWeeklySteps.toInt(),
                  calories: stepProvider.calories,
                  minutes: (stepProvider.totalWorkoutMinutes).toInt(),
                  imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=300&fit=crop',
                ),

                // Weekly Steps Chart
                WeeklyStepsChartWidget(
                  weeklySteps: stepProvider.weeklySteps,
                  averageSteps: stepProvider.averageWeeklySteps,
                ),
                const SizedBox(height: 20),

                // Fitness Cards Section
                Text(
                  'Featured Workouts',
                  style: AppTextStyles.subheading.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Cardio Card Sticker
                FitnessCardSticker(
                  category: 'FITNESS',
                  title: 'Cardio',
                  description: 'Get active on your off days and challenge your friends',
                  imageUrl: 'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400&h=300&fit=crop',
                  participantCount: 12,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WorkoutsScreen()),
                    );
                  },
                ),

                // Health Article Card Sticker
                HealthArticleCardSticker(
                  category: 'HEALTH',
                  title: 'How to Be a Better Runner',
                  articleCount: 8,
                  imageUrl: 'https://images.unsplash.com/photo-1571008887538-b36bb32f4571?w=400&h=300&fit=crop',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StatsScreen()),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Today's Steps Card
                _buildBigStepsCard(stepProvider),
                const SizedBox(height: 16),

                // Two stat cards side by side
                Row(
                  children: [
                    Expanded(
                      child: _buildSmallInfoCard(
                        title: 'Avg Steps',
                        value:
                            stepProvider.averageWeeklySteps.toStringAsFixed(0),
                        icon: Icons.directions_walk,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSmallInfoCard(
                        title: 'Distance',
                        value:
                            '${(stepProvider.steps * 0.00075).toStringAsFixed(2)} km',
                        icon: Icons.map,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Profile Section (if user logged in)
                if (stepProvider.userProfile != null)
                  _buildProfileSection(stepProvider),
                if (stepProvider.userProfile != null)
                  const SizedBox(height: 16),

                // Quick Actions
                _buildQuickActions(context),
                const SizedBox(height: 16),

                // Features Panel
                SizedBox(
                  height: 300,
                  child: const AllFeaturesWidget(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(StepProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.2),
            AppColors.accent.withOpacity(0.2)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, ${provider.userProfile?.name ?? 'Fitness Enthusiast'}! 👋',
            style: AppTextStyles.heading,
          ),
          const SizedBox(height: 8),
          Text(
            'Keep moving to reach your daily goal',
            style: AppTextStyles.body,
          ),
        ],
      ),
    );
  }

  Widget _buildSmallInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 4),
              Text(value,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBigStepsCard(StepProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Today', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 6),
                  Text('${provider.steps}',
                      style: AppTextStyles.heading
                          .copyWith(color: Colors.white, fontSize: 36)),
                  const SizedBox(height: 4),
                  Text('${provider.dailyGoal} goal',
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
              SizedBox(
                width: 120,
                height: 120,
                child: ProgressCircle(
                  progress: provider.progress,
                  label: "${provider.steps} / ${provider.dailyGoal}",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(StepProvider provider) {
    final profile = provider.userProfile!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Profile', style: AppTextStyles.subheading),
          const SizedBox(height: 12),
          _buildProfileRow('Age', '${profile.age} years'),
          _buildProfileRow('Weight', '${profile.weight} kg'),
          _buildProfileRow('Height', '${profile.height} cm'),
          _buildProfileRow('BMI', '${profile.bmi.toStringAsFixed(1)}'),
          _buildProfileRow('Level', profile.fitnessLevel.toUpperCase()),
        ],
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white70)),
          Text(value,
              style: TextStyle(
                  color: AppColors.primary, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: AppTextStyles.subheading),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton('🏃 Start Workout', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WorkoutsScreen()),
                );
              }),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton('📊 View Stats', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StatsScreen()),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.3),
              AppColors.accent.withOpacity(0.3)
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.5)),
        ),
        child: Center(
          child: Text(label,
              style: TextStyle(
                  color: AppColors.primary, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
