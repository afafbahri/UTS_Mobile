import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';
import 'book_detail_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final List<Book> books;
  const HomePage({super.key, required this.books});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentUserEmail = '';
  String currentUserName = '';
  Set<int> wishlistIds = {};

  @override
  void initState() {
    super.initState();
    _loadUserAndWishlist();
  }

  Future<void> _loadUserAndWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('currentUserEmail') ?? '';
    final name = prefs.getString('currentUserName') ?? '';
    final list = prefs.getStringList('wishlist_$email') ?? [];
    setState(() {
      currentUserEmail = email;
      currentUserName = name;
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

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
    await prefs.remove('currentUserEmail');
    await prefs.remove('currentUserName');
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (r) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final trending = widget.books.take(4).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("PageUp"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (currentUserName.isNotEmpty)
            Text(
              'Halo, $currentUserName 👋',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          const SizedBox(height: 12),
          const Text('Trending', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: trending.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final b = trending[i];
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
                  child: Container(
                    width: 130,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.asset(
                                  b.imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                b.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: GestureDetector(
                            onTap: () => _toggleWishlist(b.id),
                            child: Icon(
                              isSaved ? Icons.bookmark : Icons.bookmark_border,
                              color: isSaved ? Colors.red : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text('All Books', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.books.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, i) {
              final b = widget.books[i];
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
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.asset(
                                b.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  b.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  b.author,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: GestureDetector(
                          onTap: () => _toggleWishlist(b.id),
                          child: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: isSaved ? Colors.red : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
