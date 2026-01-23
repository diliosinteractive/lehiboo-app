import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:lehiboo/core/themes/colors.dart';

enum QRCodeSize {
  medium,  // 200px - for detail screens
  large,   // 280px - for bottom sheets
  fullscreen, // 300px - for fullscreen display
}

extension QRCodeSizeExtension on QRCodeSize {
  double get dimension {
    switch (this) {
      case QRCodeSize.medium:
        return 200;
      case QRCodeSize.large:
        return 280;
      case QRCodeSize.fullscreen:
        return 300;
    }
  }
}

class LargeQRCode extends StatelessWidget {
  final String data;
  final QRCodeSize size;
  final bool showLogo;
  final String? codeLabel;
  final Color backgroundColor;
  final Color foregroundColor;

  const LargeQRCode({
    super.key,
    required this.data,
    this.size = QRCodeSize.medium,
    this.showLogo = false,
    this.codeLabel,
    this.backgroundColor = Colors.white,
    this.foregroundColor = HbColors.textPrimary,
  });

  const LargeQRCode.large({
    super.key,
    required this.data,
    this.showLogo = false,
    this.codeLabel,
    this.backgroundColor = Colors.white,
    this.foregroundColor = HbColors.textPrimary,
  }) : size = QRCodeSize.large;

  const LargeQRCode.fullscreen({
    super.key,
    required this.data,
    this.showLogo = false,
    this.codeLabel,
    this.backgroundColor = Colors.white,
    this.foregroundColor = HbColors.textPrimary,
  }) : size = QRCodeSize.fullscreen;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // QR Code container with rounded corners and shadow
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: QrImageView(
            data: data,
            version: QrVersions.auto,
            size: size.dimension,
            backgroundColor: backgroundColor,
            eyeStyle: QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: foregroundColor,
            ),
            dataModuleStyle: QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: foregroundColor,
            ),
            embeddedImage: showLogo
                ? const AssetImage('assets/images/logo_picto_lehiboo.png')
                : null,
            embeddedImageStyle: showLogo
                ? QrEmbeddedImageStyle(
                    size: Size(
                      size.dimension * 0.2,
                      size.dimension * 0.2,
                    ),
                  )
                : null,
            errorCorrectionLevel: showLogo
                ? QrErrorCorrectLevel.H // High error correction for logo
                : QrErrorCorrectLevel.M,
          ),
        ),
        // Code label
        if (codeLabel != null && codeLabel!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: HbColors.orangePastel,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              codeLabel!,
              style: TextStyle(
                fontSize: size == QRCodeSize.fullscreen ? 16 : 14,
                fontWeight: FontWeight.w600,
                color: HbColors.textPrimary,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class QRCodeWithInfo extends StatelessWidget {
  final String qrData;
  final String title;
  final String? subtitle;
  final QRCodeSize size;

  const QRCodeWithInfo({
    super.key,
    required this.qrData,
    required this.title,
    this.subtitle,
    this.size = QRCodeSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LargeQRCode(
          data: qrData,
          size: size,
          codeLabel: _extractCode(qrData),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: HbColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null && subtitle!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: const TextStyle(
              fontSize: 14,
              color: HbColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  String _extractCode(String data) {
    // Try to extract a readable code from QR data
    // If it's a URL, try to get the last segment
    if (data.contains('/')) {
      final segments = data.split('/');
      final lastSegment = segments.lastWhere(
        (s) => s.isNotEmpty,
        orElse: () => data,
      );
      if (lastSegment.length <= 16) {
        return lastSegment.toUpperCase();
      }
    }
    // If data is short enough, return it
    if (data.length <= 16) {
      return data.toUpperCase();
    }
    // Otherwise truncate
    return '${data.substring(0, 12).toUpperCase()}...';
  }
}
