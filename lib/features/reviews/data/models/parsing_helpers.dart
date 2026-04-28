// Helpers de parsing partagés par les DTOs reviews (robustes aux formats
// snake_case / camelCase et aux types numériques string/int/double).

String parseString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

String? parseStringOrNull(dynamic value) {
  if (value == null) return null;
  if (value is String) return value.isEmpty ? null : value;
  return value.toString();
}

int parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is double) return value.toInt();
  return 0;
}

double parseDouble(dynamic value) {
  if (value == null) return 0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

bool parseBool(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is int) return value != 0;
  if (value is String) {
    return value.toLowerCase() == 'true' || value == '1';
  }
  return false;
}

bool? parseBoolOrNull(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is int) return value != 0;
  if (value is String) {
    if (value.toLowerCase() == 'true' || value == '1') return true;
    if (value.toLowerCase() == 'false' || value == '0') return false;
  }
  return null;
}
