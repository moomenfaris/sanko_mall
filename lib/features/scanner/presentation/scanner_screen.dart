import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/navigation/tab_provider.dart';
import 'product_detail_sheet.dart';
import 'product_provider.dart';

/// Live camera barcode scanner. On a successful scan it looks up the product
/// and presents the detail sheet. Debounced so one barcode fires once.
class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen>
    with WidgetsBindingObserver {
  final MobileScannerController _controller = MobileScannerController();
  static const Duration _notFoundCooldown = Duration(seconds: 3);
  bool _busy = false;
  bool _scannerEnabled = false;
  String? _lastUnavailableBarcode;
  DateTime? _lastUnavailableAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setScanning(ref.read(selectedTabProvider) == ShellTabs.scanner);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) _setScanning(false);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  /// MobileScanner starts the camera in initState and stops it in dispose,
  /// so mounting or unmounting the preview is what toggles the hardware.
  void _setScanning(bool enabled) {
    if (_scannerEnabled == enabled || !mounted) return;
    setState(() => _scannerEnabled = enabled);
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_busy) return;
    final code = capture.barcodes.firstOrNull?.rawValue;
    if (code == null) return;

    setState(() => _busy = true);
    final l = AppLocalizations.of(context);
    final product = await ref.read(productByBarcodeProvider(code).future);

    if (!mounted) return;
    if (product == null) {
      final now = DateTime.now();
      final isSameBarcode = _lastUnavailableBarcode == code;
      final inCooldown =
          _lastUnavailableAt != null &&
          now.difference(_lastUnavailableAt!) < _notFoundCooldown;

      if (!(isSameBarcode && inCooldown)) {
        _lastUnavailableBarcode = code;
        _lastUnavailableAt = now;
        final messenger = ScaffoldMessenger.of(context);
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(
            content: Text(l.t('product_not_found')),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      await ProductDetailSheet.show(context, product);
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final overlayBottom = bottomInset > 24 ? bottomInset + 16 : 40.0;

    ref.listen<int>(selectedTabProvider, (_, next) {
      _setScanning(next == ShellTabs.scanner);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l.t('scanner')),
        actions: [
          IconButton(
            onPressed: () => _controller.toggleTorch(),
            icon: const Icon(Icons.flash_on),
          ),
        ],
      ),
      body: _scannerEnabled
          ? Stack(
              fit: StackFit.expand,
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect,
                  fit: BoxFit.cover,
                  placeholderBuilder: (_) => const ColoredBox(
                    color: Colors.black,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                  errorBuilder: (context, error) => _CameraError(
                    message:
                        error.errorDetails?.message ?? error.errorCode.name,
                    retryLabel: l.t('start_scanning'),
                    onRetry: () {
                      _setScanning(false);
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _setScanning(true),
                      );
                    },
                  ),
                ),
                Center(
                  child: Container(
                    width: 280,
                    height: 180,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF43D57E),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Positioned(
                  bottom: overlayBottom,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(
                        l.t('scan_hint'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const SizedBox.expand(),
    );
  }
}

class _CameraError extends StatelessWidget {
  const _CameraError({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.videocam_off_rounded,
                color: Colors.white70,
                size: 56,
              ),
              const SizedBox(height: 14),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 18),
              FilledButton(onPressed: onRetry, child: Text(retryLabel)),
            ],
          ),
        ),
      ),
    );
  }
}
