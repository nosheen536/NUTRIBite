import 'dart:ui'; // For ImageFilter.blur
import 'package:flutter/material.dart';

class MealPromoPage extends StatelessWidget {
  const MealPromoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No AppBar to keep it invisible
      body: Stack(
        fit:StackFit.expand,
        children: [
          // 1) Background image with blur
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                // Use AssetImage for local images; ensure path is in pubspec.yaml
                image: AssetImage('assets/images/mealpromo.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            // Apply blur over the background
             child:BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                  color: Color.fromRGBO(217, 233, 193, 0.50),// Dark overlay for readability
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
                  // a) Back Arrow
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(0, 0, 0, 0),
                      
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color.fromARGB(255, 19, 17, 17),
                        size: 33,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // b) Title using titleLarge (Material 3 style)
                   Center(
                  child : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Structured Plans OR \nExplore Recipes – Your Choice!',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: const Color.fromARGB(255, 10, 9, 9),
                              fontWeight: FontWeight.w900,
                              fontSize: 30, // Adjusting the font size for readability
                            ),
                           textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      
                      // c) Subheading using titleMedium (Material 3 style)
                      Text(
                        'Find Recipes "Get easy, nutritious recipes with ingredients you have."',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: const Color.fromARGB(248, 8, 8, 8),
                               fontWeight: FontWeight.w500,
                              fontSize: 21, // Adjusting the font size
                            ),
                            textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                   ),
                  const SizedBox(height: 15),

                  // d) Bullet points
                  Padding(padding: EdgeInsets.fromLTRB(30, 5,0, 5),
                  child:Column(
                    children: [
                      _buildBulletItem(
                        context,
                        'Follow a goal-based meal plan (Weight Loss, Muscle Gain, Balanced Diet).',
                      ),
                      _buildBulletItem(
                        context,
                        'Browse healthy, desi & Western recipes freely and find what you love!',
                      ),
                      _buildBulletItem(
                        context,
                        'Get ingredient substitutions & nutrition insights for better choices.',
                      ),
                    ],
                  ),
                  ),
                  const Spacer(),

                  Align(
                    alignment: Alignment.center,
                    child:  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        
                        Navigator.pushNamed(context, '/GetStartedPage');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(186, 216, 135, 1),
                        fixedSize: Size(150, 50),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: const Color.fromARGB(255, 12, 12, 11),width: 2),
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
                          fontWeight: FontWeight.bold,
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

  /// Builds a bullet-point style text widget.
  Widget _buildBulletItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '•  ',
            style: TextStyle(
              color: Color.fromARGB(255, 20, 19, 19),
              fontSize: 28,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.w600,
                    fontSize: 21, // Adjusting the font size for better readability
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
