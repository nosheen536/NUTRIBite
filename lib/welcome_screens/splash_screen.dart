import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to WelcomePage after 5 seconds
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/GuidePage');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5F6E5), // Soft mint green
      body: Container(
        decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(245, 255, 235, 1),
                    Color.fromRGBO(210, 235, 175, 1),
                  ],
                ),
              ),
      child:const SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'NUTRIBite',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  color: Color(0xFF1B4332), // Deep green shade
                  fontFamily: 'Roboto', // or 'Montserrat' if using Google Fonts
                ),
              ),
              SizedBox(height: 24),
              Image(
                image: AssetImage('assets/images/logo.png'),
                width: 180,
                height: 180,
              ),
              SizedBox(height: 24),
              Text(
                'Smart Nutrition, Better You',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF2D6A4F), // Gentle green for subtitle
                ),
              ),
            ],
          ),
        ),
      ),
      )
    );
  }
}