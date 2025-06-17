
import 'dart:ui';

import 'package:flutter/material.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No AppBar - invisible top with back arrow manually placed
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1) Background image from assets with blur
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/getstarted.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
             child:BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                color: Color.fromRGBO(217, 233, 193, 0.50), // Slightly darker for better readability
              ),
            ),
          ),
          
          // 2) Foreground UI
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // a) Back arrow
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(0, 0, 0, 0),
                      
                      ),
                      child: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 20, 19, 19),size: 33,),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // b) Title with headline4 style
                  Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Start Your Healthy Journey!',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: const Color.fromARGB(255, 14, 13, 13),
                              fontSize: 30,
                            ),
                        textAlign: TextAlign.center, // Ensures the title is centered
                      ),
                      const SizedBox(height: 15),
                      
                      // c) Subtitle with subtitle1 style
                      Text(
                        'Your Health, Your Way!',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(247, 5, 5, 5),
                              fontSize: 25,
                            ),
                        textAlign: TextAlign.center, // Subtitle centered
                      ),
                    ],
                  ),
                  ),
                  const SizedBox(height: 28),

                  // d) Text box with a description
                  Center(
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 900,
                        
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 28,25, 0),
                          child: 
                            const Text(
                              'Join NutriBite and start eating healthier, tastier, and smarter—with real, balanced meal plans made for YOU.',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              textAlign: TextAlign.center, // Text centered within the box
                            ),
                       
                        ),
                      ),
                    ],
                  ),
                  ),
                  const Spacer(),

                  // e) "Get Started" Button
                  Align(
                    alignment: Alignment.center,
                    child:  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        
                        Navigator.pushNamed(context, '/signup');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(186, 216, 135, 1),
                        fixedSize: Size(220, 55),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: const Color.fromARGB(255, 13, 14, 12),width: 2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                      'Get Started',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(234, 17, 16, 16),
                          fontWeight: FontWeight.w800,
                        ),
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
