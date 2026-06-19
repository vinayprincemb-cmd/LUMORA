// main.dart
// FINAL STABLE VERSION
// ✅ SPLASH SCREEN
// ✅ ONBOARDING
// ✅ FUTURE MESSAGE NOTIFICATIONS
// ✅ DAILY MOTIVATION QUOTES
// ✅ NAVIGATOR KEY CONNECTED
// ✅ PLAYSTORE READY
// ✅ ANDROID 13+ READY

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'notification_service.dart';
import 'onboarding_screen.dart';
import 'splash_screen.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // =====================================================
  // INITIALIZE NOTIFICATIONS
  // =====================================================

  await NotificationService.init();

  // =====================================================
  // START APP
  // =====================================================

  runApp(const LumoraApp());
}

class LumoraApp extends StatelessWidget {
  const LumoraApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'LUMORA',

      // IMPORTANT FOR NOTIFICATION NAVIGATION

      navigatorKey: navigatorKey,

      theme: ThemeData(

        useMaterial3: true,

        fontFamily: 'Poppins',

        scaffoldBackgroundColor:
            const Color(0xFFF6F1FF),

        colorScheme: ColorScheme.fromSeed(

          seedColor:
              const Color(0xFF7B1FFF),
        ),
      ),

      // SPLASH FIRST

      home: const SplashScreen(),
    );
  }
}

// =====================================================
// APP STARTER
// =====================================================

class AppStarter extends StatefulWidget {
  const AppStarter({super.key});

  @override
  State<AppStarter> createState() =>
      _AppStarterState();
}

class _AppStarterState
    extends State<AppStarter> {

  bool isLoading = true;

  bool seenOnboarding = false;

  @override
  void initState() {

    super.initState();

    loadApp();
  }

  Future<void> loadApp() async {

    final prefs =
        await SharedPreferences
            .getInstance();

    seenOnboarding =
        prefs.getBool(
          'seenOnboarding',
        ) ??
        false;

    if (mounted) {

      setState(() {

        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    // =====================================================
    // LOADING
    // =====================================================

    if (isLoading) {

      return const Scaffold(

        backgroundColor:
            Color(0xFFF6F1FF),

        body: Center(

          child: CircularProgressIndicator(

            color:
                Color(0xFF7B1FFF),
          ),
        ),
      );
    }

    // =====================================================
    // ONBOARDING
    // =====================================================

    if (!seenOnboarding) {

      return const OnboardingScreen();
    }

    // =====================================================
    // HOME
    // =====================================================

    return const HomeScreen();
  }
}