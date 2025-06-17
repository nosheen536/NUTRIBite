import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CookingTimeScreen extends StatefulWidget {
  const CookingTimeScreen({super.key});

  @override
  State<CookingTimeScreen> createState() => _CookingTimeScreenState();
}

class _CookingTimeScreenState extends State<CookingTimeScreen> {
  int? selectedOption;

  final List<String> cookingTimes = [
    'Less than 15 minutes',
    '15–30 minutes',
    'More than 30 minutes',
  ];

 void _onNextPressed() async {
  if (selectedOption == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select at least one option.'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  } else {
    final prefs = await SharedPreferences.getInstance();
    final showMealPlanner = prefs.getBool('showMealPlannerAfterPersonalize') ?? false;

    if (showMealPlanner) {
      await prefs.remove('showMealPlannerAfterPersonalize');
      Navigator.pushReplacementNamed(context, '/mealplanner');
    } else {
      Navigator.pushReplacementNamed(context, '/homescreen');
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✅ Background Image
          Positioned.fill(
           child: Container(
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
            ),
          ),
          // ✅ Optional overlay
          Container(
            color: const Color(0x88F5FCEB),
          ),

          // ✅ Scrollable Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.fromLTRB(60, 20, 30, 10),
                    child: const Text(
                      'Personalize Your \n\t\t\t\t Journey  ☀️',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.fromLTRB(40, 10, 20, 5),
                    child: const Text(
                      "Let's get to know you better!",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.fromLTRB(14, 5, 1, 10),
                    child: const Text(
                      'How much time do you usually\nhave for cooking daily?',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Time options
                  ...List.generate(cookingTimes.length, (index) {
                    final isSelected = selectedOption == index;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedOption =
                                  selectedOption == index ? null : index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color.fromARGB(240, 28, 85, 20)
                                      .withAlpha(40)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: Colors.black87,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  cookingTimes[index],
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 20),

                  // Next Button
                  Padding(
                    padding: EdgeInsets.fromLTRB(190, 140, 0, 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(186, 216, 135, 1),
                        foregroundColor: Colors.black,
                        side: BorderSide(
                            color: Color.fromARGB(255, 13, 14, 13), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _onNextPressed,
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Text(
                          'Next',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800),
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
