import 'package:flutter/material.dart';
import '../models/book.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;
  final bool isSaved;
  final VoidCallback onToggleSaved;

  const BookDetailPage({super.key, required this.book, required this.isSaved, required this.onToggleSaved});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        actions: [
          IconButton(
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border, color: isSaved ? Colors.red : Colors.white),
            onPressed: onToggleSaved,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(book.imageUrl, width: double.infinity, height: 260, fit: BoxFit.cover)),
          const SizedBox(height: 16),
          Text(book.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text('by ${book.author}', style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          Text('Category: ${book.category}'),
          const SizedBox(height: 16),
          const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(book.description, textAlign: TextAlign.justify),
        ]),
      ),
    );
  }
}
