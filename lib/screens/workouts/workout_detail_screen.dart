import 'package:flutter/material.dart';
import '../../core/models/exercise.dart';
import '../../widgets/session_timer.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final dynamic workout; // Legacy Workout object
  final Exercise? exercise;
  
  const WorkoutDetailScreen({super.key, this.workout, this.exercise});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  bool isWorkoutStarted = false;

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;
    if (exercise == null) return const Scaffold(body: Center(child: Text('No exercise selected')));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(exercise.name, style: AppTextStyles.heading),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Info
              _buildInfoRow('Duration', '${exercise.durationMinutes} min'),
              _buildInfoRow('Difficulty', exercise.difficulty.toUpperCase()),
              _buildInfoRow('Category', exercise.category),
              _buildInfoRow('Calories Burned', '${exercise.caloriesBurned} kcal'),
              const SizedBox(height: 20),

              // Description
              Text('About', style: AppTextStyles.subheading),
              const SizedBox(height: 8),
              Text(exercise.description, style: TextStyle(color: Colors.white70, height: 1.6)),
              const SizedBox(height: 20),

              // Target Muscles
              Text('Target Muscles', style: AppTextStyles.subheading),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: exercise.targetMuscles.map((muscle) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(muscle, style: TextStyle(color: AppColors.primary, fontSize: 12)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Instructions
              Text('How to Perform', style: AppTextStyles.subheading),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Text(
                  exercise.instructions,
                  style: TextStyle(color: Colors.white70, height: 1.8),
                ),
              ),
              const SizedBox(height: 24),

              if (isWorkoutStarted) ...[
                Text('Session Timer', style: AppTextStyles.subheading),
                const SizedBox(height: 12),
                Center(
                  child: SessionTimer(minutes: exercise.durationMinutes),
                ),
                const SizedBox(height: 24),
              ],

              // Action Buttons
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() => isWorkoutStarted = true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Workout started! Keep it up! 💪'),
                          backgroundColor: AppColors.primary,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Workout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.bookmark_add),
                    label: const Text('Save Workout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A1A),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white70)),
          Text(value, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
