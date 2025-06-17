import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final String content;
  final String tag;
  final DateTime createdAt;

  Article({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.content,
    required this.tag,
    required this.createdAt,
  });

  factory Article.fromMap(Map<String, dynamic> map, String docId) {
    print("Data for doc $docId: $map");
    return Article(
      id: docId,
      title: map['title']?.toString() ?? '',
      subtitle: map['subtitle']?.toString() ?? '',
      image: map['image']?.toString() ?? '',
      content: map['content']?.toString() ?? '',
      tag: map['tag']?.toString() ?? '',
      createdAt:
          map['createdAt'] is Timestamp
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
    );
  }
}