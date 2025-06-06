import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../../../app/theme/dimensions.dart';

class QRScannerWidget extends StatefulWidget {
  final Function(String) onQRScanned;
  final VoidCallback? onError;

  const QRScannerWidget({
    super.key,
    required this.onQRScanned,
    this.onError,
  });

  @override
  State<QRScannerWidget> createState() => _QRScannerWidgetState();
}

class _QRScannerWidgetState extends State<QRScannerWidget> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool hasScanned = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: Theme.of(context).primaryColor,
            borderRadius: AppDimensions.radiusMedium,
            borderLength: AppDimensions.qrScannerBorderLength,
            borderWidth: AppDimensions.qrScannerBorderWidth,
            cutOutSize: AppDimensions.qrScannerSize,
          ),
        ),
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingLarge,
                vertical: AppDimensions.paddingMedium,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              ),
              child: Text(
                'Position the QR code within the frame',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                icon: Icons.flash_on,
                onPressed: () async {
                  await controller?.toggleFlash();
                },
              ),
              _buildControlButton(
                icon: Icons.flip_camera_ios,
                onPressed: () async {
                  await controller?.flipCamera();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    
    controller.scannedDataStream.listen((scanData) {
      if (!hasScanned && scanData.code != null) {
        hasScanned = true;
        controller.pauseCamera();
        
        widget.onQRScanned(scanData.code!);
      }
    }, onError: (error) {
      widget.onError?.call();
    });
  }

  void resetScanner() {
    hasScanned = false;
    controller?.resumeCamera();
  }
}