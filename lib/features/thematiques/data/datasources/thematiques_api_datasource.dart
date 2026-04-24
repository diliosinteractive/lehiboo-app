import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/config/dio_client.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';
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

    final list = ApiResponseHandler.extractList(response.data, key: 'thematiques');
    return list
        .map((json) => ThematiqueDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
