import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';

class BookRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all books
  Future<List<BookModel>> getAllBooks() async {
    try {
      final snapshot = await _firestore
          .collection('books')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => BookModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('خطأ في جلب الكتب: ${e.toString()}');
    }
  }

  // Get featured books
  Future<List<BookModel>> getFeaturedBooks() async {
    try {
      final snapshot = await _firestore
          .collection('books')
          .where('isFeatured', isEqualTo: true)
          .limit(10)
          .get();

      return snapshot.docs
          .map((doc) => BookModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('خطأ في جلب الكتب المميزة: ${e.toString()}');
    }
  }

  // Get books by category
  Future<List<BookModel>> getBooksByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection('books')
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs
          .map((doc) => BookModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('خطأ في جلب كتب الفئة: ${e.toString()}');
    }
  }

  // Get book by ID
  Future<BookModel?> getBookById(String bookId) async {
    try {
      final doc = await _firestore.collection('books').doc(bookId).get();

      if (doc.exists) {
        return BookModel.fromJson(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('خطأ في جلب الكتاب: ${e.toString()}');
    }
  }

  // Search books
  Future<List<BookModel>> searchBooks(String query) async {
    try {
      final snapshot = await _firestore
          .collection('books')
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return snapshot.docs
          .map((doc) => BookModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('خطأ في البحث: ${e.toString()}');
    }
  }

  // Add book (Admin only)
  Future<String> addBook(BookModel book) async {
    try {
      final docRef = await _firestore.collection('books').add(book.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('خطأ في إضافة الكتاب: ${e.toString()}');
    }
  }

  // Update book (Admin only)
  Future<void> updateBook(BookModel book) async {
    try {
      await _firestore
          .collection('books')
          .doc(book.id)
          .update(book.copyWith(updatedAt: DateTime.now()).toJson());
    } catch (e) {
      throw Exception('خطأ في تحديث الكتاب: ${e.toString()}');
    }
  }

  // Delete book (Admin only)
  Future<void> deleteBook(String bookId) async {
    try {
      await _firestore.collection('books').doc(bookId).delete();
    } catch (e) {
      throw Exception('خطأ في حذف الكتاب: ${e.toString()}');
    }
  }

  // Get best sellers
  Future<List<BookModel>> getBestSellers() async {
    try {
      final snapshot = await _firestore
          .collection('books')
          .orderBy('purchaseCount', descending: true)
          .limit(10)
          .get();

      return snapshot.docs
          .map((doc) => BookModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('خطأ في جلب الأكثر مبيعاً: ${e.toString()}');
    }
  }

  // Get books stream (realtime)
  Stream<List<BookModel>> getBooksStream() {
    return _firestore
        .collection('books')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BookModel.fromJson(doc.data(), doc.id))
            .toList());
  }
}
