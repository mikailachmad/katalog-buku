import 'package:flutter/material.dart';
import 'package:bookshelf/app/theme.dart';
import 'package:bookshelf/models/book.dart';

/// Halaman Beri Rating & Review untuk sebuah buku.
/// Sesuai desain: "Tulis ulasan..." + bintang rating (1-5)
/// + text area ulasan + validasi.
class RatingReviewPage extends StatefulWidget {
  final Book book;

  const RatingReviewPage({super.key, required this.book});

  @override
  State<RatingReviewPage> createState() => _RatingReviewPageState();
}

class _RatingReviewPageState extends State<RatingReviewPage> {
  late int _rating;
  late TextEditingController _reviewController;
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.book.rating ?? 0;
    _reviewController = TextEditingController(text: widget.book.note ?? '');
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  /// Simpan rating & review, return result ke halaman sebelumnya.
  void _handleSave() {
    if (_reviewController.text.trim().isEmpty) {
      setState(() => _showError = true);
      return;
    }

    Navigator.pop(context, {
      'rating': _rating,
      'note': _reviewController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Beri Rating & Review'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover buku kecil + judul
            _buildBookInfo(),
            const SizedBox(height: 32),

            // Tulis ulasan label
            Text(
              'Tulis ulasan...',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),

            // Rating bintang
            _buildRatingStars(),
            const SizedBox(height: 32),

            // Label pendapat
            Text(
              'Pendapatmu tentang buku ini?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Text area ulasan
            _buildReviewTextField(),
            const SizedBox(height: 8),

            // Error message
            if (_showError && _reviewController.text.trim().isEmpty)
              Text(
                'Ulasan tidak boleh kosong!',
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            const SizedBox(height: 32),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Info buku kecil: cover thumbnail + judul + penulis.
  Widget _buildBookInfo() {
    return Row(
      children: [
        // Cover thumbnail
        Container(
          width: 60,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.menu_book_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.book.title,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                widget.book.author,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Rating bintang interaktif (1-5).
  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(5, (index) {
          final starIndex = index + 1;
          return GestureDetector(
            onTap: () {
              setState(() => _rating = starIndex);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                starIndex <= _rating
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color: starIndex <= _rating
                    ? AppColors.accent
                    : AppColors.divider,
                size: 40,
              ),
            ),
          );
        }),
        const SizedBox(width: 12),
        Text(
          '$_rating/5',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Text area ulasan — bordered text field multi-line.
  Widget _buildReviewTextField() {
    return TextField(
      controller: _reviewController,
      maxLines: 5,
      onChanged: (_) {
        if (_showError) {
          setState(() => _showError = false);
        }
      },
      decoration: InputDecoration(
        hintText:
            'Beritahu kepada orang lain apa yang kamu suka atau '
            'tidak suka tentang buku ini...',
        hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _showError ? AppColors.error : AppColors.divider,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _showError ? AppColors.error : AppColors.divider,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _showError ? AppColors.error : AppColors.primary,
            width: 2,
          ),
        ),
      ),
    );
  }
}
