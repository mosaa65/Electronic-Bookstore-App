# 📦 نماذج البيانات (Data Models)

## نظرة عامة
هذا الملف يحتوي على جميع نماذج البيانات المطلوبة للتطبيق مع أمثلة تطبيقية.

---

## 1️⃣ UserModel - نموذج المستخدم

```dart
// lib/data/models/user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoURL;
  final String? bio;
  final String role; // 'user' or 'admin'
  final DateTime createdAt;
  final DateTime updatedAt;
  final int totalPurchases;
  final List<String>? favoriteGenres;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoURL,
    this.bio,
    this.role = 'user',
    required this.createdAt,
    required this.updatedAt,
    this.totalPurchases = 0,
    this.favoriteGenres,
  });

  // من JSON إلى Object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoURL: json['photoURL'] as String?,
      bio: json['bio'] as String?,
      role: json['role'] as String? ?? 'user',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      totalPurchases: json['totalPurchases'] as int? ?? 0,
      favoriteGenres: json['favoriteGenres'] != null
          ? List<String>.from(json['favoriteGenres'])
          : null,
    );
  }

  // من Object إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'bio': bio,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'totalPurchases': totalPurchases,
      'favoriteGenres': favoriteGenres,
    };
  }

  // نسخ مع تعديل
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    String? bio,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? totalPurchases,
    List<String>? favoriteGenres,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      bio: bio ?? this.bio,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      totalPurchases: totalPurchases ?? this.totalPurchases,
      favoriteGenres: favoriteGenres ?? this.favoriteGenres,
    );
  }

  // التحقق إذا كان المستخدم مدير
  bool get isAdmin => role == 'admin';
}
```

---

## 2️⃣ BookModel - نموذج الكتاب

```dart
// lib/data/models/book_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  final String id;
  final String title;
  final String author;
  final String description;
  final double price;
  final String coverImageURL;
  final String? pdfURL;
  final String category;
  final String language;
  final int pages;
  final String? publisher;
  final DateTime? publishDate;
  final String? isbn;
  final double rating;
  final int ratingsCount;
  final int purchaseCount;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? addedBy;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.price,
    required this.coverImageURL,
    this.pdfURL,
    required this.category,
    this.language = 'عربي',
    this.pages = 0,
    this.publisher,
    this.publishDate,
    this.isbn,
    this.rating = 0.0,
    this.ratingsCount = 0,
    this.purchaseCount = 0,
    this.isFeatured = false,
    required this.createdAt,
    required this.updatedAt,
    this.addedBy,
  });

  factory BookModel.fromJson(Map<String, dynamic> json, String docId) {
    return BookModel(
      id: docId,
      title: json['title'] as String,
      author: json['author'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      coverImageURL: json['coverImageURL'] as String,
      pdfURL: json['pdfURL'] as String?,
      category: json['category'] as String,
      language: json['language'] as String? ?? 'عربي',
      pages: json['pages'] as int? ?? 0,
      publisher: json['publisher'] as String?,
      publishDate: json['publishDate'] != null
          ? (json['publishDate'] as Timestamp).toDate()
          : null,
      isbn: json['isbn'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      ratingsCount: json['ratingsCount'] as int? ?? 0,
      purchaseCount: json['purchaseCount'] as int? ?? 0,
      isFeatured: json['isFeatured'] as bool? ?? false,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      addedBy: json['addedBy'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'price': price,
      'coverImageURL': coverImageURL,
      'pdfURL': pdfURL,
      'category': category,
      'language': language,
      'pages': pages,
      'publisher': publisher,
      'publishDate': publishDate != null ? Timestamp.fromDate(publishDate!) : null,
      'isbn': isbn,
      'rating': rating,
      'ratingsCount': ratingsCount,
      'purchaseCount': purchaseCount,
      'isFeatured': isFeatured,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'addedBy': addedBy,
    };
  }

  BookModel copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    double? price,
    String? coverImageURL,
    String? pdfURL,
    String? category,
    String? language,
    int? pages,
    String? publisher,
    DateTime? publishDate,
    String? isbn,
    double? rating,
    int? ratingsCount,
    int? purchaseCount,
    bool? isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? addedBy,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      price: price ?? this.price,
      coverImageURL: coverImageURL ?? this.coverImageURL,
      pdfURL: pdfURL ?? this.pdfURL,
      category: category ?? this.category,
      language: language ?? this.language,
      pages: pages ?? this.pages,
      publisher: publisher ?? this.publisher,
      publishDate: publishDate ?? this.publishDate,
      isbn: isbn ?? this.isbn,
      rating: rating ?? this.rating,
      ratingsCount: ratingsCount ?? this.ratingsCount,
      purchaseCount: purchaseCount ?? this.purchaseCount,
      isFeatured: isFeatured ?? this.isFeatured,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      addedBy: addedBy ?? this.addedBy,
    );
  }

  // خصائص مساعدة
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String get ratingText => rating.toStringAsFixed(1);
  bool get hasRatings => ratingsCount > 0;
}
```

---

## 3️⃣ CategoryModel - نموذج الفئة

