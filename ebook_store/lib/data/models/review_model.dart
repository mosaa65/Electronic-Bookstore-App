import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String bookId;
  final String userId;
  final String userName;
  final String? userPhotoURL;
  final double rating;
  final String? reviewText;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likesCount;
  final List<String>? likedBy;

  ReviewModel({
    required this.id,
    required this.bookId,
    required this.userId,
    required this.userName,
    this.userPhotoURL,
    required this.rating,
    this.reviewText,
    required this.createdAt,
    this.updatedAt,
    this.likesCount = 0,
    this.likedBy,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json, String docId) {
    return ReviewModel(
      id: docId,
      bookId: json['bookId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userPhotoURL: json['userPhotoURL'] as String?,
      rating: (json['rating'] as num).toDouble(),
      reviewText: json['reviewText'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
      likesCount: json['likesCount'] as int? ?? 0,
      likedBy: json['likedBy'] != null
          ? List<String>.from(json['likedBy'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'userId': userId,
      'userName': userName,
      'userPhotoURL': userPhotoURL,
      'rating': rating,
      'reviewText': reviewText,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'likesCount': likesCount,
      'likedBy': likedBy,
    };
  }

  bool isLikedBy(String uid) {
    return likedBy?.contains(uid) ?? false;
  }

  String get ratingText => rating.toStringAsFixed(1);
}
