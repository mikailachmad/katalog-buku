import 'package:flutter/material.dart';
import 'package:bookshelf/app/theme.dart';
import 'package:bookshelf/app/constants.dart';

/// Bottom sheet untuk mengedit progress/status baca buku.
/// Menampilkan 3 pilihan radio: Belum Dibaca, Sedang Dibaca, Selesai.
class ProgressBottomSheet extends StatefulWidget {
  /// Status awal buku yang sedang diedit.
  final ReadingStatus currentStatus;

  /// Callback saat user menyimpan status baru.
  final ValueChanged<ReadingStatus> onSave;

  const ProgressBottomSheet({
    super.key,
    required this.currentStatus,
    required this.onSave,
  });

  /// Helper untuk menampilkan bottom sheet ini.
  static Future<void> show({
    required BuildContext context,
    required ReadingStatus currentStatus,
    required ValueChanged<ReadingStatus> onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ProgressBottomSheet(
        currentStatus: currentStatus,
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

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.currentStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const SizedBox(height: 24),

          // Tombol Simpan
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onSave(_selectedStatus);
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  /// Widget radio tile untuk setiap status.
  Widget _buildRadioTile(ReadingStatus status) {
    final isSelected = _selectedStatus == status;
    return InkWell(
      onTap: () => setState(() => _selectedStatus = status),
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
