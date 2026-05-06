class OrderBookingDto {
  final String uuid;
  final String? eventTitle;
  final double totalAmount;

  const OrderBookingDto({
    required this.uuid,
    this.eventTitle,
    required this.totalAmount,
  });

  factory OrderBookingDto.fromJson(Map<String, dynamic> json) {
    return OrderBookingDto(
      uuid: json['uuid']?.toString() ?? '',
      eventTitle:
          json['eventTitle']?.toString() ?? json['event_title']?.toString(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ??
          (json['total_amount'] as num?)?.toDouble() ??
          0,
    );
  }
}

class CreateOrderResponseDto {
  final String uuid;
  final String status;
  final double totalAmount;
  final String? expiresAt;
  final List<OrderBookingDto> bookings;

  const CreateOrderResponseDto({
    required this.uuid,
    required this.status,
    required this.totalAmount,
    this.expiresAt,
    this.bookings = const [],
  });

  factory CreateOrderResponseDto.fromJson(Map<String, dynamic> json) {
    final bookingsRaw = json['bookings'];

    return CreateOrderResponseDto(
      uuid: json['uuid']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ??
          (json['total_amount'] as num?)?.toDouble() ??
          0,
      expiresAt:
          json['expiresAt']?.toString() ?? json['expires_at']?.toString(),
      bookings: bookingsRaw is List
          ? bookingsRaw
              .whereType<Map>()
              .map((item) =>
                  OrderBookingDto.fromJson(Map<String, dynamic>.from(item)))
              .where((booking) => booking.uuid.isNotEmpty)
              .toList()
          : const [],
    );
  }
}

class OrderPaymentIntentResponseDto {
  final String clientSecret;
  final String paymentIntentId;
  final int amount;

  const OrderPaymentIntentResponseDto({
    required this.clientSecret,
    required this.paymentIntentId,
    required this.amount,
  });

  factory OrderPaymentIntentResponseDto.fromJson(Map<String, dynamic> json) {
    return OrderPaymentIntentResponseDto(
      clientSecret: json['clientSecret']?.toString() ?? '',
      paymentIntentId: json['paymentIntentId']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toInt() ?? 0,
    );
  }
}
