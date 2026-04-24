class UnreadCountDto {
  final int count;
  const UnreadCountDto({required this.count});

  factory UnreadCountDto.fromJson(Map<String, dynamic> json) {
    return UnreadCountDto(count: json['count'] as int? ?? 0);
  }
}
