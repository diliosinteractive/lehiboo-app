import 'package:freezed_annotation/freezed_annotation.dart';

part 'city.freezed.dart';

@freezed
class City with _$City {
  const factory City({
    required String id,
    required String name,
    required String slug,
    double? lat,
    double? lng,
    String? region,
  }) = _City;
}
