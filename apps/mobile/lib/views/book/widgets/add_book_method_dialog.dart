import 'package:flutter/material.dart';
import 'package:bookshelf/app/theme.dart';

/// Dialog bottom sheet yang muncul saat user menekan FAB "+" di home.
/// Memberikan pilihan: "Isi Manual" atau "Scan ISBN".
class AddBookMethodDialog extends StatelessWidget {
  final VoidCallback onManualTap;
  final VoidCallback onScanTap;

  const AddBookMethodDialog({
    super.key,
    required this.onManualTap,
    required this.onScanTap,
  });

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
          const SizedBox(height: 20),

          // Opsi "Isi Manual"
          _buildOption(
            context,
            icon: Icons.edit_note_rounded,
            label: 'Isi Manual',
            onTap: onManualTap,
          ),
          const Divider(height: 1),

          // Opsi "Scan ISBN"
          _buildOption(
            context,
            icon: Icons.qr_code_scanner_rounded,
            label: 'Scan ISBN',
            onTap: onScanTap,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  /// Widget opsi individual dalam dialog.
  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textSecondary,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    );
  }
}
