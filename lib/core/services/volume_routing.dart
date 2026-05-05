import 'dart:io';

import 'package:flutter/services.dart';

/// Routes hardware volume buttons to the media stream while a screen is
/// mounted. Android-only — iOS already routes to the media stream by default
/// when [video_player] / AVPlayer is on screen.
class VolumeRouting {
  static const _channel = MethodChannel('com.lehiboo.app/volume_routing');

  static Future<void> useMediaStream() async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('setMediaStream');
    } on PlatformException {
      // Non-fatal: buttons fall back to the system default routing.
    }
  }

  static Future<void> restoreDefault() async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('restoreDefault');
    } on PlatformException {
      // Non-fatal.
    }
  }
}
