class UserProfile {
  final String? id;
  final String name;
  final int age;
  final double weight;
  final double height;
  final String gender;
  final String fitnessLevel; // beginner, intermediate, advanced
  final int dailyStepGoal;
  final DateTime createdAt;

  UserProfile({
    this.id,
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.fitnessLevel,
    required this.dailyStepGoal,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserProfile.fromMap(Map<String, dynamic> data) {
    return UserProfile(
      id: data['id'],
      name: data['name'] ?? '',
      age: data['age'] ?? 25,
      weight: (data['weight'] ?? 70).toDouble(),
      height: (data['height'] ?? 170).toDouble(),
      gender: data['gender'] ?? 'Male',
      fitnessLevel: data['fitnessLevel'] ?? 'beginner',
      dailyStepGoal: data['dailyStepGoal'] ?? 6000,
      createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender,
      'fitnessLevel': fitnessLevel,
      'dailyStepGoal': dailyStepGoal,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  double get bmi => weight / ((height / 100) * (height / 100));
}
