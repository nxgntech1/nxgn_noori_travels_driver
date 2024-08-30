import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'controller/settings_controller.dart';
import 'on_boarding_screen.dart';
import 'page/auth_screens/login_screen.dart';
import 'page/dash_board.dart';
import 'utils/Preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SettingsController settingsController = Get.put(SettingsController());
  @override
  void initState() {
    super.initState();
    settingsController.getSettingsData();
    // Delay for 1.5 seconds before navigating to the next screen
    Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
      _navigateToNextScreen();
    });
  }

  void _navigateToNextScreen() {
    if (Preferences.getBoolean(Preferences.isFinishOnBoardingKey)) {
      if (Preferences.getBoolean(Preferences.isLogin)) {
        Get.off(() => DashBoard());
      } else {
        Get.off(() => const LoginScreen());
      }
    } else {
      Get.off(() => const OnBoardingScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Center(
          child: Image.asset(
            'assets/images/noori-logo-splash.png',
            height: 150,
          ),
        ),
      ),
    );
  }
}
