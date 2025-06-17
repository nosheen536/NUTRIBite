import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HydrationProgressScreen extends StatefulWidget {
  const HydrationProgressScreen({super.key});

  @override
  State<HydrationProgressScreen> createState() =>
      _HydrationProgressScreenState();
}

class _HydrationProgressScreenState extends State<HydrationProgressScreen> {
  Map<String, int> weeklyData = {};
  int todayIndex = 0;
  DateTime? startDate;
  Stream<DocumentSnapshot>? _hydrationStream;

  @override
  void initState() {
    super.initState();
    _setupRealTimeListener();
  }

  void _setupRealTimeListener() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    _hydrationStream = docRef.snapshots();

    _hydrationStream!.listen((snapshot) {
      if (!snapshot.exists) return;
      final data = snapshot.data() as Map<String, dynamic>? ?? {};
      final timestamp = data['firstUseDate'] as Timestamp?;
      if (timestamp != null) {
        startDate = timestamp.toDate();
        final now = DateTime.now();
        final duration = now.difference(startDate!);
        setState(() {
          todayIndex = duration.inHours ~/ 24 % 7;
        });
      }
    });
  }

  Future<void> _incrementGlass() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final dayKey = "Day${todayIndex + 1}";
    final docRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final newCount = (weeklyData[dayKey] ?? 0) + 1;

    await docRef.set({
      'hydration': {dayKey: newCount}
    }, SetOptions(merge: true));
  }

  Future<void> _resetTodayGlasses() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final dayKey = "Day${todayIndex + 1}";
    final docRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    await docRef.set({
      'hydration': {dayKey: 0}
    }, SetOptions(merge: true));
  }

  Future<void> _resetWeek() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    await docRef.update({
      'hydration': {}, // clear hydration map
      'firstUseDate': Timestamp.now(), // reset firstUseDate to today
    });

    setState(() {
      todayIndex = 0;
    });
  }

  String _getTip(int glasses) {
    if (glasses >= 8) return "🎉 Great job! You met your hydration goal!";
    if (glasses >= 5) return "👍 Almost there, keep sipping!";
    return "💧 Stay hydrated! Your body needs it.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.green.shade800),
        title: Text(
          "Hydration Progress",
          style: GoogleFonts.poppins(
            color: Colors.green.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _hydrationStream == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<DocumentSnapshot>(
              stream: _hydrationStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text("No data found."));
                }

                final data =
                    snapshot.data!.data() as Map<String, dynamic>? ?? {};
                final hydrationData =
                    data['hydration'] as Map<String, dynamic>? ?? {};

                weeklyData = {
                  for (int i = 1; i <= 7; i++)
                    'Day$i':
                        hydrationData['Day$i'] is int ? hydrationData['Day$i'] : 0
                };

                final todayKey = 'Day${todayIndex + 1}';
                final todayGlasses = weeklyData[todayKey] ?? 0;
                final double progress = min(todayGlasses / 8.0, 1.0);

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 160,
                            height: 160,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 12,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.lightBlueAccent,
                              ),
                            ),
                          ),
                          Text(
                            "${(progress * 100).toInt()}%",
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Glasses Today: $todayGlasses / 8",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _incrementGlass,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                        ),
                        child: Text(
                          "Add a Glass",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _resetTodayGlasses,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade300,
                        ),
                        child: Text(
                          "Reset Today's Glasses",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _resetWeek,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade300,
                        ),
                        child: Text(
                          "Reset Week",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Weekly Progress",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: List.generate(7, (i) {
                              final dayKey = 'Day${i + 1}';
                              final dayLabel = "Day ${i + 1}";
                              final isToday = dayKey == todayKey;
                              final glassCount = weeklyData[dayKey] ?? 0;

                              return Container(
                                width: 100,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isToday
                                      ? Colors.green.shade100
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      dayLabel,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.green.shade900,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "$glassCount glasses",
                                      style: GoogleFonts.poppins(fontSize: 14),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getTip(todayGlasses),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.green.shade800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
