import 'package:flutter/material.dart';
import 'package:bookshelf/app/theme.dart';
import 'package:bookshelf/app/constants.dart';
import 'package:bookshelf/models/book.dart';
import 'package:bookshelf/views/home/widgets/book_search_bar.dart';
import 'package:bookshelf/views/home/widgets/status_filter_chips.dart';
import 'package:bookshelf/views/home/widgets/book_card.dart';
import 'package:bookshelf/views/book/book_detail_page.dart';
import 'package:bookshelf/views/book/add_book_page.dart';
import 'package:bookshelf/views/book/widgets/add_book_method_dialog.dart';
import 'package:bookshelf/views/profile/profile_page.dart';

/// Halaman utama, Penyimpanan Koleksi Buku.
/// Menampilkan daftar buku user dengan search, filter status, dan FAB tambah.
class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, this.username = 'User'});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Filter status yang aktif: 0=Semua, 1=Sedang Dibaca, 2=Selesai.
  int _selectedFilter = 0;

  /// Query pencarian.
  String _searchQuery = '';

  /// Daftar buku — saat ini dummy, nanti dari IsarDB.
  final List<Book> _books = List.from(dummyBooks);

  /// Daftar buku yang sudah difilter & dicari.
  List<Book> get _filteredBooks {
    var result = _books;

    // Filter berdasarkan status
    if (_selectedFilter == 1) {
      result = result
          .where((b) => b.status == ReadingStatus.sedangDibaca)
          .toList();
    } else if (_selectedFilter == 2) {
      result = result.where((b) => b.status == ReadingStatus.selesai).toList();
    }

    // Filter berdasarkan search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((b) {
        return b.title.toLowerCase().contains(query) ||
            b.author.toLowerCase().contains(query);
      }).toList();
    }

    return result;
  }

  /// Tampilkan dialog pilih metode tambah buku.
  void _showAddBookDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddBookMethodDialog(
        onManualTap: () {
          Navigator.pop(context);
          _navigateToAddBook();
        },
        onScanTap: () {
          Navigator.pop(context);
          _navigateToScanISBN();
        },
      ),
    );
  }

  /// Navigasi ke halaman tambah buku (manual).
  void _navigateToAddBook() async {
    final result = await Navigator.push<Book>(
      context,
      MaterialPageRoute(builder: (_) => const AddBookPage()),
    );

    // Tambahkan buku baru ke list jika ada result
    if (result != null) {
      setState(() {
        _books.add(result);
      });
    }
  }

  /// Navigasi ke halaman scan barcode ISBN.
  void _navigateToScanISBN() {
    // TODO: navigasi ke ScanBarcodePage (tahap selanjutnya)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur scan ISBN — coming soon!')),
    );
  }

  /// Navigasi ke halaman detail buku.
  void _navigateToDetail(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BookDetailPage(book: book)),
    );
  }

  /// Navigasi ke halaman profil & sinkronisasi.
  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProfilePage(username: widget.username)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Header: avatar + greeting + profil
              _buildHeader(),
              const SizedBox(height: 20),

              // Search bar
              BookSearchBar(
                onChanged: (query) {
                  setState(() => _searchQuery = query);
                },
              ),
              const SizedBox(height: 16),

              // Label "Pilih Status Baca Bukumu"
              Text(
                'Pilih Status Baca Bukumu',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),

              // Filter chips
              StatusFilterChips(
                selectedIndex: _selectedFilter,
                onSelected: (index) {
                  setState(() => _selectedFilter = index);
                },
              ),
              const SizedBox(height: 16),

              // Daftar buku
              Expanded(child: _buildBookList()),
            ],
          ),
        ),
      ),

      // FAB tambah buku
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBookDialog,
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// Header: avatar user, greeting, dan tombol profil.
  Widget _buildHeader() {
    return Row(
      children: [
        // Avatar user
        GestureDetector(
          onTap: _navigateToProfile,
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFE53935),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 28),
          ),
        ),
        const SizedBox(width: 12),

        // Greeting & status
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, ${widget.username}!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.wifi_off_rounded,
                    size: 14,
                    color: AppColors.offline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Anda sedang offline',
                    style: TextStyle(color: AppColors.offline, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// List buku menggunakan ListView.builder untuk efisiensi.
  Widget _buildBookList() {
    final books = _filteredBooks;

    if (books.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_rounded, size: 64, color: AppColors.divider),
            const SizedBox(height: 16),
            Text(
              'Belum ada buku',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Tekan tombol + untuk menambah buku baru',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        return BookCard(
          book: books[index],
          onTap: () => _navigateToDetail(books[index]),
        );
      },
    );
  }
}
