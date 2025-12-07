import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/thematiques_api_datasource.dart';
import '../../data/models/thematique_dto.dart';

/// Provider for all thematiques
final thematiquesProvider = FutureProvider<List<ThematiqueDto>>((ref) async {
  final datasource = ref.watch(thematiquesApiDatasourceProvider);
  return await datasource.getThematiques();
});
