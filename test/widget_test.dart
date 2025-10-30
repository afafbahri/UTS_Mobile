import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:katalog_buku/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    // Jalankan aplikasi utama
    await tester.pumpWidget(const PageUpApp());

    // Verifikasi tampilan login muncul
    expect(find.text('Login Katalog Buku'), findsOneWidget);
  });
}
