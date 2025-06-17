
 import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async'; // <-- Added for Timer
import 'package:flutter/services.dart'; // <-- Added for SystemNavigator.pop()

class MealPlanScreen extends StatefulWidget {
  final int? initialDayIndex;

  const MealPlanScreen({
    super.key,
    this.initialDayIndex,
  });

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  int selectedDayIndex = 0;
  int waterCups = 6;

  Map<String, dynamic> mealPlanData = {};
  bool isLoading = true;
  bool isPlanCompleted = false;

  String goal = '';
  String planDuration = '';

  DateTime? _lastBackPressed; // <-- Track last back press time

  @override
  void initState() {
    super.initState();
    loadUserPreferencesAndFetchPlan();
  }

  Future<void> loadUserPreferencesAndFetchPlan() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final userDoc = await userRef.get();
    final userData = userDoc.data();

    if (userData != null &&
        userData.containsKey('goal') &&
        userData.containsKey('planDuration')) {
      goal = userData['goal'];
      planDuration = userData['planDuration'];

      if (!userData.containsKey('planStartDate') || userData['planStartDate'] == null) {
        await userRef.update({
          'planStartDate': Timestamp.now(),
        });
        selectedDayIndex = 0;
      } else {
        final Timestamp startTimestamp = userData['planStartDate'];
        final DateTime startDate = startTimestamp.toDate();
        final daysPassed = DateTime.now().difference(startDate).inDays;

        final maxIndex = planDuration == '7dayPlan' ? 6 : 2;

        if (daysPassed > maxIndex) {
          setState(() {
            isPlanCompleted = true;
            isLoading = false;
          });
          return;
        }

        selectedDayIndex = widget.initialDayIndex ?? daysPassed;
      }

      await fetchMealPlan();
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchMealPlan() async {
    final doc = await FirebaseFirestore.instance
        .collection('mealPlans')
        .doc(goal)
        .get();

    if (doc.exists && doc.data()!.containsKey(planDuration)) {
      setState(() {
        mealPlanData = doc.data()![planDuration];
      });
    }
  }

  List<String> get currentDays =>
      planDuration == '7dayPlan'
          ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
          : ['Day 1', 'Day 2', 'Day 3'];

  String get firestoreDayKey => 'day${selectedDayIndex + 1}';

  List<Map<String, dynamic>> _getMeals(String mealType) {
    final day = mealPlanData[firestoreDayKey];
    if (day == null || !day.containsKey(mealType)) return [];

    final meals = day[mealType];
    if (meals is List) {
      return meals.map<Map<String, dynamic>>((e) {
        if (e is String) {
          return {
            'id': e,
            'title': e,
            'image': 'assets/images/placeholder.jpg',
          };
        }
        return e;
      }).toList();
    }
    return [];
  }

  void _navigateToRecipeDetail(String recipeId) {
    Navigator.pushNamed(
      context,
      '/detailRecipe',
      arguments: recipeId,
    );
  }

  String _formatGoal(String goalKey) {
    switch (goalKey) {
      case 'weightLoss':
        return 'Weight Loss';
      case 'muscleGain':
        return 'Muscle Gain';
      case 'weightMaintenance':
        return 'Weight Maintenance';
      default:
        return goalKey;
    }
  }

  Future<void> _resetPlanAndNavigate() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Reset plan-related fields in Firestore
    await userRef.update({
      'planStartDate': null,
      'goal': null,
      'planDuration': null,
    });

    // Set flag to show meal planner after personalize
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showMealPlannerAfterPersonalize', true);

    // Navigate to personalize screen
    final result = await Navigator.pushNamed(context, '/personalizehealth');

    if (result == true) {
      // Check if goal and planDuration are now set
      final newUserDoc = await userRef.get();
      final newUserData = newUserDoc.data();
      if (newUserData != null &&
          newUserData.containsKey('goal') &&
          newUserData.containsKey('planDuration')) {
        await userRef.update({
          'planStartDate': Timestamp.now(),
        });
      }

      // Reload plan after personalization
      setState(() {
        selectedDayIndex = 0;
        isLoading = true;
        isPlanCompleted = false;
      });
      await loadUserPreferencesAndFetchPlan();
    }
  }
int _backPressCount = 0;

 @override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async {
      
  final now = DateTime.now();

  // Reset if more than 3 seconds passed
  if (_lastBackPressed == null || now.difference(_lastBackPressed!) > const Duration(seconds: 3)) {
    _backPressCount = 0;
  }

  _lastBackPressed = now;
  _backPressCount++;

  if (_backPressCount == 1) {
    Navigator.pushReplacementNamed(context, '/homescreen');
    return false;
  } else if (_backPressCount == 2) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Press back again to exit'),
        duration: Duration(seconds: 2),
      ),
    );
    return false;
  } else {
    SystemNavigator.pop();
    return false;
  }

    },
      child: isLoading
          ? Scaffold(
              backgroundColor: const Color(0xFFFDFBF5),
              body: SafeArea(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          : isPlanCompleted
              ? Scaffold(
                  backgroundColor: const Color(0xFFFDFBF5),
                  body: SafeArea(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "🎉 Congratulations! 🎉",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "You’ve successfully completed your meal plan. Amazing job staying committed to your health journey!",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 28),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              onPressed: _resetPlanAndNavigate,
                              child: const Text(
                                "Start a New Plan",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Scaffold(
                  backgroundColor: const Color(0xFFE5F6E5),
                  body: SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${_formatGoal(goal)} Meal Plan",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "You've got this! Stick to your plan and stay healthy 💪",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 32,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: currentDays.length,
                              itemBuilder: (context, index) {
                                final day = currentDays[index];
                                final isSelected = index == selectedDayIndex;
                                return GestureDetector(
                                  onTap: () => setState(() => selectedDayIndex = index),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.green.shade100
                                          : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected ? Colors.green : Colors.transparent,
                                      ),
                                    ),
                                    child: Text(
                                      day,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.green.shade800
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...['breakfast', 'lunch', 'dinner', 'snacks'].map((mealType) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      mealType[0].toUpperCase() + mealType.substring(1),
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ..._getMeals(mealType)
                                      .map((meal) => _mealCard(meal))
                                      .toList(),
                                  const SizedBox(height: 20),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _mealCard(Map<String, dynamic> meal) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _navigateToRecipeDetail(meal['id']),
          child: Container(
            height: 134,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 6, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          meal['dietaryType'] != null
                              ? '${meal['dietaryType']} | ${meal['totalTime'] ?? ''}'
                              : meal['id'],
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            _actionButton('View', meal['id']),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    topLeft: Radius.circular(80),
                    bottomLeft: Radius.circular(80),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: meal['image'],
                    width: 105,
                    height: 128,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 120,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 120,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton(String label, String mealId) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: OutlinedButton(
        onPressed: label == 'View'
            ? () {
                Navigator.pushNamed(
                  context,
                  '/detailRecipe',
                  arguments: mealId,
                );
              }
            : null,
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFFE5F6E5),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0.3),
          side: const BorderSide(color: Colors.black12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
