import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart';
import '../../../../domain/entities/city.dart';

final citiesProvider = FutureProvider<List<City>>((ref) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getCities();
});
