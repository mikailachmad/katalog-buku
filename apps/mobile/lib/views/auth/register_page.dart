import 'package:flutter/material.dart';
import 'package:bookshelf/app/theme.dart';
import 'package:bookshelf/views/auth/login_page.dart';
import 'package:bookshelf/views/auth/widgets/auth_text_field.dart';

/// Halaman Buat Akun Baru (Register).
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handler tombol "Daftar" — saat ini hanya validasi form.
  /// Logic API register akan ditambahkan di tahap selanjutnya.
  void _handleRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Integrasi API register di tahap selanjutnya
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran berhasil!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  /// Navigasi ke halaman Login
  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
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

                // Judul halaman
                Text(
                  'Buat Akun Baru',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Silakan isi data diri Anda untuk mendaftar dan '
                  'mulai menggunakan aplikasi Bookshelf.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),

                // Form fields
                _buildNameField(),
                const SizedBox(height: 16),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 32),

                // Tombol Daftar
                ElevatedButton(
                  onPressed: _handleRegister,
                  child: const Text('Daftar'),
                ),
                const SizedBox(height: 24),

                // Link ke halaman Login
                _buildLoginLink(),
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

  /// Field Nama Lengkap
  Widget _buildNameField() {
    return AuthTextField(
      controller: _nameController,
      hintText: 'Masukkan nama lengkap',
      labelText: 'Nama Lengkap',
      prefixIcon: Icons.person_outline,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Nama lengkap wajib diisi';
        }
        return null;
      },
    );
  }

  /// Field Email
  Widget _buildEmailField() {
    return AuthTextField(
      controller: _emailController,
      hintText: 'contoh@email.com',
      labelText: 'Email',
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email wajib diisi';
        }
        // Validasi format email sederhana
        final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
        if (!emailRegex.hasMatch(value)) {
          return 'Format email tidak valid';
        }
        return null;
      },
    );
  }

  /// Field Password dengan toggle show/hide
  Widget _buildPasswordField() {
    return AuthTextField(
      controller: _passwordController,
      hintText: 'Minimal 6 karakter',
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
        if (value.length < 6) {
          return 'Password minimal 6 karakter';
        }
        return null;
      },
    );
  }

  /// Link navigasi ke halaman Login
  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Sudah punya akun? ',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        GestureDetector(
          onTap: _navigateToLogin,
          child: Text(
            'Masuk',
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
