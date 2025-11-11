class Exercise {
  final String id;
  final String name;
  final String description;
  final int caloriesBurned; // per 10 minutes
  final String difficulty; // easy, medium, hard
  final String category; // cardio, strength, flexibility, sports
  final int durationMinutes;
  final String instructions;
  final List<String> targetMuscles;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.caloriesBurned,
    required this.difficulty,
    required this.category,
    required this.durationMinutes,
    required this.instructions,
    required this.targetMuscles,
  });

  factory Exercise.fromMap(Map<String, dynamic> data) {
    return Exercise(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      caloriesBurned: data['caloriesBurned'] ?? 50,
      difficulty: data['difficulty'] ?? 'easy',
      category: data['category'] ?? 'cardio',
      durationMinutes: data['durationMinutes'] ?? 20,
      instructions: data['instructions'] ?? '',
      targetMuscles: List<String>.from(data['targetMuscles'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'caloriesBurned': caloriesBurned,
      'difficulty': difficulty,
      'category': category,
      'durationMinutes': durationMinutes,
      'instructions': instructions,
      'targetMuscles': targetMuscles,
    };
  }
}
