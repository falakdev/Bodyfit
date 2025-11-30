import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepCounterService {
  static final StepCounterService _instance = StepCounterService._internal();

  factory StepCounterService() {
    return _instance;
  }

  StepCounterService._internal();

  late Stream<StepCount> _stepCountStream;
  int _todaySteps = 0;

  Future<void> initialize() async {
    await _checkNewDay();
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen((StepCount event) {
      _todaySteps = event.steps;
      _saveTodaySteps();
    });
  }

  Future<void> _checkNewDay() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    final savedDate = prefs.getString('step_date') ?? '';

    if (savedDate != today) {
      // New day, reset steps
      _todaySteps = 0;
      await prefs.setString('step_date', today);
      await prefs.setInt('today_steps', 0);
    } else {
      // Same day, load saved steps
      _todaySteps = prefs.getInt('today_steps') ?? 0;
    }
  }

  Future<void> _saveTodaySteps() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('today_steps', _todaySteps);
  }

  int getTodaySteps() => _todaySteps;

  Future<int> getTotalSteps() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('today_steps') ?? 0;
  }

  Stream<int> getStepStream() {
    return _stepCountStream.map((StepCount event) {
      _todaySteps = event.steps;
      return event.steps;
    });
  }
}
