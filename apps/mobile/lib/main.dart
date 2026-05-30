import 'package:flutter/material.dart';
import 'package:bookshelf/app/theme.dart';
import 'package:bookshelf/views/auth/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BookshelfApp());
}

/// Root widget aplikasi Bookshelf.
/// Menggunakan Material 3 theme dengan color scheme teal.
class BookshelfApp extends StatelessWidget {
  const BookshelfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookshelf',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginPage(),
    );
  }
}
