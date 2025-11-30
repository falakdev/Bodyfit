import 'package:shared_preferences/shared_preferences.dart';

class Food {
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;

  const Food({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
  });
}

class CalorieCounterService {
  static final CalorieCounterService _instance =
      CalorieCounterService._internal();

  factory CalorieCounterService() {
    return _instance;
  }

  CalorieCounterService._internal();

  List<Food> _foodsToday = [];
  final int dailyGoal = 2000;

  // Common foods database
  static const List<Food> commonFoods = [
    Food(
      name: 'Apple',
      calories: 95,
      protein: 0,
      carbs: 25,
      fats: 0,
    ),
    Food(
      name: 'Banana',
      calories: 105,
      protein: 1,
      carbs: 27,
      fats: 0,
    ),
    Food(
      name: 'Chicken Breast (100g)',
      calories: 165,
      protein: 31,
      carbs: 0,
      fats: 4,
    ),
    Food(
      name: 'Brown Rice (cooked, 1 cup)',
      calories: 215,
      protein: 5,
      carbs: 45,
      fats: 2,
    ),
    Food(
      name: 'Egg',
      calories: 78,
      protein: 6,
      carbs: 1,
      fats: 5,
    ),
    Food(
      name: 'Greek Yogurt (1 cup)',
      calories: 130,
      protein: 23,
      carbs: 9,
      fats: 0,
    ),
    Food(
      name: 'Broccoli (1 cup)',
      calories: 55,
      protein: 4,
      carbs: 11,
      fats: 1,
    ),
    Food(
      name: 'Almonds (1 oz)',
      calories: 164,
      protein: 6,
      carbs: 6,
      fats: 14,
    ),
  ];

  Future<void> initialize() async {
    await _checkNewDay();
  }

  Future<void> _checkNewDay() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    final savedDate = prefs.getString('calorie_date') ?? '';

    if (savedDate != today) {
      _foodsToday = [];
      await prefs.setString('calorie_date', today);
      await prefs.setString('foods_today', '');
    }
  }

  void addFood(Food food) {
    _foodsToday.add(food);
  }

  void removeFood(int index) {
    if (index >= 0 && index < _foodsToday.length) {
      _foodsToday.removeAt(index);
    }
  }

  int getTotalCalories() {
    return _foodsToday.fold(0, (sum, food) => sum + food.calories);
  }

  int getTotalProtein() {
    return _foodsToday.fold(0, (sum, food) => sum + food.protein);
  }

  int getTotalCarbs() {
    return _foodsToday.fold(0, (sum, food) => sum + food.carbs);
  }

  int getTotalFats() {
    return _foodsToday.fold(0, (sum, food) => sum + food.fats);
  }

  List<Food> getFoodsToday() => _foodsToday;
  double getProgress() => (getTotalCalories() / dailyGoal).clamp(0.0, 1.0);
  int getRemainingCalories() =>
      (dailyGoal - getTotalCalories()).clamp(0, dailyGoal);
}
