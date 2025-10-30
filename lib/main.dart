import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/explore_page.dart';
import 'pages/wishlist_page.dart';
import 'models/book.dart';
import 'services/book_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PageUpApp());
}

class PageUpApp extends StatelessWidget {
  const PageUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color navy = Color(0xFF0A2647); // navy
    const Color blueSoft = Color(0xFF0A74C3); // blue soft / accent

    return MaterialApp(
      title: 'PageUp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        primaryColor: navy,
        colorScheme: ColorScheme.fromSeed(
          seedColor: navy,
          primary: navy,
          secondary: blueSoft,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.blue.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

/// RootPage: halaman utama setelah login (BottomNavigationBar)
class RootPage extends StatefulWidget {
  final List<Book> books;
  const RootPage({super.key, required this.books});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;
  String _currentUserEmail = '';
  bool _loadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('currentUserEmail') ?? '';
    if (!mounted) return;
    setState(() {
      _currentUserEmail = email;
      _loadingUser = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // while we load current user, show a simple loader
    if (_loadingUser) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // pages need books and, for wishlist, userEmail
    final pages = <Widget>[
      HomePage(books: widget.books),
      ExplorePage(books: widget.books),
      WishlistPage(books: widget.books, userEmail: _currentUserEmail),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey[600],
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmarks), label: 'Wishlist'),
        ],
      ),
    );
  }
}

/// Utility: panggil dari LoginPage setelah berhasil login
Future<void> navigateToHome(BuildContext context) async {
  final books = await BookService.loadBooksFromAssets();
  // replace current route with RootPage
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => RootPage(books: books)),
  );
}
