import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workqualitymonitoringsystem/constants/color_constants.dart';
import 'package:workqualitymonitoringsystem/screens/Login_screen/login_screen.dart';
import 'package:workqualitymonitoringsystem/screens/dashboard/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    login();
  }

  void login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool("isLoggedIn");

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isLoggedIn == true
              ? const DashboardScreen()
              : const LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     statusBarIconBrightness: Brightness.light,
    //     statusBarBrightness: Brightness.dark,
    //   ),
    // );

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // Sizes based purely on height and width
    final double avatarRadius = height * 0.15; // 15% of screen height
    final double glowRadius = height * 0.23; // 23% of screen height
    final double logoSize = width * 0.35; // 35% of screen width
    final double titleFont = height * 0.035; // font based on height
    final double subtitleFont = height * 0.025; // font based on height
    final double spacingSmall = height * 0.01;
    final double spacingMedium = height * 0.02;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AvatarGlow(
              glowColor: Colors.blue,
              endRadius: glowRadius,
              duration: const Duration(milliseconds: 1000),
              repeat: true,
              showTwoGlows: true,
              child: Material(
                elevation: 8.0,
                shape: const CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: avatarRadius,
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: logoSize,
                    height: logoSize,
                  ),
                ),
              ),
            ),
            SizedBox(height: spacingMedium),
            Text(
              'Work Quality Monitoring System',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleFont,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: spacingSmall),
            Text(
              'आपले स्वागत आहे!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: subtitleFont, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
