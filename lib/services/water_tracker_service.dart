import 'package:shared_preferences/shared_preferences.dart';

class WaterTrackerService {
  static final WaterTrackerService _instance = WaterTrackerService._internal();

  factory WaterTrackerService() {
    return _instance;
  }

  WaterTrackerService._internal();

  int _glassesToday = 0;
  final int dailyGoal = 8;

  Future<void> initialize() async {
    await _checkNewDay();
  }

  Future<void> _checkNewDay() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    final savedDate = prefs.getString('water_date') ?? '';

    if (savedDate != today) {
      _glassesToday = 0;
      await prefs.setString('water_date', today);
      await prefs.setInt('glasses_today', 0);
    } else {
      _glassesToday = prefs.getInt('glasses_today') ?? 0;
    }
  }

  Future<void> addGlass() async {
    _glassesToday++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('glasses_today', _glassesToday);
  }

  Future<void> removeGlass() async {
    if (_glassesToday > 0) {
      _glassesToday--;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('glasses_today', _glassesToday);
    }
  }

  int getGlassesToday() => _glassesToday;
  double getProgress() => (_glassesToday / dailyGoal).clamp(0.0, 1.0);
  int getRemainingGlasses() => (dailyGoal - _glassesToday).clamp(0, dailyGoal);
}
