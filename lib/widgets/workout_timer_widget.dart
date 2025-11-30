import 'package:flutter/material.dart';
import '../services/workout_timer_service.dart';

class WorkoutTimerWidget extends StatefulWidget {
  const WorkoutTimerWidget({super.key});

  @override
  State<WorkoutTimerWidget> createState() => _WorkoutTimerWidgetState();
}

class _WorkoutTimerWidgetState extends State<WorkoutTimerWidget> {
  final timerService = WorkoutTimerService();
  int selectedMinutes = 1;
  final presetTimes = [1, 5, 10, 15, 30, 45, 60];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.orange.withOpacity(0.1),
              Colors.amber.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Workout Timer',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Timer Display
            StreamBuilder<int>(
              stream: timerService.timerStream,
              initialData: timerService.seconds,
              builder: (context, snapshot) {
                return Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange.withOpacity(0.2),
                    border: Border.all(
                      color: Colors.orange,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      timerService.getFormattedTime(),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Preset Time Buttons
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: presetTimes.map((minutes) {
                  final isSelected = selectedMinutes == minutes;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSelected ? Colors.orange : Colors.grey[300],
                        foregroundColor:
                            isSelected ? Colors.white : Colors.black,
                      ),
                      onPressed: !timerService.isRunning
                          ? () {
                              setState(() => selectedMinutes = minutes);
                            }
                          : null,
                      child: Text('${minutes}m'),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: timerService.isRunning
                      ? null
                      : () => timerService.startTimer(selectedMinutes),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: timerService.isRunning
                      ? () => timerService.pauseTimer()
                      : null,
                  icon: const Icon(Icons.pause),
                  label: const Text('Pause'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    timerService.resetTimer();
                    setState(() {});
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timerService.cleanup();
    super.dispose();
  }
}
