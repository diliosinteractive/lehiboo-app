/// Body of `POST /vendor/tickets/{uuid}/check-in`. All fields optional but
/// recommended — they show up in the admin audit dashboard.
///
/// Spec: docs/MOBILE_CHECKIN_SPEC.md §4.1.
class CheckinRequestDto {
  final String? deviceId;
  final String? deviceName;
  final String? gate;
  final String scanMethod; // qr_code | manual | nfc | barcode

  const CheckinRequestDto({
    this.deviceId,
    this.deviceName,
    this.gate,
    this.scanMethod = 'qr_code',
  });

  Map<String, dynamic> toJson() => {
        if (deviceId != null && deviceId!.isNotEmpty) 'device_id': deviceId,
        if (deviceName != null && deviceName!.isNotEmpty)
          'device_name': deviceName,
        if (gate != null && gate!.isNotEmpty) 'gate': gate,
        'scan_method': scanMethod,
      };
}
