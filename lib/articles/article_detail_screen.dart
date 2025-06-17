import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'article_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final themeGradient = LinearGradient(
      colors: [Colors.green.shade200, Colors.green.shade400],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: themeGradient),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar alternative with back button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.green),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        article.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: 'article-image-${article.id}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: CachedNetworkImage(
  imageUrl: article.image,
  fit: BoxFit.cover,
  placeholder: (context, url) => const SizedBox(
    height: 220,
    child: Center(
      child: CircularProgressIndicator(),
    ),
  ),
  errorWidget: (context, url, error) => const Icon(Icons.error),
),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        article.title,
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.black45,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        article.subtitle,
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 24),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Html(
                          data: article.content,
                          style: {
                            "p": Style(
                              fontSize: FontSize(17),
                              lineHeight: LineHeight(1.6),
                              color: Colors.black87,
                              fontFamily: GoogleFonts.openSans().fontFamily,
                            ),
                            "h2": Style(
                              fontSize: FontSize(22),
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              margin: Margins.only(
                                top: 18,
                                bottom: 12,
                              ), // ✅ Fixed
                            ),
                            "ul": Style(
                              margin: Margins.symmetric(
                                vertical: 12,
                              ), // ✅ Fixed
                            ),
                            "li": Style(
                              fontSize: FontSize(16),
                              color: Colors.black87,
                              fontFamily: GoogleFonts.openSans().fontFamily,
                            ),
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}