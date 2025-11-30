import 'package:shared_preferences/shared_preferences.dart';

class WeightEntry {
  final DateTime date;
  final double weight;

  WeightEntry({required this.date, required this.weight});
}

class WeightTrackerService {
  static final WeightTrackerService _instance =
      WeightTrackerService._internal();

  factory WeightTrackerService() {
    return _instance;
  }

  WeightTrackerService._internal();

  List<WeightEntry> _entries = [];
  double _targetWeight = 70.0;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _targetWeight = prefs.getDouble('target_weight') ?? 70.0;
  }

  Future<void> addWeight(double weight) async {
    _entries.add(WeightEntry(date: DateTime.now(), weight: weight));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('last_weight', weight);
  }

  Future<void> setTargetWeight(double target) async {
    _targetWeight = target;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('target_weight', target);
  }

  List<WeightEntry> getEntries() => _entries;
  double? getLastWeight() => _entries.isNotEmpty ? _entries.last.weight : null;
  double getTargetWeight() => _targetWeight;
  double getWeightDifference() =>
      _entries.isNotEmpty ? _entries.first.weight - _entries.last.weight : 0;
}
