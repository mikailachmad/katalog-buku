import 'package:flutter/material.dart';
import 'package:bookshelf/app/theme.dart';

/// Filter chips untuk menyaring buku berdasarkan status baca.
/// Menampilkan pilihan: "Semua", "Sedang Dibaca", "Selesai" secara horizontal.
class StatusFilterChips extends StatelessWidget {
  /// Index filter yang aktif: 0=Semua, 1=Sedang Dibaca, 2=Selesai.
  final int selectedIndex;

  /// Callback saat filter dipilih.
  final ValueChanged<int> onSelected;

  const StatusFilterChips({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const List<String> _labels = [
    'Semua',
    'Sedang Dibaca',
    'Selesai',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_labels.length, (index) {
          final isSelected = index == selectedIndex;
          return Padding(
            padding: EdgeInsets.only(right: index < _labels.length - 1 ? 8 : 0),
            child: ChoiceChip(
              label: Text(_labels[index]),
              selected: isSelected,
              onSelected: (_) => onSelected(index),
              selectedColor: AppColors.primary,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.divider,
                ),
              ),
              showCheckmark: false,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          );
        }),
      ),
    );
  }
}
