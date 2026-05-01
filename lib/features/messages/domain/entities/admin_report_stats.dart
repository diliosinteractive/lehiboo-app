import 'package:equatable/equatable.dart';

class AdminReportStats extends Equatable {
  final int pending;
  final int reviewed;
  final int dismissed;
  final int total;

  const AdminReportStats({
    required this.pending,
    required this.reviewed,
    required this.dismissed,
    required this.total,
  });

  @override
  List<Object?> get props => [pending, reviewed, dismissed, total];
}
