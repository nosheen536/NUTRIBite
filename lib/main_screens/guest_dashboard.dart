// import 'dart:async'; // Added for timer
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nutribite/articles/article_list_screen.dart';
import 'package:flutter/services.dart'; // Added for SystemNavigator.pop()

class GuestDashboard extends StatefulWidget {
  const GuestDashboard({super.key});

  @override
  _GuestDashboardState createState() => _GuestDashboardState();
}

class _GuestDashboardState extends State<GuestDashboard> {
  final List<String> chips = [
    "All",
    "Favourites",
    "Breakfast",
    "Lunch",
    "High Protein",
    "Dinner",
    "Snacks",
    "Drinks",
    "Healthy Desserts",
    "Comfort Food",
    "Soup",
    "Salad",
  ];

  String selectedCategory = 'All';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  int _selectedBottomIndex = 0;

  DateTime? _lastBackPressed; // Added to track back press time

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedBottomIndex = index;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      searchQuery = '';
    });
  }

  Widget buildProfilePlaceholder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 16),
            children: [
              const TextSpan(text: "Please "),
              TextSpan(
                text: "log in / sign up",
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(context, '/signup');
                  },
              ),
              const TextSpan(text: " to have a profile."),
            ],
          ),
        ),
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  final List<Widget> screens = [
    _buildMainRecipeExplorer(),
    const ArticleListScreen(),
    FirebaseAuth.instance.currentUser == null
        ? buildProfilePlaceholder()
        : const Center(child: Text("User Profile Here")),
  ];

  return WillPopScope(
    onWillPop: () async {
      final now = DateTime.now();
      if (_lastBackPressed == null ||
          now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
        _lastBackPressed = now;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Press back again to exit"),
            duration: Duration(seconds: 2),
          ),
        );
        return false;
      }
      // Exit the app on second back press within 2 seconds
      SystemNavigator.pop(); 
      return true;
    },
    child: Scaffold(
      backgroundColor: const Color(0xFFE5F6E5),
      body: Container(
        child: screens[_selectedBottomIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomIndex,
        onTap: _onBottomNavTap,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey.shade500,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu), label: 'Recipes'),
          BottomNavigationBarItem(
              icon: Icon(Icons.article), label: 'Articles'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    ),
  );
}

  Widget _buildMainRecipeExplorer() {
    return SafeArea(
      child: OrientationBuilder(
        builder: (context, orientation) {
          final isLandscape = orientation == Orientation.landscape;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) =>
                            setState(() => searchQuery = value),
                        decoration: InputDecoration(
                          hintText: "Search by recipe, ingredient, meal type…",
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: _clearSearch,
                                )
                              : const Icon(Icons.tune),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: chips.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(chips[index]),
                        backgroundColor: selectedCategory == chips[index]
                            ? Colors.green.shade100
                            : null,
                        onPressed: () =>
                            setState(() => selectedCategory = chips[index]),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: isLandscape
                    ? _buildLandscapeContent()
                    : _buildPortraitContent(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPortraitContent() {
    if (selectedCategory == 'Favourites' &&
        FirebaseAuth.instance.currentUser == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 16),
              children: [
                const TextSpan(text: "Please "),
                TextSpan(
                  text: "log in / sign up",
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushNamed(context, '/signup');
                    },
                ),
                const TextSpan(text: " to see your favourite recipes."),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Popular Picks for You",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(child: _buildRecipeStream()),
        ],
      ),
    );
  }

  Widget _buildLandscapeContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Popular Picks for You",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: _buildRecipeStream(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Recipes').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          final recipes = _filterRecipes(snapshot.data!.docs, []);
          return _buildRecipeGrid(recipes, []);
        }

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots(),
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final userData =
                userSnapshot.data?.data() as Map<String, dynamic>? ?? {};
            final favList = List<String>.from(userData['favourites'] ?? []);
            final recipes = _filterRecipes(snapshot.data!.docs, favList);

            return _buildRecipeGrid(recipes, favList);
          },
        );
      },
    );
  }

  List<QueryDocumentSnapshot> _filterRecipes(
      List<QueryDocumentSnapshot> docs, List<String> favList) {
    return docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;

      final title = data['title']?.toString().toLowerCase() ?? '';
      final ingredients =
          (data['ingredients'] as List?)?.join(' ').toLowerCase() ?? '';
      final matchesSearch = title.contains(searchQuery.toLowerCase()) ||
          ingredients.contains(searchQuery.toLowerCase());

      if (selectedCategory == 'All') {
        return matchesSearch;
      } else if (selectedCategory == 'Favourites') {
        return favList.contains(doc.id) && matchesSearch;
      } else {
        final singleCategory = data['category']?.toString() ?? '';
        final multipleCategories =
            (data['categories'] as List?)?.cast<String>() ?? [];

        final matchesCategory = singleCategory == selectedCategory ||
            multipleCategories.contains(selectedCategory);

        return matchesCategory && matchesSearch;
      }
    }).toList();
  }

  Widget _buildRecipeGrid(
      List<QueryDocumentSnapshot> recipes, List<String> favList) {
    return GridView.builder(
      itemCount: recipes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / 4,
      ),
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        final data = recipe.data() as Map<String, dynamic>;
        final isFavorite = favList.contains(recipe.id);

        final nutritionalFacts = data['nutritionalFacts'] ?? '';
        final caloriesMatch =
            RegExp(r'Calories:\s*~?(\d+)').firstMatch(nutritionalFacts);
        final calories =
            caloriesMatch != null ? '${caloriesMatch.group(1)} kcal' : '';

        String categoryDisplay;
        if (data.containsKey('categories') &&
            data['categories'] is List &&
            (data['categories'] as List).isNotEmpty) {
          categoryDisplay =
              (data['categories'] as List).cast<String>().join(' / ');
        } else {
          categoryDisplay = data['category']?.toString() ?? '';
        }

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/detailRecipe',
              arguments: recipe.id,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: data['image'] ?? '',
                    height: 120,
                    width: double.infinity,
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                data['title'] ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : null,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                  minWidth: 30, minHeight: 30),
                              onPressed: () async {
                                final user =
                                    FirebaseAuth.instance.currentUser;
                                if (user == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          const Text("Please "),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, '/login');
                                            },
                                            child: const Text(
                                              "log in",
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                          const Text(
                                              " to favorite recipes."),
                                        ],
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final userRef = FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid);

                                if (isFavorite) {
                                  await userRef.update({
                                    'favourites':
                                        FieldValue.arrayRemove([recipe.id])
                                  });
                                } else {
                                  await userRef.set({
                                    'favourites':
                                        FieldValue.arrayUnion([recipe.id])
                                  }, SetOptions(merge: true));
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "$categoryDisplay | ${data['totalTime']} | $calories",
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                      ],
                    ),
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
