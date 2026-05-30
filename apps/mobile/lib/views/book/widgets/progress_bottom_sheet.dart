import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bookshelf/app/theme.dart';
import 'package:bookshelf/app/constants.dart';

/// Bottom sheet untuk mengedit progress/status baca buku.
/// Menampilkan 3 pilihan radio: Belum Dibaca, Sedang Dibaca, Selesai.
/// Saat "Sedang Dibaca" dipilih, muncul input field jumlah halaman yang dibaca.
class ProgressBottomSheet extends StatefulWidget {
  /// Status awal buku yang sedang diedit.
  final ReadingStatus currentStatus;

  /// Jumlah halaman yang sudah dibaca saat ini.
  final int currentPage;

  /// Total halaman buku.
  final int maxPage;

  /// Callback saat user menyimpan status baru beserta halaman yang dibaca.
  final void Function(ReadingStatus status, int pageCurrent) onSave;

  const ProgressBottomSheet({
    super.key,
    required this.currentStatus,
    required this.currentPage,
    required this.maxPage,
    required this.onSave,
  });

  /// Helper untuk menampilkan bottom sheet ini.
  static Future<void> show({
    required BuildContext context,
    required ReadingStatus currentStatus,
    required int currentPage,
    required int maxPage,
    required void Function(ReadingStatus status, int pageCurrent) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // agar bisa menyesuaikan tinggi keyboard
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ProgressBottomSheet(
        currentStatus: currentStatus,
        currentPage: currentPage,
        maxPage: maxPage,
        onSave: onSave,
      ),
    );
  }

  @override
  State<ProgressBottomSheet> createState() => _ProgressBottomSheetState();
}

class _ProgressBottomSheetState extends State<ProgressBottomSheet> {
  /// Status yang dipilih oleh user.
  late ReadingStatus _selectedStatus;

  /// Controller untuk input halaman yang sudah dibaca.
  late TextEditingController _pageController;

  /// Pesan error validasi halaman.
  String? _pageError;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.currentStatus;
    _pageController = TextEditingController(
      text: widget.currentPage > 0 ? widget.currentPage.toString() : '',
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Validasi dan simpan.
  void _handleSave() {
    int pageCurrent = 0;

    if (_selectedStatus == ReadingStatus.sedangDibaca) {
      final input = _pageController.text.trim();
      if (input.isEmpty) {
        setState(() => _pageError = 'Masukkan jumlah halaman yang sudah dibaca');
        return;
      }
      final parsed = int.tryParse(input);
      if (parsed == null || parsed < 0) {
        setState(() => _pageError = 'Masukkan angka yang valid');
        return;
      }
      if (parsed > widget.maxPage) {
        setState(
          () => _pageError = 'Tidak boleh melebihi ${widget.maxPage} halaman',
        );
        return;
      }
      pageCurrent = parsed;
    } else if (_selectedStatus == ReadingStatus.selesai) {
      pageCurrent = widget.maxPage;
    }
    // belumDibaca → pageCurrent = 0

    widget.onSave(_selectedStatus, pageCurrent);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Supaya bottom sheet naik saat keyboard muncul
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Header: judul + tombol close
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Progress Buku',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Radio options
            ...ReadingStatus.values.map((status) => _buildRadioTile(status)),

            // Input halaman saat "Sedang Dibaca" dipilih
            if (_selectedStatus == ReadingStatus.sedangDibaca) ...[
              const SizedBox(height: 12),
              _buildPageInput(),
            ],

            const SizedBox(height: 24),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSave,
                child: const Text('Simpan'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// Input field untuk jumlah halaman yang sudah dibaca.
  Widget _buildPageInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Berapa halaman yang sudah dibaca?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _pageController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: 'Contoh: 45',
            suffixText: '/ ${widget.maxPage} hal',
            errorText: _pageError,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          onChanged: (_) {
            // Reset error saat user mengetik
            if (_pageError != null) {
              setState(() => _pageError = null);
            }
          },
        ),
      ],
    );
  }

  /// Widget radio tile untuk setiap status.
  Widget _buildRadioTile(ReadingStatus status) {
    final isSelected = _selectedStatus == status;
    return InkWell(
      onTap: () => setState(() {
        _selectedStatus = status;
        _pageError = null; // Reset error saat pindah status
      }),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            // Radio indicator
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.divider,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),

            // Label
            Text(
              status.label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
