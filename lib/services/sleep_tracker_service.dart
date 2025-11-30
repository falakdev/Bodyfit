import 'package:shared_preferences/shared_preferences.dart';

class SleepEntry {
  final DateTime date;
  final double hours;
  final int quality; // 1-5

  SleepEntry({
    required this.date,
    required this.hours,
    required this.quality,
  });
}

class SleepTrackerService {
  static final SleepTrackerService _instance = SleepTrackerService._internal();

  factory SleepTrackerService() {
    return _instance;
  }

  SleepTrackerService._internal();

  List<SleepEntry> _entries = [];

  Future<void> addSleep(double hours, int quality) async {
    _entries.add(SleepEntry(date: DateTime.now(), hours: hours, quality: quality));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('last_sleep_hours', hours);
    await prefs.setInt('last_sleep_quality', quality);
  }

  List<SleepEntry> getEntries() => _entries;
  
  double getAverageSleep() {
    if (_entries.isEmpty) return 0;
    final total = _entries.fold<double>(0, (sum, e) => sum + e.hours);
    return total / _entries.length;
  }

  int getAverageQuality() {
    if (_entries.isEmpty) return 0;
    return (_entries.fold(0, (sum, e) => sum + e.quality) / _entries.length)
        .toInt();
  }

  String getSleepRecommendation() {
    final avg = getAverageSleep();
    if (avg < 6) {
      return '⚠️ Try to get 7-8 hours!';
    } else if (avg >= 7 && avg <= 9) {
      return '✅ Perfect sleep schedule!';
    } else {
      return '😴 You might be oversleeping';
    }
  }
}
