import 'package:flutter/material.dart';
import 'package:bookshelf/app/theme.dart';
import 'package:bookshelf/views/auth/register_page.dart';
import 'package:bookshelf/views/auth/widgets/auth_text_field.dart';
import 'package:bookshelf/views/home/home_page.dart';

/// Halaman Login (Selamat Datang).
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handler tombol "Masuk" — saat ini hanya validasi form.
  /// Logic API login + JWT akan ditambahkan di tahap selanjutnya.
  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Integrasi API login + JWT di tahap selanjutnya
      // Navigasi ke HomePage setelah login berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(
            username: _usernameController.text.trim(),
          ),
        ),
      );
    }
  }

  /// Navigasi ke halaman Register
  void _navigateToRegister() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),

                // Logo & nama aplikasi
                _buildHeader(),
                const SizedBox(height: 32),

                // Judul & subtitle
                Text(
                  'Selamat datang!',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Silakan masuk untuk mengakses koleksi buku '
                  'dan pantau progres bacaan Anda.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),

                // Indikator status koneksi (placeholder)
                _buildConnectionIndicator(),
                const SizedBox(height: 32),

                // Form fields
                _buildUsernameField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 32),

                // Tombol Masuk
                ElevatedButton(
                  onPressed: _handleLogin,
                  child: const Text('Masuk'),
                ),
                const SizedBox(height: 24),

                // Link ke halaman Register
                _buildRegisterLink(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Header: ikon buku + nama aplikasi
  Widget _buildHeader() {
    return Row(
      children: [
        // Placeholder logo (ikon buku dengan background merah)
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: Color(0xFFE53935),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.menu_book_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Bookshelf',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  /// Indikator koneksi — sesuai desain ada badge "Anda sedang offline/online".
  /// Saat ini placeholder statis, nanti di-upgrade dengan connectivity check.
  Widget _buildConnectionIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.offline.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded, size: 16, color: AppColors.offline),
          const SizedBox(width: 6),
          Text(
            'Anda sedang offline',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.offline,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// Field Username/Email
  Widget _buildUsernameField() {
    return AuthTextField(
      controller: _usernameController,
      hintText: 'Email atau username',
      labelText: 'Email / Username',
      prefixIcon: Icons.person_outline,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email atau username wajib diisi';
        }
        return null;
      },
    );
  }

  /// Field Password dengan toggle show/hide
  Widget _buildPasswordField() {
    return AuthTextField(
      controller: _passwordController,
      hintText: 'Masukkan password',
      labelText: 'Password',
      prefixIcon: Icons.lock_outline,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_off : Icons.visibility,
          size: 22,
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password wajib diisi';
        }
        return null;
      },
    );
  }

  /// Link navigasi ke halaman Register
  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Belum punya akun? ',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        GestureDetector(
          onTap: _navigateToRegister,
          child: Text(
            'Daftar',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
