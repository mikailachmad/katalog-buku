/// Konstanta yang digunakan di seluruh aplikasi Bookshelf.
class AppConstants {
  AppConstants._();

  // Nama aplikasi
  static const String appName = 'Bookshelf';

  // Daftar genre buku yang tersedia
  static const List<String> genres = [
    'Fiksi',
    'Non-Fiksi',
    'Filsafat Teras',
    'Self-Improvement',
    'Teknologi',
    'Bisnis',
    'Sejarah',
    'Sains',
    'Novel',
    'Komik',
    'Agama',
    'Lainnya',
  ];
}

/// Status progres membaca buku.
enum ReadingStatus {
  belumDibaca('Belum Dibaca'),
  sedangDibaca('Sedang Dibaca'),
  selesai('Selesai');

  final String label;
  const ReadingStatus(this.label);
}
