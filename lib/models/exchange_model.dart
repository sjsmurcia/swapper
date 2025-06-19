import 'package:cloud_firestore/cloud_firestore.dart';

class ExchangeModel {
  final String id;
  final String title;
  final String category;
  final String? thumbnailUrl;
  final String ownerId;
  final DateTime createdAt;

  ExchangeModel({
    required this.id,
    required this.title,
    required this.category,
    this.thumbnailUrl,
    required this.ownerId,
    required this.createdAt,
  });

  factory ExchangeModel.fromMap(String id, Map<String, dynamic> map) {
    return ExchangeModel(
      id: id,
      title: map['title'] as String? ?? '',
      category: map['category'] as String? ?? '',
      thumbnailUrl: map['thumbnailUrl'] as String?,
      ownerId: map['ownerId'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      'ownerId': ownerId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}