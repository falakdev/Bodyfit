import 'package:flutter/material.dart';
import '../services/achievements_service.dart';
import '../services/motivation_quotes_service.dart';
import '../services/bmi_calculator_service.dart';

class AllFeaturesWidget extends StatefulWidget {
  const AllFeaturesWidget({super.key});

  @override
  State<AllFeaturesWidget> createState() => _AllFeaturesWidgetState();
}

class _AllFeaturesWidgetState extends State<AllFeaturesWidget> {
  final achievementsService = AchievementsService();
  final quotesService = MotivationQuotesService();
  final bmiService = BMICalculatorService();

  late Future<void> _initFuture;
  int _selectedTab = 0;
  double _bmiWeight = 70.0;
  double _bmiHeight = 170.0;

  @override
  void initState() {
    super.initState();
    _initFuture = achievementsService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Tab Selector
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTabButton('🏆 Achievements', 0),
                  _buildTabButton('💬 Quotes', 1),
                  _buildTabButton('⚖️ BMI', 2),
                ],
              ),
            ),
            // Content
            Expanded(
              child: PageView(
                onPageChanged: (index) => setState(() => _selectedTab = index),
                children: [
                  _buildAchievementsView(),
                  _buildQuotesView(),
                  _buildBMIView(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = _selectedTab == index;
    return InkWell(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementsView() {
    final achievements = achievementsService.getAchievements();
    final unlockedCount = achievementsService.getUnlockedCount();

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Achievements',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$unlockedCount / ${achievements.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  final achievement = achievements[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: achievement.isUnlocked
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: achievement.isUnlocked
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(achievement.icon, style: const TextStyle(fontSize: 32)),
                        const SizedBox(height: 8),
                        Text(
                          achievement.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          achievement.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 10),
                        ),
                        const SizedBox(height: 8),
                        if (achievement.isUnlocked)
                          const Icon(Icons.check_circle,
                              color: Colors.blue, size: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuotesView() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Daily Motivation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple),
              ),
              child: Text(
                quotesService.getQuoteOfTheDay(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              onPressed: () => setState(() {}),
              icon: const Icon(Icons.refresh),
              label: const Text('Get New Quote'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBMIView() {
    final bmi = bmiService.calculateBMI(_bmiWeight, _bmiHeight);
    final category = bmiService.getBMICategory(bmi);
    final advice = bmiService.getHealthAdvice(bmi);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'BMI Calculator',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Weight Slider
            Text('Weight: ${_bmiWeight.toStringAsFixed(1)} kg'),
            Slider(
              value: _bmiWeight,
              min: 30,
              max: 150,
              onChanged: (value) => setState(() => _bmiWeight = value),
            ),
            const SizedBox(height: 20),
            // Height Slider
            Text('Height: ${_bmiHeight.toStringAsFixed(1)} cm'),
            Slider(
              value: _bmiHeight,
              min: 100,
              max: 250,
              onChanged: (value) => setState(() => _bmiHeight = value),
            ),
            const SizedBox(height: 30),
            // BMI Result
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Your BMI',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bmi.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                advice,
                style: const TextStyle(fontSize: 14, height: 1.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
