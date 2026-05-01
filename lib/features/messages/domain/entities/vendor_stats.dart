import 'package:equatable/equatable.dart';

class VendorStats extends Equatable {
  final int clientTotal;
  final int clientUnread;
  final int supportTotal;
  final int supportUnread;

  const VendorStats({
    required this.clientTotal,
    required this.clientUnread,
    required this.supportTotal,
    required this.supportUnread,
  });

  @override
  List<Object?> get props =>
      [clientTotal, clientUnread, supportTotal, supportUnread];
}
