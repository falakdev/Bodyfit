import 'dart:convert';
import 'package:flutter/foundation.dart';
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

  // Notifier to inform UI when foods change
  final ValueNotifier<int> notifier = ValueNotifier<int>(0);

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
    await _loadSavedFoods();
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
    _saveFoods();
    notifier.value++;
  }

  void removeFood(int index) {
    if (index >= 0 && index < _foodsToday.length) {
      _foodsToday.removeAt(index);
      _saveFoods();
      notifier.value++;
    }
  }

  // Add a scanned food entry from a map of values (name, calories, protein, carbs, fats)
  void addScannedFood(Map<String, dynamic> data) {
    try {
      final food = Food(
        name: data['name']?.toString() ?? 'Scanned Food',
        calories: (data['calories'] is int)
            ? data['calories']
            : int.tryParse(data['calories']?.toString() ?? '') ?? 0,
        protein: (data['protein'] is int)
            ? data['protein']
            : int.tryParse(data['protein']?.toString() ?? '') ?? 0,
        carbs: (data['carbs'] is int)
            ? data['carbs']
            : int.tryParse(data['carbs']?.toString() ?? '') ?? 0,
        fats: (data['fats'] is int)
            ? data['fats']
            : int.tryParse(data['fats']?.toString() ?? '') ?? 0,
      );

      addFood(food);
      // addFood will already update notifier
    } catch (_) {
      // ignore parsing errors for now
    }
  }

  Future<void> _saveFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_foodsToday
        .map((f) => {
              'name': f.name,
              'calories': f.calories,
              'protein': f.protein,
              'carbs': f.carbs,
              'fats': f.fats,
            })
        .toList());
    await prefs.setString('foods_today', encoded);
  }

  Future<void> _loadSavedFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('foods_today') ?? '';
    if (raw.isEmpty) return;
    try {
      final List<dynamic> list = jsonDecode(raw);
      _foodsToday = list
          .map((e) => Food(
                name: e['name'] ?? 'Food',
                calories: e['calories'] ?? 0,
                protein: e['protein'] ?? 0,
                carbs: e['carbs'] ?? 0,
                fats: e['fats'] ?? 0,
              ))
          .toList();
    } catch (_) {
      // ignore and keep empty
      _foodsToday = [];
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
