class BMICalculatorService {
  static final BMICalculatorService _instance =
      BMICalculatorService._internal();

  factory BMICalculatorService() {
    return _instance;
  }

  BMICalculatorService._internal();

  double calculateBMI(double weightKg, double heightCm) {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  String getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'Normal Weight';
    } else if (bmi >= 25 && bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  String getBMIColor(double bmi) {
    if (bmi < 18.5) {
      return '#FF9800'; // Orange
    } else if (bmi >= 18.5 && bmi < 25) {
      return '#4CAF50'; // Green
    } else if (bmi >= 25 && bmi < 30) {
      return '#FFC107'; // Yellow
    } else {
      return '#F44336'; // Red
    }
  }

  String getHealthAdvice(double bmi) {
    if (bmi < 18.5) {
      return 'Consider eating more nutrient-rich foods and gaining weight healthily.';
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'Great! Maintain this healthy weight with regular exercise and balanced diet.';
    } else if (bmi >= 25 && bmi < 30) {
      return 'Try to increase physical activity and maintain a balanced diet.';
    } else {
      return 'Consider consulting a healthcare provider for personalized health plan.';
    }
  }
}
