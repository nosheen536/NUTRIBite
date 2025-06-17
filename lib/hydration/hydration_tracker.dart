import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String> getCustomTodayKey() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return 'Day1';

  final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
  final snapshot = await docRef.get();

  DateTime startDate;
  final Timestamp? firstUseTimestamp = snapshot.data()?['firstUseDate'];
  if (firstUseTimestamp != null) {
    startDate = firstUseTimestamp.toDate();
  } else {
    startDate = DateTime.now();
    await docRef.set({'firstUseDate': Timestamp.fromDate(startDate)}, SetOptions(merge: true));
  }

  final daysPassed = DateTime.now().difference(startDate).inDays;
  final dayNumber = (daysPassed % 7) + 1;
  return 'Day$dayNumber';
}

class HydrationTrackerWidget extends StatefulWidget {
  const HydrationTrackerWidget({super.key});

  @override
  State<HydrationTrackerWidget> createState() => _HydrationTrackerWidgetState();
}

class _HydrationTrackerWidgetState extends State<HydrationTrackerWidget> {
  int glassesDrank = 0;

  @override
  void initState() {
    super.initState();
    _initializeHydrationFieldIfNeeded();
  }

  Future<void> _initializeHydrationFieldIfNeeded() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      await docRef.set({'hydration': {}});
    } else {
      final data = snapshot.data() as Map<String, dynamic>;
      if (!data.containsKey('hydration')) {
        await docRef.set({'hydration': {}}, SetOptions(merge: true));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox();

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.exists) {
          final docData = snapshot.data!.data() as Map<String, dynamic>;
          final hydration = docData['hydration'] as Map<String, dynamic>?;

          getCustomTodayKey().then((todayKey) {
            if (mounted) {
              setState(() {
                glassesDrank = hydration?[todayKey] ?? 0;
              });
            }
          });
        }

        return GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HydrationScreen(),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE5F6E5),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: "hydration-title",
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Hydration Tracker",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: List.generate(
                    8,
                    (index) => AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: index < glassesDrank ? 1.0 : 0.3,
                      child: Lottie.asset(
                        'assets/animations/water_animation.json',
                        width: 36,
                        height: 36,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, color: Colors.red);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "$glassesDrank / 8 glasses",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HydrationScreen extends StatefulWidget {
  const HydrationScreen({super.key});

  @override
  State<HydrationScreen> createState() => _HydrationScreenState();
}

class _HydrationScreenState extends State<HydrationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _updateGlasses(int count) async {
    HapticFeedback.lightImpact();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await docRef.get();

    if (!snapshot.exists || snapshot.data()?['firstUseDate'] == null) {
      final now = DateTime.now();
      await docRef.set({'firstUseDate': Timestamp.fromDate(now)}, SetOptions(merge: true));
    }

    final todayKey = await getCustomTodayKey();

    await docRef.set({
      'hydration': {todayKey: count}
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox();

    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Hero(
          tag: "hydration-title",
          child: Material(
            color: Colors.transparent,
            child: Text(
              "Hydration Tracker",
              style: GoogleFonts.poppins(
                color: Colors.green.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.green.shade800),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final hydration = snapshot.data!['hydration'] as Map<String, dynamic>?;

          return FutureBuilder<String>(
            future: getCustomTodayKey(),
            builder: (context, snapshotKey) {
              if (!snapshotKey.hasData) return const Center(child: CircularProgressIndicator());

              final todayKey = snapshotKey.data!;
              final int glassesDrank = hydration?[todayKey] ?? 0;

              return FadeTransition(
                opacity: _controller,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text("Stay Hydrated!", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.green.shade900)),
                      const SizedBox(height: 10),
                      Text("Track your daily water intake goal and stay healthy.", style: GoogleFonts.poppins(fontSize: 14)),
                      const SizedBox(height: 30),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(
                          8,
                          (index) => GestureDetector(
                            onTap: () => _updateGlasses(index + 1),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: index < glassesDrank
                                    ? Colors.lightBlueAccent.shade100
                                    : Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: Lottie.asset(
                                  'assets/animations/water_animation.json',
                                  repeat: true,
                                  animate: index < glassesDrank,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error, color: Colors.red);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "$glassesDrank / 8 glasses completed",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.green.shade800,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 36),
                        ),
                        child: Text("Back to Dashboard", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
