// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'article_model.dart';
// import 'article_detail_screen.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class ArticleListScreen extends StatelessWidget {
//   const ArticleListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final themeColor1 = const Color(0xFF8BC34A);
//     // final themeColor2 = const Color(0xFFCDDC39);
    

//     return Scaffold(
//       backgroundColor:const Color(0xFFE5F6E5),
//       // Gradient background
//       body: Container(
//         decoration: BoxDecoration(
//           // gradient: LinearGradient(
//           //   colors: [
//           //     themeColor1.withOpacity(0.4),
//           //     themeColor2.withOpacity(0.2),
//           //   ],
//           //   begin: Alignment.topLeft,
//           //   end: Alignment.bottomRight,
//           // ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               AppBar(
//                 title: Text(
//                   'Nutrition Articles',
//                   style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//                 ),
//                 centerTitle: true,
//                 backgroundColor: Colors.transparent,
//                 elevation: 0,
//               ),
//               Expanded(
//                 child: StreamBuilder<QuerySnapshot>(
//                   stream:
//                       FirebaseFirestore.instance
//                           .collection('articles')
//                           .orderBy('createdAt', descending: true)
//                           .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasError) {
//                       return Center(child: Text("Error loading articles"));
//                     }
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     }

//                     final docs = snapshot.data!.docs;

//                     return ListView.builder(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 8,
//                       ),
//                       itemCount: docs.length,
//                       itemBuilder: (context, index) {
//                         final article = Article.fromMap(
//                           docs[index].data() as Map<String, dynamic>,
//                           docs[index].id,
//                         );

//                         return _ArticleCard(article: article);
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _ArticleCard extends StatefulWidget {
//   final Article article;

//   const _ArticleCard({required this.article});

//   @override
//   State<_ArticleCard> createState() => _ArticleCardState();
// }

// class _ArticleCardState extends State<_ArticleCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnim;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 100),
//       vsync: this,
//       lowerBound: 0.95,
//       upperBound: 1.0,
//     );
//     _scaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _onTapDown(TapDownDetails details) => _controller.reverse();
//   void _onTapUp(TapUpDetails details) => _controller.forward();
//   void _onTapCancel() => _controller.forward();

//   @override
//   Widget build(BuildContext context) {
//     final article = widget.article;

//     return GestureDetector(
//       onTapDown: _onTapDown,
//       onTapUp: (details) {
//         _onTapUp(details);
//         Navigator.push(
//           context,
//           PageRouteBuilder(
//             transitionDuration: const Duration(milliseconds: 400),
//             pageBuilder:
//                 (_, animation, __) => FadeTransition(
//                   opacity: animation,
//                   child: ArticleDetailScreen(article: article),
//                 ),
//           ),
//         );
//       },
//       onTapCancel: _onTapCancel,
//       child: ScaleTransition(
//         scale: _scaleAnim,
//         child: Container(
//           margin: const EdgeInsets.only(bottom: 16),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.white.withOpacity(0.9),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.07),
//                 blurRadius: 16,
//                 offset: const Offset(0, 8),
//               ),
//               BoxShadow(
//                 color: Colors.green.withOpacity(0.1),
//                 blurRadius: 6,
//                 offset: const Offset(0, 4),
//                 spreadRadius: 1,
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Hero(
//                 tag: 'article-image-${article.id}',
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(20),
//                   ),
//                 child: CachedNetworkImage(
//   imageUrl: article.image,
//   fit: BoxFit.cover,
//   placeholder: (context, url) => const SizedBox(
//     height: 180,
//     width: double.infinity,
//     child: Center(
//       child: CircularProgressIndicator(),
//     ),
//   ),
//   errorWidget: (context, url, error) => const Icon(Icons.error),
// ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 14,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       article.title,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.poppins(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 20,
//                         color: const Color(0xFF344955),
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       article.subtitle,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.openSans(
//                         fontWeight: FontWeight.w400,
//                         fontSize: 14,
//                         color: Colors.grey[700],
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 14,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.green.shade300,
//                             Colors.green.shade500,
//                           ],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       child: Text(
//                         article.tag.toUpperCase(),
//                         style: GoogleFonts.poppins(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                           letterSpacing: 1.1,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'article_model.dart';
import 'article_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'dart:async'; // Added for timer

class ArticleListScreen extends StatefulWidget {
  const ArticleListScreen({super.key});

  @override
  State<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  DateTime? _lastBackPressed;

 int _backPressCount = 0;


Future<bool> _onWillPop() async {
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
}

// Future<bool> _onWillPop() async {
//   DateTime now = DateTime.now();

//   // Reset count if 3+ seconds passed
//   if (_lastBackPressed == null || now.difference(_lastBackPressed!) > const Duration(seconds: 3)) {
//     _backPressCount = 0;
//   }

//   _lastBackPressed = now;
//   _backPressCount++;

//   if (_backPressCount == 1) {
//     // First tap: navigate back
//     Navigator.pop(context);
//     return Future.value(false);
//   } else if (_backPressCount == 2) {
//     // Second tap: show message
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Press back again to exit'),
//         duration: Duration(seconds: 2),
//       ),
//     );
//     return Future.value(false);
//   } else {
//     // Third tap: exit app
//     SystemNavigator.pop();
//     return Future.value(false);
//   }
// }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFFE5F6E5),
        body: Container(
          decoration: BoxDecoration(
              // Optional gradient background
              // gradient: LinearGradient(
              //   colors: [Color(0xFF8BC34A).withOpacity(0.4), Color(0xFFCDDC39).withOpacity(0.2)],
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              // ),
              ),
          child: SafeArea(
            child: Column(
              children: [
                AppBar(
                  title: Text(
                    'Nutrition Articles',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('articles')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text("Error loading articles"));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final docs = snapshot.data!.docs;

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final article = Article.fromMap(
                            docs[index].data() as Map<String, dynamic>,
                            docs[index].id,
                          );

                          return _ArticleCard(article: article);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArticleCard extends StatefulWidget {
  final Article article;

  const _ArticleCard({required this.article});

  @override
  State<_ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<_ArticleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
      lowerBound: 0.95,
      upperBound: 1.0,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _controller.reverse();
  void _onTapUp(TapUpDetails details) => _controller.forward();
  void _onTapCancel() => _controller.forward();

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: (details) {
        _onTapUp(details);
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (_, animation, __) => FadeTransition(
              opacity: animation,
              child: ArticleDetailScreen(article: article),
            ),
          ),
        );
      },
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.9),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.green.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 4),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'article-image-${article.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: article.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const SizedBox(
                      height: 180,
                      width: double.infinity,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: const Color(0xFF344955),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade300,
                            Colors.green.shade500,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        article.tag.toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

