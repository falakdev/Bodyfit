import 'package:flutter/material.dart';
import '../services/step_counter_service.dart';

class StepCounterWidget extends StatefulWidget {
  const StepCounterWidget({super.key});

  @override
  State<StepCounterWidget> createState() => _StepCounterWidgetState();
}

class _StepCounterWidgetState extends State<StepCounterWidget> {
  final stepService = StepCounterService();
  int _steps = 0;
  late Stream<int> _stepStream;

  @override
  void initState() {
    super.initState();
    _stepStream = stepService.getStepStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _stepStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _steps = snapshot.data ?? 0;
        }

        return Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.1),
                  Colors.blue.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.directions_walk,
                  size: 48,
                  color: Colors.blue,
                ),
                const SizedBox(height: 12),
                Text(
                  '$_steps',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Steps Today',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
