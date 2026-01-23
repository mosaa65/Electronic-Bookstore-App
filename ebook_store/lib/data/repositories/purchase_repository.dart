import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/purchase_model.dart';
import 'package:flutter/foundation.dart';

class PurchaseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new purchase
  Future<void> createPurchase(PurchaseModel purchase) async {
    try {
      final batch = _firestore.batch();

      // 1. Create Purchase Doc
      final purchaseRef = _firestore.collection('purchases').doc(purchase.id);
      batch.set(purchaseRef, purchase.toJson());

      // 2. Increment Book Purchase Count
      final bookRef = _firestore.collection('books').doc(purchase.bookId);
      batch.update(bookRef, {'purchaseCount': FieldValue.increment(1)});

      await batch.commit();

      debugPrint('Purchase created and count updated: ${purchase.id}');
    } catch (e) {
      debugPrint('Error creating purchase: $e');
      throw Exception('Failed to create purchase');
    }
  }

  // Get purchases for a specific user
  Future<List<PurchaseModel>> getUserPurchases(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('purchases')
          .where('userId', isEqualTo: userId)
          .orderBy('purchaseDate', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PurchaseModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('Error getting user purchases: $e');
      throw Exception('Failed to get user purchases');
    }
  }

  // Check if a user has purchased a specific book
  Future<bool> checkIfPurchased(String userId, String bookId) async {
    try {
      final snapshot = await _firestore
          .collection('purchases')
          .where('userId', isEqualTo: userId)
          .where('bookId', isEqualTo: bookId)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking purchase: $e');
      return false;
    }
  }
}
