import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../services/water_tracker_service.dart';

class WaterTrackerWidget extends StatefulWidget {
  const WaterTrackerWidget({super.key});

  @override
  State<WaterTrackerWidget> createState() => _WaterTrackerWidgetState();
}

class _WaterTrackerWidgetState extends State<WaterTrackerWidget>
    with SingleTickerProviderStateMixin {
  final waterService = WaterTrackerService();
  late Future<void> _initFuture;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _initFuture = waterService.initialize();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _updateAndAnimate(VoidCallback fn) {
    fn();
    _animController.forward(from: 0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final glasses = waterService.getGlassesToday();
        final progress = waterService.getProgress();
        final remaining = waterService.getRemainingGlasses();

        return Card(
          elevation: 6,
          margin: const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Water Intake',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$glasses / 8 glasses',
                            style: TextStyle(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _updateAndAnimate(() => waterService.resetDay());
                      },
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Reset',
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Circular tracker
                SizedBox(
                  height: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // animated circular progress
                      AnimatedBuilder(
                        animation: _animController,
                        builder: (context, child) {
                          final animValue =
                              Curves.easeOut.transform(_animController.value);
                          final displayProgress =
                              (progress * animValue).clamp(0.0, 1.0);
                          return CustomPaint(
                            size: const Size(180, 180),
                            painter: _CirclePainter(displayProgress),
                          );
                        },
                      ),
                      // center text
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${(glasses * 250)} ml',
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 14),
                          ),
                        ],
                      ),
                      // glasses icons around
                      Positioned.fill(
                        child: LayoutBuilder(builder: (context, box) {
                          final radius =
                              math.min(box.maxWidth, box.maxHeight) / 2 - 20;
                          return Stack(
                            children: List.generate(8, (i) {
                              final angle = (i / 8) * 2 * math.pi - math.pi / 2;
                              final x = box.maxWidth / 2 +
                                  radius * math.cos(angle) -
                                  16;
                              final y = box.maxHeight / 2 +
                                  radius * math.sin(angle) -
                                  16;
                              final isFilled = i < glasses;
                              return Positioned(
                                left: x,
                                top: y,
                                child: GestureDetector(
                                  onTap: () {
                                    if (isFilled) {
                                      _updateAndAnimate(
                                          () => waterService.removeGlass());
                                    } else {
                                      _updateAndAnimate(
                                          () => waterService.addGlass());
                                    }
                                  },
                                  child: _GlassDot(isFilled: isFilled),
                                ),
                              );
                            }),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  remaining == 0
                      ? '🎉 Goal Reached!'
                      : '$remaining glasses left',
                  style: TextStyle(
                      color: remaining == 0 ? Colors.green : Colors.grey[600],
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () =>
                          _updateAndAnimate(() => waterService.addGlass()),
                      icon: const Icon(Icons.add),
                      label: const Text('Add'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () =>
                          _updateAndAnimate(() => waterService.removeGlass()),
                      icon: const Icon(Icons.remove),
                      label: const Text('Remove'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GlassDot extends StatelessWidget {
  final bool isFilled;
  const _GlassDot({required this.isFilled});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isFilled ? Colors.blueAccent : Colors.white,
        border: Border.all(color: Colors.blueAccent, width: 2),
        borderRadius: BorderRadius.circular(8),
        boxShadow: isFilled
            ? [
                BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.2), blurRadius: 6)
              ]
            : [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Icon(
        Icons.local_drink,
        size: 18,
        color: isFilled ? Colors.white : Colors.blueAccent,
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final double progress; // 0.0 - 1.0
  _CirclePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;

    final basePaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final progPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: -math.pi / 2 + 2 * math.pi * progress,
        colors: [Colors.cyanAccent, Colors.blueAccent],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, basePaint);

    final startAngle = -math.pi / 2;
    final sweep = 2 * math.pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        sweep, false, progPaint);
  }

  @override
  bool shouldRepaint(covariant _CirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
