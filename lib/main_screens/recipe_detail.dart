import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailScreen extends StatelessWidget {
  final String recipeId;
  const DetailScreen({required this.recipeId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FDF6),
      appBar: AppBar(
        title: const Text("Recipe Details"),
        backgroundColor: Colors.green.shade300,
        //colors: [Colors.green.shade200, Colors.green.shade400],
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance
                .collection('Recipes')
                .doc(recipeId)
                .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!.data() as Map<String, dynamic>;

          final title = data['title'] ?? '';
          final image = data['image'] ?? '';
          final servings = data['servings'];
          final prepTime = data['prepTime'];
          final cookTime = data['cookTime'];
          
          final plan = data['plan'];
          final nutritionalFacts = data['nutritionalFacts'];
          final dietaryType = data['dietaryType'];
          final additionalInfo = data['additionalInfo'];
          final totalCalories = data['totalCalories'];
          final proTip = data['proTip'];

          String? categoryString;
          if (data.containsKey('categories') && data['categories'] is List) {
            final categories =
                (data['categories'] as List?)?.cast<String>() ?? [];
            if (categories.isNotEmpty) {
              categoryString = categories.join(' / ');
            }
          } else if (data.containsKey('category')) {
            categoryString = data['category'];
          }

          final ingredients =
              (data['ingredients'] as List?)?.cast<String>() ?? [];
          final optionalToppings =
              (data['optionalToppings'] as List?)?.cast<String>() ?? [];
          final instructions =
              (data['instructions'] as List?)?.cast<String>() ?? [];

          final pairingCombos =
              (data['pairingCombos'] as List?)
                  ?.map((item) {
                    try {
                      final map = Map<String, dynamic>.from(item as Map);
                      return map.map(
                        (k, v) => MapEntry(k.toString(), v.toString()),
                      );
                    } catch (_) {
                      return <String, String>{};
                    }
                  })
                  .where((map) => map.isNotEmpty)
                  .toList() ??
              [];

          final alternatives =
              (data['alternatives'] as List?)
                  ?.map((item) {
                    try {
                      return Map<String, dynamic>.from(item as Map);
                    } catch (_) {
                      return <String, dynamic>{};
                    }
                  })
                  .where((map) => map.isNotEmpty)
                  .toList() ??
              [];

          Widget sectionTitle(String text) => Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFC1E1C1), Color(0xFFC1E1C4)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Color(0xFF388E3C),
                // shadows: [
                //Shadow(
                //offset: Offset(1.5, 1.5),
                //blurRadius: 2.0,
                //color: Colors.grey,
                // ),
                //],
              ),
            ),
          );

          Widget infoCard(Widget child) => Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: child,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (image.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                    imageUrl: data['image'] ?? '',
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 220,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 220,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                  ),
                const SizedBox(height: 16),
                if (title.isNotEmpty)
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF388E3C),
                    ),
                  ),
                const SizedBox(height: 8),
                if (categoryString != null ||
                    prepTime != null ||
                    cookTime != null ||
                    servings != null)
                  Text(
                    [
                      if (categoryString != null) categoryString,
                      if (prepTime != null) "$prepTime Prep",
                      if (cookTime != null) "$cookTime Cook",
                      if (servings != null) "$servings Servings",
                    ].join(' • '),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                if (dietaryType != null &&
                    dietaryType.toString().trim().isNotEmpty)
                  Text(
                    "Dietary: $dietaryType",
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),

                if (plan != null && plan.toString().trim().isNotEmpty) ...[
                  sectionTitle("Plan"),
                  infoCard(Html(data: plan)),
                ],
                if (ingredients.isNotEmpty) ...[
                  sectionTitle("Ingredients (Base Recipe)"),
                  infoCard(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          ingredients.map((ing) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Text(
                                ing,
                                style: const TextStyle(fontSize: 15),
                                softWrap: true, // Optional, default is true
                                overflow:
                                    TextOverflow
                                        .visible, // Optional, ensure it's not clipped
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],

                if (optionalToppings.isNotEmpty) ...[
                  sectionTitle("Optional Toppings"),
                  infoCard(
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          optionalToppings
                              .map(
                                (top) => Chip(
                                  label: Text(top),
                                  backgroundColor: const Color(0xFFC8E6C9),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
                if (instructions.isNotEmpty) ...[
                  sectionTitle("Instructions"),
                  infoCard(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          instructions.map((instruction) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Html(data: instruction),
                            );
                          }).toList(),
                    ),
                  ),
                ],
                if (nutritionalFacts != null &&
                    nutritionalFacts.toString().trim().isNotEmpty) ...[
                  sectionTitle("Nutritional Facts"),
                  infoCard(
                    ExpansionTile(
                      title: const Text(
                        "Show Nutritional Facts",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF388E3C),
                        ),
                      ),
                      iconColor: Colors.green,
                      collapsedIconColor: Colors.green,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: Html(data: nutritionalFacts.toString()),
                        ),
                      ],
                    ),
                  ),
                ],

                if (additionalInfo != null &&
                    additionalInfo.toString().trim().isNotEmpty) ...[
                  sectionTitle("Additional Info"),
                  infoCard(Html(data: additionalInfo)),
                ],
                if (totalCalories != null &&
                    totalCalories.toString().trim().isNotEmpty) ...[
                  sectionTitle("Total Calories"),
                  infoCard(Text(totalCalories.toString())),
                ],
                if (proTip != null && proTip.toString().trim().isNotEmpty) ...[
                  sectionTitle("Pro Tip"),
                  infoCard(infoCard(Html(data: proTip.toString()))),
                ],
                if (pairingCombos.any(
                  (pair) =>
                      pair['combo'] != null && pair['combo']!.trim().isNotEmpty,
                )) ...[
                  sectionTitle("Pairing Combos"),
                  infoCard(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          pairingCombos
                              .where(
                                (pair) =>
                                    pair['combo'] != null &&
                                    pair['combo']!.trim().isNotEmpty,
                              )
                              .map((pair) => Html(data: pair['combo']!))
                              .toList(),
                    ),
                  ),
                ],

                if (alternatives.any(
                  (alt) =>
                      (alt['ifUnavailable']?.toString().trim().isNotEmpty ??
                          false) ||
                      (alt['useInstead']?.toString().trim().isNotEmpty ??
                          false) ||
                      (alt['topping']?.toString().trim().isNotEmpty ?? false) ||
                      (alt['calories']?.toString().trim().isNotEmpty ??
                          false) ||
                      (alt['notes']?.toString().trim().isNotEmpty ?? false) ||
                      (alt['benefits']?.toString().trim().isNotEmpty ?? false),
                )) ...[
                  sectionTitle("Alternatives"),
                  ...alternatives
                      .where(
                        (alt) =>
                            (alt['ifUnavailable']
                                    ?.toString()
                                    .trim()
                                    .isNotEmpty ??
                                false) ||
                            (alt['useInstead']?.toString().trim().isNotEmpty ??
                                false) ||
                            (alt['topping']?.toString().trim().isNotEmpty ??
                                false) ||
                            (alt['calories']?.toString().trim().isNotEmpty ??
                                false) ||
                            (alt['notes']?.toString().trim().isNotEmpty ??
                                false) ||
                            (alt['benefits']?.toString().trim().isNotEmpty ??
                                false),
                      )
                      .map((alt) {
                        return infoCard(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (alt['ifUnavailable']
                                      ?.toString()
                                      .trim()
                                      .isNotEmpty ??
                                  false)
                                Html(
                                  data:
                                      "<b>If unavailable:</b> ${alt['ifUnavailable']}",
                                ),
                              if (alt['useInstead']
                                      ?.toString()
                                      .trim()
                                      .isNotEmpty ??
                                  false)
                                Html(
                                  data: "<b>→ Use:</b> ${alt['useInstead']}",
                                ),
                              if (alt['topping']
                                      ?.toString()
                                      .trim()
                                      .isNotEmpty ??
                                  false)
                                Html(data: "<b>Topping:</b> ${alt['topping']}"),
                              if (alt['calories']
                                      ?.toString()
                                      .trim()
                                      .isNotEmpty ??
                                  false)
                                Html(
                                  data: "<b>Calories:</b> ${alt['calories']}",
                                ),
                              if (alt['notes']?.toString().trim().isNotEmpty ??
                                  false)
                                Html(data: "<b>Notes:</b> ${alt['notes']}"),
                              if (alt['benefits']
                                      ?.toString()
                                      .trim()
                                      .isNotEmpty ??
                                  false)
                                Html(
                                  data: "<b>Benefits:</b> ${alt['benefits']}",
                                ),
                            ],
                          ),
                        );
                      }),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}