```dart
// lib/data/models/category_model.dart

class CategoryModel {
  final String id;
  final String name;
  final String? nameEn;
  final String? description;
  final String? iconURL;
  final int booksCount;
  final int? order;

  CategoryModel({
    required this.id,
    required this.name,
    this.nameEn,
    this.description,
    this.iconURL,
    this.booksCount = 0,
    this.order,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json, String docId) {
    return CategoryModel(
      id: docId,
      name: json['name'] as String,
      nameEn: json['nameEn'] as String?,
      description: json['description'] as String?,
      iconURL: json['iconURL'] as String?,
      booksCount: json['booksCount'] as int? ?? 0,
      order: json['order'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nameEn': nameEn,
      'description': description,
      'iconURL': iconURL,
      'booksCount': booksCount,
      'order': order,
    };
  }
}
```

---

## 4️⃣ PurchaseModel - نموذج الشراء

```dart
// lib/data/models/purchase_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseModel {
  final String id;
  final String userId;
  final String bookId;
  final String bookTitle;
  final String bookCoverURL;
  final double price;
  final DateTime purchaseDate;
  final String status; // 'completed', 'pending'

  PurchaseModel({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.bookTitle,
    required this.bookCoverURL,
    required this.price,
    required this.purchaseDate,
    this.status = 'completed',
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json, String docId) {
    return PurchaseModel(
      id: docId,
      userId: json['userId'] as String,
      bookId: json['bookId'] as String,
      bookTitle: json['bookTitle'] as String,
      bookCoverURL: json['bookCoverURL'] as String,
      price: (json['price'] as num).toDouble(),
      purchaseDate: (json['purchaseDate'] as Timestamp).toDate(),
      status: json['status'] as String? ?? 'completed',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'bookId': bookId,
      'bookTitle': bookTitle,
      'bookCoverURL': bookCoverURL,
      'price': price,
      'purchaseDate': Timestamp.fromDate(purchaseDate),
      'status': status,
    };
  }
}
```

---

## 5️⃣ ReviewModel - نموذج المراجعة

```dart
// lib/data/models/review_model.dart

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

  // التحقق إذا أعجب المستخدم بهذه المراجعة
  bool isLikedBy(String uid) {
    return likedBy?.contains(uid) ?? false;
  }

  String get ratingText => rating.toStringAsFixed(1);
}
```

---

## 6️⃣ CartItemModel - نموذج عنصر السلة

```dart
// lib/data/models/cart_item_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class CartItemModel {
  final String bookId;
  final String bookTitle;
  final String bookCoverURL;
  final double price;
  final DateTime addedAt;

  CartItemModel({
    required this.bookId,
    required this.bookTitle,
    required this.bookCoverURL,
    required this.price,
    required this.addedAt,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      bookId: json['bookId'] as String,
      bookTitle: json['bookTitle'] as String,
      bookCoverURL: json['bookCoverURL'] as String,
      price: (json['price'] as num).toDouble(),
      addedAt: (json['addedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'bookTitle': bookTitle,
      'bookCoverURL': bookCoverURL,
      'price': price,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
}
```

---

## 📝 استخدام النماذج - أمثلة

### مثال 1: إنشاء مستخدم جديد

```dart
final newUser = UserModel(
  uid: 'user123',
  email: 'user@example.com',
  displayName: 'أحمد محمد',
  role: 'user',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// حفظه في Firestore
await FirebaseFirestore.instance
    .collection('users')
    .doc(newUser.uid)
    .set(newUser.toJson());
```

### مثال 2: قراءة كتاب من Firestore

```dart
final docSnapshot = await FirebaseFirestore.instance
    .collection('books')
    .doc('book123')
    .get();

if (docSnapshot.exists) {
  final book = BookModel.fromJson(
    docSnapshot.data()!,
    docSnapshot.id,
  );
  print('عنوان الكتاب: ${book.title}');
  print('السعر: ${book.formattedPrice}');
}
```

### مثال 3: إضافة كتاب إلى السلة

```dart
final cartItem = CartItemModel(
  bookId: book.id,
  bookTitle: book.title,
  bookCoverURL: book.coverImageURL,
  price: book.price,
  addedAt: DateTime.now(),
);

await FirebaseFirestore.instance
    .collection('cart')
    .doc(currentUserId)
    .collection('items')
    .doc(book.id)
    .set(cartItem.toJson());
```

### مثال 4: إضافة مراجعة

```dart
final review = ReviewModel(
  id: '',
  bookId: book.id,
  userId: currentUser.uid,
  userName: currentUser.displayName,
  userPhotoURL: currentUser.photoURL,
  rating: 4.5,
  reviewText: 'كتاب رائع جداً! أنصح بقراءته',
  createdAt: DateTime.now(),
);

await FirebaseFirestore.instance
    .collection('reviews')
    .add(review.toJson());
```

---

## ✅ الملخص

هذه النماذج توفر:
- ✅ تحويل سهل بين JSON و Dart Objects
- ✅ Type Safety كاملة
- ✅ Null Safety
- ✅ دوال مساعدة (copyWith, formatted values)
- ✅ سهولة في التعامل مع Firestore

**الخطوة التالية**: إنشاء Repositories للتعامل مع هذه النماذج!
