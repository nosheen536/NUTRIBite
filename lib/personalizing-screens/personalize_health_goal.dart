import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomizeMealScreen extends StatefulWidget {
  const CustomizeMealScreen({super.key});

  @override
  State<CustomizeMealScreen> createState() => _CustomizeMealScreenState();
}

class _CustomizeMealScreenState extends State<CustomizeMealScreen> {
  final List<String> mealPlanOptions = ['3-Day Plan', '7-Day Plan'];
  final List<String> healthGoals = ['Weight Loss', 'Muscle Gain', 'Weight Maintenance'];

  String? selectedMealPlan;
  String? selectedHealthGoal;

  String _mapGoalToKey(String goal) {
    switch (goal) {
      case 'Weight Loss':
        return 'weightLoss';
      case 'Muscle Gain':
        return 'muscleGain';
      case 'Weight Maintenance':
        return 'weightMaintenance';
      default:
        return 'weightLoss';
    }
  }

  String _mapPlanDurationToKey(String duration) {
    switch (duration) {
      case '3-Day Plan':
        return '3dayPlan';
      case '7-Day Plan':
        return '7dayPlan';
      default:
        return '3dayPlan';
    }
  }

  Future<void> _savePreferences() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final goalKey = _mapGoalToKey(selectedHealthGoal!);
      final planDurationKey = _mapPlanDurationToKey(selectedMealPlan!);

      final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      await docRef.set({
        'goal': goalKey,
        'planDuration': planDurationKey,
      }, SetOptions(merge: true));

      Navigator.pushNamed(context, '/foodpreference');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
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
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Personalize Your Journey",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Serif',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Tell us a bit about yourself to get\ncustomized meal plans!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Sans',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    const LabelText(label: "Meal Plan Duration"),
                    const SizedBox(height: 5),
                    DropdownBox(
                      items: mealPlanOptions,
                      value: selectedMealPlan,
                      onChanged: (value) {
                        setState(() {
                          selectedMealPlan = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const LabelText(label: "Health Goal"),
                    const SizedBox(height: 5),
                    DropdownBox(
                      items: healthGoals,
                      value: selectedHealthGoal,
                      onChanged: (value) {
                        setState(() {
                          selectedHealthGoal = value;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(186, 216, 135, 1),
                        side: const BorderSide(color: Color.fromARGB(255, 13, 14, 13), width: 2),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      onPressed: () {
                        if (selectedMealPlan != null && selectedHealthGoal != null) {
                          _savePreferences();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill out all fields before continuing.'),
                              backgroundColor: Colors.redAccent,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Save & Continue",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Serif',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Supporting UI components

class LabelText extends StatelessWidget {
  final String label;
  const LabelText({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 18,
        fontFamily: 'Serif',
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class DropdownBox extends StatelessWidget {
  final List<String> items;
  final String? value;
  final void Function(String?)? onChanged;

  const DropdownBox({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: const Text("Select"),
          isExpanded: true,
          dropdownColor: const Color.fromRGBO(240, 255, 230, 1),
          borderRadius: BorderRadius.circular(12),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(fontFamily: 'Sans', fontSize: 16),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
