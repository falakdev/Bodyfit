import 'package:flutter/foundation.dart';
import 'pedometer_real.dart' if (dart.library.html) 'pedometer_stub.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/models/user_profile.dart';
import '../services/firebase_service.dart';

class StepProvider extends ChangeNotifier {
  int steps = 0;
  int dailyGoal = 6000;
  double calories = 0.0;
  UserProfile? userProfile;
  final FirebaseService _firebaseService = FirebaseService();
  
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
    // Listen to auth state changes to load profile from Firebase
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null && user.email != null) {
        _loadProfileFromFirebase();
      } else {
        // Clear profile if user logs out
        userProfile = null;
        notifyListeners();
      }
    });
    
    // Also try to load profile immediately if user is already authenticated
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.email != null) {
      _loadProfileFromFirebase();
    }
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
    
    // Also save to Firebase if user is authenticated
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _firebaseService.saveStepData(steps, calories);
      } catch (e) {
        if (kDebugMode) print("Error saving step data to Firebase: $e");
      }
    }
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    dailyGoal = prefs.getInt("dailyGoal") ?? 6000;
    steps = prefs.getInt("steps") ?? 0;
    calories = prefs.getDouble("calories") ?? 0.0;
    
    // Try to load from Firebase first if user is authenticated
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _loadProfileFromFirebase();
    } else {
      // Fallback to SharedPreferences
      _loadProfileFromPrefs(prefs);
    }
    
    notifyListeners();
  }

  Future<void> _loadProfileFromFirebase() async {
    try {
      final profile = await _firebaseService.getUserProfile();
      if (profile != null) {
        userProfile = profile;
        dailyGoal = profile.dailyStepGoal;
        _calculateCalories();
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) print("Error loading profile from Firebase: $e");
    }
  }
  
  // Public method to reload profile from Firebase
  Future<void> loadProfileFromFirebase() async {
    await _loadProfileFromFirebase();
  }

  void _loadProfileFromPrefs(SharedPreferences prefs) {
    // Load user profile if exists in SharedPreferences
    String? profileJson = prefs.getString("userProfile");
    if (profileJson != null) {
      try {
        // Try to parse from SharedPreferences format
        final name = prefs.getString("name") ?? '';
        final gender = prefs.getString("gender") ?? 'Male';
        final age = prefs.getInt("age") ?? 25;
        final weight = prefs.getDouble("weight") ?? 70.0;
        final height = prefs.getDouble("height") ?? 170.0;
        final stepGoal = prefs.getInt("stepGoal") ?? 6000;
        
        if (name.isNotEmpty) {
          userProfile = UserProfile(
            name: name,
            age: age,
            weight: weight,
            height: height,
            gender: gender,
            fitnessLevel: 'beginner',
            dailyStepGoal: stepGoal,
          );
          dailyGoal = stepGoal;
        }
      } catch (e) {
        if (kDebugMode) print("Error loading profile from prefs: $e");
      }
    }
  }
  
  Future<void> saveUserProfile(UserProfile profile) async {
    userProfile = profile;
    dailyGoal = profile.dailyStepGoal;
    
    // Save to Firebase if user is authenticated
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _firebaseService.saveUserProfile(profile);
      } catch (e) {
        if (kDebugMode) print("Error saving profile to Firebase: $e");
      }
    }
    
    // Also save to SharedPreferences for backward compatibility
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("name", profile.name);
    await prefs.setString("gender", profile.gender);
    await prefs.setInt("age", profile.age);
    await prefs.setDouble("weight", profile.weight);
    await prefs.setDouble("height", profile.height);
    await prefs.setInt("stepGoal", profile.dailyStepGoal);
    
    _calculateCalories();
    notifyListeners();
  }

  Future<void> updateDailyGoal(int newGoal) async {
    dailyGoal = newGoal;
    
    // Update in Firebase if user is authenticated
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _firebaseService.updateDailyGoal(newGoal);
      } catch (e) {
        if (kDebugMode) print("Error updating goal in Firebase: $e");
      }
    }
    
    // Also update in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("dailyGoal", dailyGoal);
    
    // Update in user profile if exists
    if (userProfile != null) {
      userProfile = UserProfile(
        id: userProfile!.id,
        name: userProfile!.name,
        age: userProfile!.age,
        weight: userProfile!.weight,
        height: userProfile!.height,
        gender: userProfile!.gender,
        fitnessLevel: userProfile!.fitnessLevel,
        dailyStepGoal: newGoal,
        createdAt: userProfile!.createdAt,
      );
    }
    
    notifyListeners();
  }
  
  void recordWorkout(int minutes, double caloriesBurned) {
    workoutsCompletedThisWeek++;
    totalWorkoutMinutes += minutes;
    calories += caloriesBurned;
    notifyListeners();
  }
}
