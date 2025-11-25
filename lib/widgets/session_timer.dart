import 'dart:async';

import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class SessionTimer extends StatefulWidget {
  final int minutes;
  const SessionTimer({super.key, this.minutes = 20});

  @override
  State<SessionTimer> createState() => _SessionTimerState();
}

class _SessionTimerState extends State<SessionTimer> {
  late int remainingSeconds;
  Timer? _timer;
  bool running = false;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.minutes * 60;
  }

  void _start() {
    if (running) return;
    setState(() => running = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds <= 0) {
        t.cancel();
        setState(() => running = false);
        return;
      }
      setState(() => remainingSeconds -= 1);
    });
  }

  void _pause() {
    _timer?.cancel();
    _timer = null;
    setState(() => running = false);
  }

  void _reset() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      running = false;
      remainingSeconds = widget.minutes * 60;
    });
  }

  String _format(int s) {
    final mm = (s ~/ 60).toString().padLeft(2, '0');
    final ss = (s % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = 1 - (remainingSeconds / (widget.minutes * 60));
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 140,
              height: 140,
              child: CircularProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                strokeWidth: 10,
                color: AppColors.primary,
                backgroundColor: Colors.white12,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_format(remainingSeconds), style: TextStyle(color: AppColors.textPrimary, fontSize: 20)),
                const SizedBox(height: 6),
                Text('${widget.minutes} min', style: TextStyle(color: Colors.white54)),
              ],
            ),
          ],
        ),

        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: running ? _pause : _start,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: Text(running ? 'Pause' : 'Start'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _reset,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white12),
              child: const Text('Reset'),
            ),
          ],
        )
      ],
    );
  }
}
