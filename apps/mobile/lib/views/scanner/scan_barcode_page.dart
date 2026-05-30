import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:bookshelf/app/theme.dart';
import 'package:bookshelf/views/scanner/check_isbn_page.dart';

/// Halaman Scan Barcode ISBN.
/// Menampilkan kamera dengan overlay kotak scan di tengah.
/// Sesuai desain: "Posisikan barcode ISBN buku di dalam kotak..."
class ScanBarcodePage extends StatefulWidget {
  const ScanBarcodePage({super.key});

  @override
  State<ScanBarcodePage> createState() => _ScanBarcodePageState();
}

class _ScanBarcodePageState extends State<ScanBarcodePage> {
  final MobileScannerController _cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  bool _isDetected = false;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  /// Callback saat barcode terdeteksi.
  void _onDetect(BarcodeCapture capture) {
    if (_isDetected) return; // Prevent multiple detections

    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    final isbn = barcode.rawValue!;
    _isDetected = true;

    // Navigasi ke halaman cek ISBN
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CheckIsbnPage(isbn: isbn),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan Barcode ISBN'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          // Toggle flash
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _cameraController.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Kamera
          MobileScanner(
            controller: _cameraController,
            onDetect: _onDetect,
          ),

          // Overlay gelap + kotak scan di tengah
          _buildScanOverlay(),

          // Text info di bawah
          Positioned(
            bottom: 80,
            left: 24,
            right: 24,
            child: Column(
              children: [
                Text(
                  'Posisikan barcode ISBN buku di dalam\n'
                  'kotak untuk memindai otomatis.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                // Tombol manual ISBN
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CheckIsbnPage(isbn: ''),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Masukkan ISBN Manual'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Overlay gelap dengan kotak transparan di tengah.
  Widget _buildScanOverlay() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scanAreaSize = constraints.maxWidth * 0.7;
        final top = (constraints.maxHeight - scanAreaSize) / 2 - 40;

        return Stack(
          children: [
            // Background gelap semi-transparan
            Container(color: Colors.black.withValues(alpha: 0.5)),

            // Kotak scan transparan
            Positioned(
              top: top,
              left: (constraints.maxWidth - scanAreaSize) / 2,
              child: Container(
                width: scanAreaSize,
                height: scanAreaSize,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.accent, width: 3),
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.transparent,
                ),
              ),
            ),

            // Clear area di tengah (remove overlay di area scan)
            ClipPath(
              clipper: _ScanAreaClipper(
                scanAreaSize: scanAreaSize,
                top: top,
              ),
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
          ],
        );
      },
    );
  }
}

/// Custom clipper untuk membuat lubang transparan di area scan.
class _ScanAreaClipper extends CustomClipper<Path> {
  final double scanAreaSize;
  final double top;

  _ScanAreaClipper({required this.scanAreaSize, required this.top});

  @override
  Path getClip(Size size) {
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final scanRect = Rect.fromLTWH(
      (size.width - scanAreaSize) / 2,
      top,
      scanAreaSize,
      scanAreaSize,
    );

    path.addRRect(
      RRect.fromRectAndRadius(scanRect, const Radius.circular(16)),
    );

    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
