import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/book_service.dart';
import '../models/book.dart';
import 'register_page.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _loading = false;

  void _login() async {
    final prefs = await SharedPreferences.getInstance();
    final accounts = prefs.getStringList('accounts') ?? [];

    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    bool found = false;
    String foundName = '';
    for (var acc in accounts) {
      final parts = acc.split('|');
      if (parts.length >= 3 && parts[0] == _email && parts[1] == _password) {
        found = true;
        foundName = parts[2];
        break;
      }
    }

    if (!found) {
      _showErrorDialog("Email atau password salah!");
      return;
    }

    setState(() => _loading = true);
    // simulasikan delay
    await Future.delayed(const Duration(milliseconds: 800));
    await prefs.setBool('loggedIn', true);
    await prefs.setString('currentUserEmail', _email);
    await prefs.setString('currentUserName', foundName);

    final books = await BookService.loadBooksFromAssets();
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => RootPage(books: books)),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Gagal Login"),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // UI sesuai gaya awal kamu; ringkas di sini
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(height: 40),
                const Text('PageUp', textAlign: TextAlign.center, style: TextStyle(fontSize: 36, color: Color(0xFF0A74C3), fontWeight: FontWeight.bold)),
                const SizedBox(height: 36),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (v) => (v == null || v.isEmpty) ? "Masukkan email" : null,
                  onSaved: (v) => _email = v!.trim(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  validator: (v) => (v == null || v.isEmpty) ? "Masukkan password" : null,
                  onSaved: (v) => _password = v!.trim(),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _loading ? null : _login,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A74C3), minimumSize: const Size(double.infinity, 48)),
                  child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text("Masuk"),
                ),
                const SizedBox(height: 12),
                TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())), child: const Text("Belum punya akun? Daftar"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
