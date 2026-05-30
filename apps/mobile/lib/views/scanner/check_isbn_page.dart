import 'package:flutter/material.dart';
import 'package:bookshelf/app/theme.dart';
import 'package:bookshelf/views/book/add_book_page.dart';
import 'package:bookshelf/views/scanner/scan_barcode_page.dart';

/// Halaman Cek Kode ISBN — setelah scan barcode atau input manual.
/// Sesuai desain: menampilkan ISBN di text field (editable),
/// tombol "Cari Buku" dan "Scan Ulang".
class CheckIsbnPage extends StatefulWidget {
  final String isbn;

  const CheckIsbnPage({super.key, required this.isbn});

  @override
  State<CheckIsbnPage> createState() => _CheckIsbnPageState();
}

class _CheckIsbnPageState extends State<CheckIsbnPage> {
  late TextEditingController _isbnController;

  @override
  void initState() {
    super.initState();
    _isbnController = TextEditingController(text: widget.isbn);
  }

  @override
  void dispose() {
    _isbnController.dispose();
    super.dispose();
  }

  /// Navigasi ke AddBookPage dengan ISBN pre-filled.
  void _navigateToAddBook() {
    final isbn = _isbnController.text.trim();
    if (isbn.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan kode ISBN terlebih dahulu'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AddBookPage(prefilledIsbn: isbn),
      ),
    );
  }

  /// Kembali ke scanner untuk scan ulang.
  void _scanAgain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ScanBarcodePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Cek kode ISBN')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            Text(
              'Masukkan ISBN buku',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // ISBN text field (editable)
            TextField(
              controller: _isbnController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '9786020603376',
                suffixIcon: _isbnController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        onPressed: () {
                          _isbnController.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: _isbnController.text.length,
                          );
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Cari Buku & Scan Ulang
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _navigateToAddBook,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Cari Buku'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _scanAgain,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Scan Ulang'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
