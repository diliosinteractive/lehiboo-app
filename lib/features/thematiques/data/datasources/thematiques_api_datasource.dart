import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/config/dio_client.dart';
import '../models/thematique_dto.dart';

final thematiquesApiDatasourceProvider = Provider<ThematiquesApiDatasource>((ref) {
  return ThematiquesApiDatasource();
});

class ThematiquesApiDatasource {
  Future<List<ThematiqueDto>> getThematiques({bool includeCount = true}) async {
    final dio = DioClient.instance;

    final response = await dio.get(
      '/thematiques',
      queryParameters: {
        'include_count': includeCount.toString(),
        'per_page': '100',
        'number': '100',
        'limit': '100',
        'posts_per_page': '100',
      },
    );

    if (response.statusCode == 200) {
      final data = response.data['data'] as Map<String, dynamic>;
      final thematiquesJson = data['thematiques'] as List<dynamic>;

      return thematiquesJson
          .map((json) => ThematiqueDto.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to load thematiques');
  }
}
