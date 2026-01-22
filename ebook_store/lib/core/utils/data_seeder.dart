import 'package:flutter/material.dart';
import '../../data/repositories/book_repository.dart';

class DataSeeder {
  static Future<void> seedAll() async {
    final bookRepo = BookRepository();
    
    print('Starting seeding process...');
    
    try {
      // Seed Books using existing method in repository
      await bookRepo.seedBooks();
      
      // We can add category seeding here if needed
      print('Seeding completed!');
    } catch (e) {
      print('Seeding failed: $e');
    }
  }
}
