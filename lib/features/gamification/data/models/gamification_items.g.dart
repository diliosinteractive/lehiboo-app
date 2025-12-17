// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AchievementImpl _$$AchievementImplFromJson(Map<String, dynamic> json) =>
    _$AchievementImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      iconUrl: json['iconUrl'] as String,
      category: json['category'] as String,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      progressCurrent: (json['progressCurrent'] as num).toInt(),
      progressTarget: (json['progressTarget'] as num).toInt(),
      unlockedAt: json['unlockedAt'] == null
          ? null
          : DateTime.parse(json['unlockedAt'] as String),
    );

Map<String, dynamic> _$$AchievementImplToJson(_$AchievementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'iconUrl': instance.iconUrl,
      'category': instance.category,
      'isUnlocked': instance.isUnlocked,
      'progressCurrent': instance.progressCurrent,
      'progressTarget': instance.progressTarget,
      'unlockedAt': instance.unlockedAt?.toIso8601String(),
    };

_$ChallengeImpl _$$ChallengeImplFromJson(Map<String, dynamic> json) =>
    _$ChallengeImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      rewardHibons: (json['rewardHibons'] as num).toInt(),
      rewardXp: (json['rewardXp'] as num).toInt(),
      progressCurrent: (json['progressCurrent'] as num).toInt(),
      progressTarget: (json['progressTarget'] as num).toInt(),
      isCompleted: json['isCompleted'] as bool? ?? false,
      isClaimed: json['isClaimed'] as bool? ?? false,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$$ChallengeImplToJson(_$ChallengeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'rewardHibons': instance.rewardHibons,
      'rewardXp': instance.rewardXp,
      'progressCurrent': instance.progressCurrent,
      'progressTarget': instance.progressTarget,
      'isCompleted': instance.isCompleted,
      'isClaimed': instance.isClaimed,
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };
