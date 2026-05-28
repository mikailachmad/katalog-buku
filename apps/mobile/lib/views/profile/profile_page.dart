import 'package:flutter/material.dart';
import 'package:bookshelf/app/theme.dart';

/// Halaman Profil & Sinkronisasi.
/// Menampilkan avatar user, status online/offline, info sync terakhir,dan tombol sinkronisasi data ke server.
class ProfilePage extends StatelessWidget {
  final String username;

  const ProfilePage({super.key, this.username = 'User'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Bookshelf'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // TODO: edit profil
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar besar
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFFE53935),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 56),
              ),
              const SizedBox(height: 20),

              // Nama user
              Text(
                'Halo, $username!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),

              // Badge offline
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.offline.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      size: 16,
                      color: AppColors.offline,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Anda sedang offline',
                      style: TextStyle(color: AppColors.offline, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Info sync terakhir
              Text(
                'Terakhir Sinkronisasi: 22 Mei 2026, 20:26',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),

              // Tombol sinkronisasi
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: implementasi sync ke server
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sinkronisasi — coming soon!'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.sync_rounded),
                  label: const Text('Sinkronisasi Data ke Server'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
