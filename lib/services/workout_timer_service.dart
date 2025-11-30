import 'dart:async';

class WorkoutTimerService {
  static final WorkoutTimerService _instance =
      WorkoutTimerService._internal();

  factory WorkoutTimerService() {
    return _instance;
  }

  WorkoutTimerService._internal();

  late Timer _timer;
  int _seconds = 0;
  bool _isRunning = false;
  StreamController<int> _timerStream = StreamController<int>.broadcast();

  Stream<int> get timerStream => _timerStream.stream;

  void startTimer(int minutes) {
    if (_isRunning) return;
    _isRunning = true;
    _seconds = minutes * 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds--;
      _timerStream.add(_seconds);
      if (_seconds <= 0) {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    _isRunning = false;
    _timer.cancel();
    _timerStream.add(_seconds);
  }

  void resetTimer() {
    stopTimer();
    _seconds = 0;
    _timerStream.add(0);
  }

  void pauseTimer() {
    if (_isRunning) {
      _isRunning = false;
      _timer.cancel();
    }
  }

  void resumeTimer() {
    if (!_isRunning && _seconds > 0) {
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _seconds--;
        _timerStream.add(_seconds);
        if (_seconds <= 0) {
          stopTimer();
        }
      });
    }
  }

  bool get isRunning => _isRunning;
  int get seconds => _seconds;

  String getFormattedTime() {
    int minutes = _seconds ~/ 60;
    int secs = _seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void cleanup() {
    _timerStream.close();
    if (_isRunning) {
      _timer.cancel();
    }
  }
}
