import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';
import 'book_detail_page.dart';

class ExplorePage extends StatefulWidget {
  final List<Book> books;
  const ExplorePage({super.key, required this.books});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String query = '';
  String currentUserEmail = '';
  Set<int> wishlistIds = {};

  @override
  void initState() {
    super.initState();
    _loadUserWishlist();
  }

  Future<void> _loadUserWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('currentUserEmail') ?? '';
    final list = prefs.getStringList('wishlist_$email') ?? [];
    setState(() {
      currentUserEmail = email;
      wishlistIds = list.map(int.parse).toSet();
    });
  }

  Future<void> _toggleWishlist(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'wishlist_$currentUserEmail';
    final list = prefs.getStringList(key) ?? [];
    setState(() {
      if (wishlistIds.contains(id)) {
        wishlistIds.remove(id);
        list.remove(id.toString());
      } else {
        wishlistIds.add(id);
        list.add(id.toString());
      }
      prefs.setStringList(key, list);
    });
  }

  @override
  Widget build(BuildContext context) {
    final results = widget.books.where((b) {
      final q = query.toLowerCase();
      return b.title.toLowerCase().contains(q) || b.author.toLowerCase().contains(q) || b.category.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search title, author, category',
                filled: true,
                fillColor: Colors.blue[50],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => query = v),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: results.isEmpty
                  ? const Center(child: Text('No books found.'))
                  : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: results.length,
                itemBuilder: (context, i) {
                  final b = results[i];
                  final isSaved = wishlistIds.contains(b.id);
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookDetailPage(
                          book: b,
                          isSaved: isSaved,
                          onToggleSaved: () => _toggleWishlist(b.id),
                        ),
                      ),
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                  child: Image.asset(b.imageUrl, fit: BoxFit.cover, width: double.infinity),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(b.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(b.author, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: GestureDetector(
                              onTap: () => _toggleWishlist(b.id),
                              child: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border, color: isSaved ? Colors.red : Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
