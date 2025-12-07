import 'package:freezed_annotation/freezed_annotation.dart';

part 'city.freezed.dart';
part 'city.g.dart';

@freezed
class City with _$City {
  const factory City({
    required String id,
    required String name,
    required String slug,
    double? lat,
    double? lng,
    String? region,
    String? description, // New field for detailed page
    String? imageUrl,    // New field for cover image
    int? eventCount,     // Number of events in this city
  }) = _City;

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}
