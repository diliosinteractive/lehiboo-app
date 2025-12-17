// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hibons_wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HibonsWalletImpl _$$HibonsWalletImplFromJson(Map<String, dynamic> json) =>
    _$HibonsWalletImpl(
      userId: json['userId'] as String,
      balance: (json['balance'] as num?)?.toInt() ?? 0,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      rank: json['rank'] as String? ?? 'Hibou Curieux',
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      streakShieldActive: json['streakShieldActive'] as bool? ?? false,
      lastActionDate: json['lastActionDate'] == null
          ? null
          : DateTime.parse(json['lastActionDate'] as String),
    );

Map<String, dynamic> _$$HibonsWalletImplToJson(_$HibonsWalletImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'balance': instance.balance,
      'xp': instance.xp,
      'level': instance.level,
      'rank': instance.rank,
      'currentStreak': instance.currentStreak,
      'streakShieldActive': instance.streakShieldActive,
      'lastActionDate': instance.lastActionDate?.toIso8601String(),
    };
