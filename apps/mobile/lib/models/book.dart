import 'package:uuid/uuid.dart';
import 'package:bookshelf/app/constants.dart';

/// Generator UUID global (v4 random).
const _uuid = Uuid();

/// Model data buku.
/// Field-field disesuaikan dengan API contract (api.yaml) dan kebutuhan lokal.
class Book {
  /// Primary key lokal — UUID v4 string.
  final String id;

  final String title;
  final String author;
  final String genre;
  final int pageMax;
  int pageCurrent;
  final String? description;
  String? note;
  int? rating;
  ReadingStatus status;
  final String? isbn;
  final String? coverUrl;

  /// Flag sinkronisasi — true jika data sudah ter-sync ke server.
  bool isSynced;

  /// Timestamp terakhir kali di-sync ke server.
  DateTime? lastSyncedAt;

  final DateTime createdAt;
  DateTime updatedAt;

  Book({
    String? id,
    required this.title,
    required this.author,
    required this.genre,
    required this.pageMax,
    this.pageCurrent = 0,
    this.description,
    this.note,
    this.rating,
    this.status = ReadingStatus.belumDibaca,
    this.isbn,
    this.coverUrl,
    this.isSynced = false,
    this.lastSyncedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? _uuid.v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  /// Hitung persentase progres baca (0.0 – 1.0).
  double get progressPercent {
    if (pageMax <= 0) return 0.0;
    return (pageCurrent / pageMax).clamp(0.0, 1.0);
  }

  /// Hitung persentase progres sebagai integer (0 – 100).
  int get progressPercentInt => (progressPercent * 100).round();

  /// Konversi dari JSON (response API).
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id']?.toString(),
      title: json['title'] as String? ?? '',
      author: json['author'] as String? ?? '',
      genre: json['genre'] as String? ?? '',
      pageMax: json['page_max'] as int? ?? 0,
      pageCurrent: json['page_current'] as int? ?? 0,
      description: json['description'] as String?,
      note: json['note'] as String?,
      rating: json['rating'] as int?,
      status: _parseStatus(json['progress'] as String?),
      isbn: json['isbn'] as String?,
    );
  }

  /// Konversi ke JSON (request API).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'genre': genre,
      'page_max': pageMax,
      'page_current': pageCurrent,
      'description': description,
      'note': note,
      'rating': rating,
      'progress': status.name,
      'isbn': isbn,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Parse status string dari API ke enum ReadingStatus.
  static ReadingStatus _parseStatus(String? value) {
    switch (value) {
      case 'sedangDibaca':
        return ReadingStatus.sedangDibaca;
      case 'selesai':
        return ReadingStatus.selesai;
      default:
        return ReadingStatus.belumDibaca;
    }
  }
}

/// Data dummy untuk demo UI.
/// Akan diganti dengan data dari IsarDB di tahap selanjutnya.
final List<Book> dummyBooks = [
  Book(
    title: 'Seporsi Mie Ayam Sebelum Mati',
    author: 'Henry Manampiring',
    genre: 'Filsafat Teras',
    pageMax: 346,
    pageCurrent: 120,
    status: ReadingStatus.sedangDibaca,
    rating: 4,
    isbn: '978-6-02412-518-9',
    note:
        'Kota atau daerah list buku yang wajib dikunjungi minimal '
        'untuk seumur hidup. Ya kita tentunya masukkan buku ini. '
        'Keunikan penerbitan dari objek PO sampai buku ini bisa ada '
        'pakek kenner-kenner, serpiden, berbicara lebih dan serpoden.',
  ),
  Book(
    title: 'Atomic Habits',
    author: 'James Clear',
    genre: 'Self-Improvement',
    pageMax: 320,
    pageCurrent: 320,
    status: ReadingStatus.selesai,
    rating: 5,
    isbn: '978-0-7352-1129-2',
    note: 'Buku bagus untuk membangun kebiasaan baik.',
  ),
  Book(
    title: 'Filosofi Teras',
    author: 'Henry Manampiring',
    genre: 'Filsafat Teras',
    pageMax: 250,
    pageCurrent: 0,
    status: ReadingStatus.belumDibaca,
    isbn: '978-602-0633-76-0',
  ),
  Book(
    title: 'Laskar Pelangi',
    author: 'Andrea Hirata',
    genre: 'Novel',
    pageMax: 529,
    pageCurrent: 200,
    status: ReadingStatus.sedangDibaca,
    rating: 4,
  ),
  Book(
    title: 'Bumi Manusia',
    author: 'Pramoedya Ananta Toer',
    genre: 'Novel',
    pageMax: 535,
    pageCurrent: 535,
    status: ReadingStatus.selesai,
    rating: 5,
    note: 'Masterpiece sastra Indonesia.',
  ),
];
