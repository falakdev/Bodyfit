import 'package:flutter/foundation.dart';
import 'pedometer_real.dart' if (dart.library.html) 'pedometer_stub.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/models/user_profile.dart';

class StepProvider extends ChangeNotifier {
  int steps = 0;
  int dailyGoal = 6000;
  double calories = 0.0;
  UserProfile? userProfile;
  
  // Weekly stats
  List<int> weeklySteps = [0, 0, 0, 0, 0, 0, 0];
  List<double> weeklyCalories = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  
  // Workout tracking
  int workoutsCompletedThisWeek = 0;
  double totalWorkoutMinutes = 0.0;

  Stream<StepCount>? _stepCountStream;

  StepProvider() {
    _loadSavedData();
    _initPedometer();
  }

  void _initPedometer() {
    // pedometer plugin is not available on web — guard initialization
    if (kIsWeb) {
      // On web, do not initialize native pedometer stream.
      return;
    }
    try {
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream!.listen(_onStepData).onError(_onStepError);
    } catch (e) {
      if (kDebugMode) print('Pedometer initialization failed: $e');
    }
  }

  void _onStepData(StepCount stepData) {
    steps = stepData.steps;
    _calculateCalories();
    _saveData();
    notifyListeners();
  }

  void _onStepError(error) {
    if (kDebugMode) {
      print("Pedometer Error: $error");
    }
  }

  void _calculateCalories() {
    // Formula: 0.04 calories per step (adjustable based on weight)
    if (userProfile != null) {
      // Adjust for weight: heavier people burn more calories
      calories = steps * 0.04 * (userProfile!.weight / 70);
    } else {
      calories = steps * 0.04;
    }
  }

  double get progress => (steps / dailyGoal).clamp(0, 1);
  
  double get averageWeeklySteps {
    return weeklySteps.isEmpty ? 0 : weeklySteps.reduce((a, b) => a + b) / weeklySteps.length;
  }
  
  double get totalWeeklyCalories {
    return weeklyCalories.isEmpty ? 0 : weeklyCalories.reduce((a, b) => a + b);
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("steps", steps);
    prefs.setDouble("calories", calories);
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    dailyGoal = prefs.getInt("dailyGoal") ?? 6000;
    steps = prefs.getInt("steps") ?? 0;
    calories = prefs.getDouble("calories") ?? 0.0;
    
    // Load user profile if exists
    String? profileJson = prefs.getString("userProfile");
    if (profileJson != null) {
      try {
        userProfile = UserProfile.fromMap(
          Map<String, dynamic>.from(
            Map.from(profileJson.split(',').asMap())
          ),
        );
      } catch (e) {
        if (kDebugMode) print("Error loading profile: $e");
      }
    }
    
    notifyListeners();
  }
  
  Future<void> saveUserProfile(UserProfile profile) async {
    userProfile = profile;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("userProfile", profile.toString());
    _calculateCalories();
    notifyListeners();
  }

  Future<void> updateDailyGoal(int newGoal) async {
    dailyGoal = newGoal;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("dailyGoal", dailyGoal);
    notifyListeners();
  }
  
  void recordWorkout(int minutes, double caloriesBurned) {
    workoutsCompletedThisWeek++;
    totalWorkoutMinutes += minutes;
    calories += caloriesBurned;
    notifyListeners();
  }
}
