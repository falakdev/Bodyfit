import 'dart:math';

class MotivationQuotesService {
  static final MotivationQuotesService _instance =
      MotivationQuotesService._internal();

  factory MotivationQuotesService() {
    return _instance;
  }

  MotivationQuotesService._internal();

  static const List<String> quotes = [
    '"The only impossible journey is the one you never begin." - Tony Robbins',
    '"Success is not final, failure is not fatal." - Winston Churchill',
    '"Your body can stand almost anything. It\'s your mind that you need to convince." - Andrew Murphy',
    '"The greatest glory in living lies not in never falling, but in rising every time we fall." - Nelson Mandela',
    '"Fitness is not about being better than someone else. It\'s about being better than you used to be."',
    '"Don\'t watch the clock; do what it does. Keep going." - Sam Levenson',
    '"You don\'t have to see the whole staircase, just take the first step." - Martin Luther King Jr.',
    '"Health is a state of complete physical, mental and social well-being, not merely the absence of disease." - WHO',
    '"Take care of your body. It\'s the only place you have to live." - Jim Rohn',
    '"Exercise is a celebration of what your body can do. Not a punishment for what you ate."',
    '"Believe in yourself. You are braver than you think." - A.A. Milne',
    '"A fit body, a calm mind, a house full of love. These things cannot be bought." - Naval Ravikant',
    '"You are never too old to set another goal or to dream a new dream." - C.S. Lewis',
    '"The effort you put in now will pay off later."',
    '"Your health is an investment, not an expense."',
  ];

  String getRandomQuote() {
    return quotes[Random().nextInt(quotes.length)];
  }

  String getQuoteOfTheDay() {
    final today = DateTime.now().day;
    return quotes[today % quotes.length];
  }
}
