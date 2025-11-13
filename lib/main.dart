import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'logic/step_provider.dart';
import 'logic/auth_provider.dart';
import 'logic/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with options
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    // App will continue to work but Firebase features won't be available
  }
  
  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool("onboarding_done") ?? false;

  runApp(MyApp(seenOnboarding: seenOnboarding));
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;
  const MyApp({super.key, this.seenOnboarding = false});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StepProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()..tryAutoLogin()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          // Sync AppColors.isDarkMode with theme provider
          AppColors.isDarkMode = themeProvider.isDarkMode;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: Consumer<AuthProvider>(
              builder: (_, auth, __) {
                if (auth.isAuthenticated) {
                  return const MainNavigation();
                }
                return seenOnboarding
                    ? const LoginScreen()
                    : OnboardingScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
