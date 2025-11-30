import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/progress_circle.dart';
import '../../widgets/water_tracker_widget.dart';
import '../../widgets/workout_timer_widget.dart';
import '../../widgets/calorie_counter_widget.dart';
import '../../widgets/all_features_widget.dart';
import '../../logic/step_provider.dart';

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
              children: [
                // Welcome Section
                _buildWelcomeSection(stepProvider),
                const SizedBox(height: 24),

                // Daily Steps Progress
                _buildStepsCard(stepProvider),
                const SizedBox(height: 20),

                // Calories & Stats Row
                Row(
                  children: [
                    Expanded(child: _buildStatCard(
                      title: 'Calories',
                      value: stepProvider.calories.toStringAsFixed(0),
                      unit: 'kcal',
                      icon: Icons.local_fire_department,
                      color: Color(0xFFFF6B6B),
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatCard(
                      title: 'Avg Steps',
                      value: stepProvider.averageWeeklySteps.toStringAsFixed(0),
                      unit: 'steps',
                      icon: Icons.directions_walk,
                      color: AppColors.primary,
                    )),
                  ],
                ),
                const SizedBox(height: 20),

                // User Profile Section
                if (stepProvider.userProfile != null)
                  _buildProfileSection(stepProvider),
                const SizedBox(height: 20),

                // Quick Action Buttons
                _buildQuickActions(context),
                const SizedBox(height: 24),

                // Water Tracker
                const WaterTrackerWidget(),
                const SizedBox(height: 20),

                // Workout Timer
                const WorkoutTimerWidget(),
                const SizedBox(height: 20),

                // Calorie Counter
                const CalorieCounterWidget(),
                const SizedBox(height: 20),

                // All Features (Achievements, Quotes, BMI)
                SizedBox(
                  height: 400,
                  child: const AllFeaturesWidget(),
                ),
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
          colors: [AppColors.primary.withOpacity(0.2), AppColors.accent.withOpacity(0.2)],
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

  Widget _buildStepsCard(StepProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Text('Today\'s Steps', style: AppTextStyles.subheading),
          const SizedBox(height: 20),
          Center(
            child: ProgressCircle(
              progress: provider.progress,
              label: "${provider.steps} / ${provider.dailyGoal}",
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatMini('Distance', '${(provider.steps * 0.00075).toStringAsFixed(2)} km'),
              _buildStatMini('Duration', '${(provider.steps / 60).toStringAsFixed(0)} min'),
              _buildStatMini('Goal', '${((provider.progress) * 100).toStringAsFixed(0)}%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatMini(String label, String value) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 6),
          Text('$value $unit', style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
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
          Text(value, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
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
                // Navigate to workouts
              }),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton('📊 View Stats', () {
                // Navigate to stats
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
            colors: [AppColors.primary.withOpacity(0.3), AppColors.accent.withOpacity(0.3)],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.5)),
        ),
        child: Center(
          child: Text(label, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
