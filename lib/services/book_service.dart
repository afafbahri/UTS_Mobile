import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/book.dart';

class BookService {
  static Future<List<Book>> loadBooksFromAssets() async {
    final jsonString = await rootBundle.loadString('assets/data/books.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((book) => Book.fromJson(book)).toList();
  }
}
