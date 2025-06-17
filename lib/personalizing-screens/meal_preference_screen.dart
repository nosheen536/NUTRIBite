import 'package:flutter/material.dart';

class MealPreferenceScreen extends StatefulWidget {
  const MealPreferenceScreen({super.key});

  @override
  State<MealPreferenceScreen> createState() => _MealPreferenceScreenState();
}

class _MealPreferenceScreenState extends State<MealPreferenceScreen> {
  final Set<int> selectedIndices = {};

  final List<Map<String, String>> mealOptions = [
    {
      'label': 'Traditional/Home-cooked',
      'icon': 'assets/images/traditional_food.png',
      'feedback': 'Yes! Home-cooked meals are the way to the heart.',
    },
    {
      'label': 'Light & Fresh',
      'icon': 'assets/images/light&fresh.png',
      'feedback': 'Fresh and light — a perfect balance for wellness!',
    },
    {
      'label': 'Comfort/Fast Food style',
      'icon': 'assets/images/comfort_food.png',
      'feedback': 'Comfort food coming right up — tasty and quick!',
    },
    {
      'label': 'Trendy/Healthy',
      'icon': 'assets/images/trendy_healthy.png',
      'feedback': 'Trendy and healthy? You’re eating smart and stylish!',
    },
    {
      'label': 'All',
      'icon': 'assets/images/all_food.png',
      'feedback': 'A foodie at heart! Variety is the spice of life!',
    },
  ];

  void _handleSelection(int index) {
    setState(() {
      final isSelected = selectedIndices.contains(index);
      final isAllOption = index == mealOptions.length - 1;

      if (isSelected) {
        selectedIndices.remove(index);
      } else {
        if (isAllOption) {
          selectedIndices.clear();
          selectedIndices.add(index);
        } else {
          selectedIndices.remove(mealOptions.length - 1); // Remove 'All' if selected
          if (selectedIndices.length >= 2) {
            selectedIndices.remove(selectedIndices.first);
          }
          selectedIndices.add(index);
        }
      }
    });
  }

  void _onNextPressed() {
    if (selectedIndices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one option.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      Navigator.pushNamed(context, '/cookingtimescreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
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
          // Foreground content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(60, 20, 30, 10),
                        child: const Text(
                          'Personalize Your \n\t\t\t\t Journey ☀️',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
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
                      const SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.fromLTRB(14, 5, 1, 10),
                        child: const Text(
                          "What's your favorite type of \nmeal?",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Meal Options
                      ...List.generate(mealOptions.length, (index) {
                        final selected = selectedIndices.contains(index);
                        final data = mealOptions[index];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => _handleSelection(index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? const Color.fromARGB(240, 28, 85, 20)
                                          .withAlpha(40)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      data['icon']!,
                                      height: 30,
                                      width: 30,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      data['label']!,
                                      style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (selected)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 32, top: 4, bottom: 8),
                                child: AnimatedOpacity(
                                  opacity: 1.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Text(
                                    data['feedback']!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:
                                          const Color.fromARGB(255, 77, 167, 80),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),

                      const SizedBox(height: 20),

                      Padding(
                        padding: EdgeInsets.fromLTRB(11, 10, 5, 10),
                        child: const Text(
                          '✨ Your taste matters! Let’s find delicious meals that feel just like home – or as adventurous as you like!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Padding(
                        padding: EdgeInsets.fromLTRB(190, 0, 0, 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(186, 216, 135, 1),
                            foregroundColor: Colors.black,
                            side: BorderSide(
                                color: Color.fromARGB(255, 13, 14, 13),
                                width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _onNextPressed,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
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
            ),
          )
        ],
      ),
    );
  }
}
