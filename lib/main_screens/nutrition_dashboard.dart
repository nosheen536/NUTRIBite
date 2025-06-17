import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutribite/main_screens/meal_planner.dart';
import 'package:nutribite/main_screens/recipe_explorer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutribite/articles/article_list_screen.dart';
import 'package:nutribite/hydration/hydration_tracker.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutribite/profile/profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NutritionDashboard extends StatefulWidget {
   final int initialTabIndex;
  const NutritionDashboard({super.key, this.initialTabIndex = 0});

  @override
  State<NutritionDashboard> createState() => _NutritionDashboardState();
}

class _NutritionDashboardState extends State<NutritionDashboard> {
    String? dayKey;
  int glassesDrank = 0;
  DateTime? _lastBackPressed;
  int selectedChipIndex = 0;
  int _selectedBottomIndex = 0;
  String username = '';
  Map<String, dynamic>? _randomRecipe;

  final List<String> chipLabels = [
    'Healthy Desserts',
    'Snacks',
    'Comfort Food',
    'Drinks',
  ];

  
  void onContinuePlan() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MealPlanScreen()),
    );
  }

  void onSnackSwap() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => RecipeExplorerScreen(category: 'Snacks'),
       settings: RouteSettings(name: '/recipeExplorer'), 
    ),
  );
}



  void onGetDrinkAlternatives() {
   Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => RecipeExplorerScreen(category: 'Drinks'),
    ),
  );
  }

  void onReadMore() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ArticleListScreen()),
    );
  }
  
 Future<void> fetchUsername() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final data = userDoc.data();
   
    if (data != null && data['username'] != null) {
      setState(() {
        username = data['username'] ?? '';
      });
    } 
  } 
}
Future<void> _initializeDayKey() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await docRef.get();

    if (!snapshot.exists || snapshot.data()?['firstUseDate'] == null) {
      await docRef.set({
        'firstUseDate': Timestamp.now(),
      }, SetOptions(merge: true));
    }

    final data = (await docRef.get()).data();
    final Timestamp? firstUseTimestamp = data?['firstUseDate'] as Timestamp?;

    if (firstUseTimestamp != null) {
      final firstUseDate = firstUseTimestamp.toDate();
      final today = DateTime.now();
      final dayDifference = today.difference(firstUseDate).inDays;
      final dayIndex = (dayDifference % 7) + 1;
      setState(() {
        dayKey = 'Day$dayIndex';
      });
    } else {
      setState(() {
        dayKey = 'Day1';
      });
    }
  }


  Future<void> fetchRandomRecipe() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('Recipes').get();
    final allDocs = snapshot.docs;
    if (allDocs.isNotEmpty) {
      final randomDoc = (allDocs..shuffle()).first;
      setState(() {
        _randomRecipe = randomDoc.data();
        _randomRecipe!['id'] = randomDoc.id;
      });
    }
  }
  String slugify(String title) {
  return title.toLowerCase().replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(' ', '-');
}

 void onGlassTap(int count) {
    setState(() {
      glassesDrank = count;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeDayKey();
    fetchUsername();
    fetchRandomRecipe();
    _selectedBottomIndex = widget.initialTabIndex;
    
  }





  Widget buildDrinkAlternativesCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Feeling different today?",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: onGetDrinkAlternatives,
          icon: const Icon(Icons.local_drink_outlined, color: Colors.white),
          label: Text(
            "Get Drink Alternatives",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7EB77F),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: onSnackSwap,
          icon: const Icon(Icons.emoji_food_beverage, color: Colors.white),
          label: Text(
            "Snack Swap",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7EB77F),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          ),
        ),
      ],
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedBottomIndex = index;
    });
  }
  Widget buildWaterTracker(){
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || dayKey == null) return const SizedBox();

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        int fetchedGlasses = 0;

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>?;
          final hydration = data?['hydration'] as Map<String, dynamic>?;
          fetchedGlasses = hydration?[dayKey!] ?? 0;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Water Tracker",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: List.generate(
                8,
                (index) => GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HydrationScreen(),
                      ),
                    );
                    // Optionally: setState() here to force rebuild, if needed.
                  },
                  child: Opacity(
                    opacity: index < fetchedGlasses ? 1.0 : 0.3,
                    child: SizedBox(
                      width: 30,
                      height: 40,
                      child: Lottie.asset(
                        'assets/animations/water_animation.json',
                        repeat: true,
                        animate: index < fetchedGlasses,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          print('Lottie Error: $error');
                          return const Icon(Icons.error, color: Colors.red);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "$fetchedGlasses / 8 glasses today",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700),
            ),
          ],
        );
      },
    );
  }


  Widget buildDashboardScreen() {
    Widget randomRecipeWidget;
    if (_randomRecipe == null) {
      randomRecipeWidget = const Center(child: CircularProgressIndicator());
    } else {
      final randomRecipeId = slugify(_randomRecipe!['title']);
      randomRecipeWidget = Container(
        height: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
  image: CachedNetworkImageProvider(_randomRecipe!['image']),
  fit: BoxFit.cover,
),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _randomRecipe!['title'] ?? '',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${_randomRecipe!['totalCalories'] ?? ''} kcal ",
                        style: GoogleFonts.poppins(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/detailRecipe',
                      arguments: randomRecipeId,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD580),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    "Try Now",
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFF99BC85),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome ${username.isNotEmpty ? username : ''}",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          "Let’s make healthy simple today.",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    ),
              ],
            ),
            const SizedBox(height: 20),
            randomRecipeWidget,
            const SizedBox(height: 18),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: chipLabels.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final selected = selectedChipIndex == index;
                  return GestureDetector(
                   onTap: () {
  setState(() {
    selectedChipIndex = index;
  });
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => RecipeExplorerScreen(category: chipLabels[index]),
    ),
  );
},

                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFFE5F6E5)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? Colors.green : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            chipLabels[index],
                            style: GoogleFonts.poppins(
                              color: selected
                                  ? Colors.green.shade800
                                  : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (selected)
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.green,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            Container(
  padding: const EdgeInsets.all(14),
  decoration: BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(color: Colors.grey.shade200, blurRadius: 6),
    ],
    borderRadius: BorderRadius.circular(16),
  ),
  child: FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const CircularProgressIndicator();
      }

      final userData = snapshot.data!.data() as Map<String, dynamic>;
      final planStartDateValue = userData['planStartDate'];
      final planType = userData['planDuration'] ?? '7dayPlan'; // '3dayPlan' or '7dayPlan'
      final is3DayPlan = planType == '3dayPlan';
      final totalDays = is3DayPlan ? 3 : 7;

      DateTime? planStartDate;
      if (planStartDateValue is Timestamp) {
        planStartDate = planStartDateValue.toDate();
      } else if (planStartDateValue is String) {
        planStartDate = DateTime.tryParse(planStartDateValue);
      }

      if (planStartDate == null) {
        return const Text('Choose a meal plan best suited to your goals');
      }

      final now = DateTime.now();
      final daysPassed = now.difference(planStartDate).inDays;
      final currentDayIndex = daysPassed.clamp(0, totalDays - 1);
      final dayNumber = currentDayIndex + 1;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your Meal Plan",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MealPlanScreen(
                        initialDayIndex: currentDayIndex,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6F4EA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Continue Plan",
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "You're on Day $dayNumber of $totalDays",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      );
    },
  ),
),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: const Color(0xFFF6FFF6),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: buildDrinkAlternativesCard(),
                    ),
                  ),
                ),
                const SizedBox(width: 1),
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: const Color(0xFFF6FFF6),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: buildWaterTracker(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: onReadMore,
              child: Container(
                height: 160,
                width: 1000,
                decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(20),
  image: const DecorationImage(
    image: CachedNetworkImageProvider(
      'https://domf5oio6qrcr.cloudfront.net/medialibrary/16320/bigstock-health-food-selection-super-foods-fruits-veggies.jpg',
    ),
    fit: BoxFit.cover,
  ),
),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          Text(
                            "Explore Wellness Articles",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Stay informed, stay healthy",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 14,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.arrow_forward, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Read More",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

//    
@override
Widget build(BuildContext context) {
  final List<Widget> screens = [
    buildDashboardScreen(),
    const RecipeExplorerScreen(),
    const ArticleListScreen(),
    const MealPlanScreen(),
    const ProfileScreen(),
  ];

  return PopScope(
    canPop: false,
    onPopInvoked: (didPop) async {
      if (didPop) return;

      final now = DateTime.now();
      if (_lastBackPressed == null ||
          now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
        _lastBackPressed = now;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Press back again to exit'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Exit the app
        SystemNavigator.pop();

      }
    },
    child: Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0FFF0), Color(0xFFEAFBEA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: screens[_selectedBottomIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomIndex,
        onTap: _onBottomNavTap,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey.shade500,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Recipes'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Articles'),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Planner'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    ),
  );
}
}