import 'package:flutter/material.dart';
import '../../core/models/exercise.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'workout_detail_screen.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Cardio', 'Strength', 'Flexibility', 'Sports'];

  final List<Exercise> allExercises = [
    Exercise(
      id: 'e1',
      name: 'Running',
      description: 'High-intensity cardio to build endurance',
      caloriesBurned: 100,
      difficulty: 'medium',
      category: 'cardio',
      durationMinutes: 30,
      instructions: '1. Warm up for 5 minutes\n2. Run at moderate pace\n3. Cool down for 5 minutes',
      targetMuscles: ['Legs', 'Core'],
    ),
    Exercise(
      id: 'e2',
      name: 'Push-ups',
      description: 'Bodyweight strength exercise',
      caloriesBurned: 50,
      difficulty: 'medium',
      category: 'strength',
      durationMinutes: 15,
      instructions: '1. Start in plank position\n2. Lower your body\n3. Push back up\n4. Repeat 15-20 times',
      targetMuscles: ['Chest', 'Shoulders', 'Triceps'],
    ),
    Exercise(
      id: 'e3',
      name: 'Yoga',
      description: 'Flexibility and mindfulness training',
      caloriesBurned: 40,
      difficulty: 'easy',
      category: 'flexibility',
      durationMinutes: 45,
      instructions: '1. Start with warm-up poses\n2. Move through sequences\n3. End with meditation',
      targetMuscles: ['Full Body', 'Mind'],
    ),
    Exercise(
      id: 'e4',
      name: 'Swimming',
      description: 'Full-body cardio workout',
      caloriesBurned: 120,
      difficulty: 'hard',
      category: 'cardio',
      durationMinutes: 40,
      instructions: '1. Warm up with easy swimming\n2. Do laps at moderate pace\n3. Cool down with light strokes',
      targetMuscles: ['Full Body'],
    ),
    Exercise(
      id: 'e5',
      name: 'Squats',
      description: 'Lower body strength builder',
      caloriesBurned: 60,
      difficulty: 'medium',
      category: 'strength',
      durationMinutes: 20,
      instructions: '1. Stand with feet shoulder-width apart\n2. Lower your body\n3. Push back up\n4. Repeat 15-20 times',
      targetMuscles: ['Quadriceps', 'Glutes', 'Hamstrings'],
    ),
    Exercise(
      id: 'e6',
      name: 'Basketball',
      description: 'Fun sports cardio activity',
      caloriesBurned: 110,
      difficulty: 'hard',
      category: 'sports',
      durationMinutes: 60,
      instructions: '1. Warm up with shooting practice\n2. Play a full game\n3. Cool down',
      targetMuscles: ['Full Body', 'Cardio'],
    ),
  ];

  List<Exercise> get filteredExercises {
    if (selectedCategory == 'All') {
      return allExercises;
    }
    return allExercises.where((e) => e.category.toLowerCase() == selectedCategory.toLowerCase()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Workouts', style: AppTextStyles.heading),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Category Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: GestureDetector(
                      onTap: () => setState(() => selectedCategory = category),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? AppColors.background : AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Exercise List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                final exercise = filteredExercises[index];
                return _buildExerciseCard(context, exercise);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, Exercise exercise) {
    final difficultyColor = exercise.difficulty == 'easy'
        ? const Color(0xFF4CAF50)
        : exercise.difficulty == 'medium'
            ? const Color(0xFFFFC107)
            : const Color(0xFFFF5252);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => WorkoutDetailScreen(exercise: exercise)),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exercise.name, style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(exercise.description, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: difficultyColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    exercise.difficulty.toUpperCase(),
                    style: TextStyle(color: difficultyColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildExerciseInfo('🔥 Calories', '${exercise.caloriesBurned} kcal'),
                _buildExerciseInfo('⏱️ Time', '${exercise.durationMinutes} min'),
                _buildExerciseInfo('🎯 Category', exercise.category),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
        Text(value, style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
