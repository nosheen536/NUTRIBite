
import 'dart:ui';

import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
  // Background Image
  Image.asset(
    'assets/images/welcomescreen.jpeg',
    fit: BoxFit.cover,
  ),
   BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
  // Transparent overlay with 25% opacity
  child:Container(
    color: Color.fromRGBO(217, 233, 193, 0.50), // 25% opacity
),
   ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text content
                  Column(
                    children: const [
                      SizedBox(height: 80),
                      Text(
                        'Welcome to NutriBite!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize:30,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 12, 12, 12),
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Healthy Eating, Made Real & Easy!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 23,
                          color: Color.fromARGB(255, 10, 10, 10),
                           fontWeight: FontWeight.w600,
                           fontStyle: FontStyle.italic,
                        ),
                      ),
                       SizedBox(height: 25),
                      Text(
                        'Discover healthy meal plans tailored for you',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 5, 5, 5),
                           fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // Button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: ElevatedButton(
                      onPressed: () {
                        
                        Navigator.pushNamed(context, '/GuidePage');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(186, 216, 135, 1),
                        fixedSize: Size(150, 50),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: const Color.fromARGB(255, 7, 7, 7),width: 2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(234, 17, 16, 16),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
