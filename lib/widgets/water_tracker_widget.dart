import 'package:flutter/material.dart';
import '../services/water_tracker_service.dart';

class WaterTrackerWidget extends StatefulWidget {
  const WaterTrackerWidget({super.key});

  @override
  State<WaterTrackerWidget> createState() => _WaterTrackerWidgetState();
}

class _WaterTrackerWidgetState extends State<WaterTrackerWidget> {
  final waterService = WaterTrackerService();
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = waterService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
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
                  Colors.lightBlue.withOpacity(0.1),
                  Colors.cyan.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                final glasses = waterService.getGlassesToday();
                final progress = waterService.getProgress();
                final remaining = waterService.getRemainingGlasses();

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Water Intake',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$glasses / 8',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.cyan,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.cyan,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Glass Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        final isFilled = index < glasses;
                        return GestureDetector(
                          onTap: () {
                            if (isFilled) {
                              waterService.removeGlass();
                            } else {
                              waterService.addGlass();
                            }
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isFilled ? Colors.cyan : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.cyan,
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              Icons.local_drink,
                              color: isFilled ? Colors.white : Colors.grey,
                              size: 24,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      remaining == 0
                          ? '🎉 Goal Reached!'
                          : 'Keep drinking! $remaining glasses left',
                      style: TextStyle(
                        color: remaining == 0 ? Colors.green : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
