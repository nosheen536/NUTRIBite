import 'dart:ui'; // For ImageFilter.blur
import 'package:flutter/material.dart';

class DietPlanPage extends StatelessWidget {
  const DietPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No AppBar, so it won’t be visible or have elevation
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1) Background image with blur
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                // Replace the image path with your own local asset
                image: AssetImage('assets/images/dietplan.jpeg'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
             child:BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
  // Transparent overlay with 25% opacity
              child: Container(
                // Update the overlay color with Color.fromARGB
                 color: Color.fromRGBO(217, 233, 193, 0.50), // 76 is the alpha for 30% opacity, black color
              ),
            ),
          ),
          

          // 2) Foreground content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2a) Back Arrow in top-left corner
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(0, 0, 0, 0),
                      
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color.fromARGB(255, 15, 14, 14),
                        size: 33,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2b) Main title
                  Center(  
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Say Goodbye to unrealistic diet plans!',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: const Color.fromARGB(255, 10, 9, 9),
                              fontWeight: FontWeight.w900,
                              fontSize: 30
                            ),
                            textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 35),
                      
                      // 2c) Description
                      SizedBox(
                        width: 800,
                      child:Text(
                        'NUTRIBite helps you achieve your health goals with balanced, culturally relevant meal plans and delicious recipes tailored to your lifestyle.',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: const Color.fromARGB(246, 10, 10, 10),
                               fontWeight: FontWeight.w500,
                              fontSize: 23,
                            ),
                             textAlign: TextAlign.center,
                      ),
                      ),
                    ],
                  ),
                  ),
                  const Spacer(),

                  // 2d) Next Button
                 Align(
                    alignment: Alignment.center,
                    child:  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        
                        Navigator.pushNamed(context, '/MealPromoPage');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(186, 216, 135, 1),
                        fixedSize: Size(150, 50),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: const Color.fromARGB(255, 10, 10, 9),width: 2),
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
