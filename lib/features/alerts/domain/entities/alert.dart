import 'package:equatable/equatable.dart';
import '../../../search/domain/models/event_filter.dart';

class Alert extends Equatable {
  final String id;
  final String name;
  final EventFilter filter;
  final bool enablePush;
  final bool enableEmail;
  final DateTime createdAt;

  const Alert({
    required this.id,
    required this.name,
    required this.filter,
    this.enablePush = true,
    this.enableEmail = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, filter, enablePush, enableEmail, createdAt];
}
