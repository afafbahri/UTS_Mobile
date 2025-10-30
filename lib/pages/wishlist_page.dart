import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';
import 'book_detail_page.dart';

class WishlistPage extends StatefulWidget {
  final List<Book> books;
  final String userEmail;
  const WishlistPage({super.key, required this.books, required this.userEmail});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<int> savedIds = [];

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('wishlist_${widget.userEmail}') ?? [];
    setState(() => savedIds = list.map(int.parse).toList());
  }

  Future<void> _remove(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'wishlist_${widget.userEmail}';
    final list = prefs.getStringList(key) ?? [];
    list.remove(id.toString());
    await prefs.setStringList(key, list);
    setState(() => savedIds = list.map(int.parse).toList());
  }

  @override
  Widget build(BuildContext context) {
    final savedBooks = widget.books.where((b) => savedIds.contains(b.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: savedBooks.isEmpty
          ? const Center(child: Text('Wishlist kosong.'))
          : ListView.builder(
        itemCount: savedBooks.length,
        itemBuilder: (context, i) {
          final b = savedBooks[i];
          return ListTile(
            leading: Image.asset(b.imageUrl, width: 56, height: 80, fit: BoxFit.cover),
            title: Text(b.title),
            subtitle: Text(b.author),
            trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => _remove(b.id)),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookDetailPage(
                  book: b,
                  isSaved: true,
                  onToggleSaved: () async {
                    await _remove(b.id);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
