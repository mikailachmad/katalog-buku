import 'package:flutter/material.dart';
import 'package:bookshelf/app/theme.dart';
import 'package:bookshelf/app/constants.dart';
import 'package:bookshelf/models/book.dart';

/// Halaman form untuk menambah buku baru secara manual.
/// Fields: Judul, Penulis, Genre (dropdown), Total Halaman, ISBN.
class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _totalPagesController = TextEditingController();
  final _isbnController = TextEditingController();

  /// Genre yang dipilih dari dropdown.
  String? _selectedGenre;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _totalPagesController.dispose();
    _isbnController.dispose();
    super.dispose();
  }

  /// Handler tombol "Simpan".
  /// Membuat objek Book dari form dan mengembalikan ke halaman sebelumnya.
  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final book = Book(
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        genre: _selectedGenre ?? 'Lainnya',
        pageMax: int.tryParse(_totalPagesController.text) ?? 0,
        isbn: _isbnController.text.trim().isEmpty
            ? null
            : _isbnController.text.trim(),
      );

      // Kembalikan book ke halaman sebelumnya
      Navigator.pop(context, book);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Buku berhasil ditambahkan!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tambah Buku'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Field Judul
              _buildLabel('Judul'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _titleController,
                hint: 'Masukkan judul buku',
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Judul wajib diisi'
                    : null,
              ),
              const SizedBox(height: 20),

              // Field Penulis
              _buildLabel('Penulis'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _authorController,
                hint: 'Masukkan nama penulis',
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Penulis wajib diisi'
                    : null,
              ),
              const SizedBox(height: 20),

              // Dropdown Genre
              _buildLabel('Genre'),
              const SizedBox(height: 8),
              _buildGenreDropdown(),
              const SizedBox(height: 20),

              // Field Total Halaman
              _buildLabel('Total Halaman'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _totalPagesController,
                hint: 'Contoh: 346',
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Total halaman wajib diisi';
                  }
                  if (int.tryParse(v) == null || int.parse(v) <= 0) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Field ISBN (opsional)
              _buildLabel('ISBN'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _isbnController,
                hint: '978-6-02412-518-9',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 36),

              // Tombol Simpan
              ElevatedButton(
                onPressed: _handleSave,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Label field di atas input.
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// Reusable text form field.
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(hintText: hint),
    );
  }

  /// Dropdown untuk memilih genre buku.
  Widget _buildGenreDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedGenre,
      decoration: const InputDecoration(hintText: 'Pilih genre buku'),
      items: AppConstants.genres.map((genre) {
        return DropdownMenuItem(
          value: genre,
          child: Text(genre),
        );
      }).toList(),
      onChanged: (value) {
        setState(() => _selectedGenre = value);
      },
      validator: (value) {
        if (value == null) return 'Genre wajib dipilih';
        return null;
      },
    );
  }
}
