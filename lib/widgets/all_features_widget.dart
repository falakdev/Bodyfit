import 'package:flutter/material.dart';
import '../services/motivation_quotes_service.dart';
import '../services/bmi_calculator_service.dart';

class AllFeaturesWidget extends StatefulWidget {
  const AllFeaturesWidget({super.key});

  @override
  State<AllFeaturesWidget> createState() => _AllFeaturesWidgetState();
}

class _AllFeaturesWidgetState extends State<AllFeaturesWidget> {
  final quotesService = MotivationQuotesService();
  final bmiService = BMICalculatorService();

  late Future<void> _initFuture;
  int _selectedTab = 0;
  double _bmiWeight = 70.0;
  double _bmiHeight = 170.0;
  String _currentQuote = '';
  bool _isLoadingQuote = false;

  @override
  void initState() {
    super.initState();
    _currentQuote = quotesService.getQuoteOfTheDay();
    _initFuture = Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // Tab Selector
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTabButton('💬 Quotes', 0),
                    _buildTabButton('⚖️ BMI', 1),
                  ],
                ),
              ),
              // Content based on selected tab
              if (_selectedTab == 0) _buildQuotesView() else _buildBMIView(),
            ],
          ),
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

  // Achievements removed per request

  Widget _buildQuotesView() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Daily Motivation',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple, width: 1),
              ),
              child: _isLoadingQuote
                  ? const SizedBox(
                      height: 50,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Text(
                      _currentQuote.isNotEmpty
                          ? _currentQuote
                          : quotesService.getQuoteOfTheDay(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                    ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onPressed: _isLoadingQuote ? null : _fetchNewQuote,
              icon: const Icon(Icons.refresh, size: 16),
              label:
                  const Text('Get New Quote', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchNewQuote() async {
    setState(() => _isLoadingQuote = true);
    try {
      final newQuote = await quotesService.getGeminiMotivationQuote();
      if (mounted) {
        setState(() {
          _currentQuote = newQuote;
          _isLoadingQuote = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingQuote = false);
      }
      // Silently fallback to random quote on error
    }
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
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
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
