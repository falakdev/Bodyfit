import 'package:flutter/material.dart';
import '../services/calorie_counter_service.dart';

class CalorieCounterWidget extends StatefulWidget {
  const CalorieCounterWidget({super.key});

  @override
  State<CalorieCounterWidget> createState() => _CalorieCounterWidgetState();
}

class _CalorieCounterWidgetState extends State<CalorieCounterWidget> {
  final calorieService = CalorieCounterService();
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = calorieService.initialize();
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
                  Colors.red.withOpacity(0.1),
                  Colors.orange.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ValueListenableBuilder<int>(
              valueListenable: calorieService.notifier,
              builder: (context, _, __) {
                final totalCals = calorieService.getTotalCalories();
                final progress = calorieService.getProgress();
                final foods = calorieService.getFoodsToday();

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Calorie Intake',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$totalCals / 2000',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.grey[300],
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Macros
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMacro(
                            'Protein',
                            '${calorieService.getTotalProtein()}g',
                            Colors.blue),
                        _buildMacro(
                            'Carbs',
                            '${calorieService.getTotalCarbs()}g',
                            Colors.orange),
                        _buildMacro('Fats', '${calorieService.getTotalFats()}g',
                            Colors.green),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Add Food Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => _showFoodPicker(context, setState),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Food'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Foods List
                    if (foods.isNotEmpty) ...[
                      const Divider(),
                      const Text(
                        'Today\'s Foods',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: foods.length,
                        itemBuilder: (context, index) {
                          final food = foods[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(food.name),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${food.calories} cal',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red, size: 20),
                                  onPressed: () {
                                    calorieService.removeFood(index);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildMacro(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  void _showFoodPicker(BuildContext context, StateSetter setState) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Food',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: CalorieCounterService.commonFoods.length,
                itemBuilder: (context, index) {
                  final food = CalorieCounterService.commonFoods[index];
                  return ListTile(
                    title: Text(food.name),
                    subtitle: Text('${food.calories} cal'),
                    trailing: const Icon(Icons.add),
                    onTap: () {
                      calorieService.addFood(food);
                      setState(() {});
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
