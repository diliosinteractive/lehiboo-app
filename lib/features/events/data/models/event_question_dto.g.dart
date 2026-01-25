// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_question_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventQuestionsResponseDtoImpl _$$EventQuestionsResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$EventQuestionsResponseDtoImpl(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => EventQuestionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      meta: json['meta'] == null
          ? null
          : MetaPaginationDto.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$EventQuestionsResponseDtoImplToJson(
        _$EventQuestionsResponseDtoImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'meta': instance.meta,
    };

_$EventQuestionDtoImpl _$$EventQuestionDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$EventQuestionDtoImpl(
      uuid: json['uuid'] as String,
      question: json['question'] == null ? '' : _parseString(json['question']),
      status: json['status'] == null ? 'pending' : _parseString(json['status']),
      helpfulCount:
          json['helpful_count'] == null ? 0 : _parseInt(json['helpful_count']),
      helpfulCountCamel:
          json['helpfulCount'] == null ? 0 : _parseInt(json['helpfulCount']),
      isPublic:
          json['is_public'] == null ? true : _parseBool(json['is_public']),
      isPublicCamel:
          json['isPublic'] == null ? true : _parseBool(json['isPublic']),
      isPinned:
          json['is_pinned'] == null ? false : _parseBool(json['is_pinned']),
      isPinnedCamel:
          json['isPinned'] == null ? false : _parseBool(json['isPinned']),
      isAnswered:
          json['is_answered'] == null ? false : _parseBool(json['is_answered']),
      isAnsweredCamel:
          json['isAnswered'] == null ? false : _parseBool(json['isAnswered']),
      hasAnswer:
          json['has_answer'] == null ? false : _parseBool(json['has_answer']),
      hasAnswerCamel:
          json['hasAnswer'] == null ? false : _parseBool(json['hasAnswer']),
      author: json['author'] == null
          ? null
          : QuestionAuthorDto.fromJson(json['author'] as Map<String, dynamic>),
      answer: json['answer'] == null
          ? null
          : QuestionAnswerDto.fromJson(json['answer'] as Map<String, dynamic>),
      userVoted:
          json['user_voted'] == null ? false : _parseBool(json['user_voted']),
      userVotedCamel:
          json['userVoted'] == null ? false : _parseBool(json['userVoted']),
      createdAtFormatted: json['created_at_formatted'] == null
          ? ''
          : _parseString(json['created_at_formatted']),
      createdAtFormattedCamel: json['createdAtFormatted'] == null
          ? ''
          : _parseString(json['createdAtFormatted']),
    );

Map<String, dynamic> _$$EventQuestionDtoImplToJson(
        _$EventQuestionDtoImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'question': instance.question,
      'status': instance.status,
      'helpful_count': instance.helpfulCount,
      'helpfulCount': instance.helpfulCountCamel,
      'is_public': instance.isPublic,
      'isPublic': instance.isPublicCamel,
      'is_pinned': instance.isPinned,
      'isPinned': instance.isPinnedCamel,
      'is_answered': instance.isAnswered,
      'isAnswered': instance.isAnsweredCamel,
      'has_answer': instance.hasAnswer,
      'hasAnswer': instance.hasAnswerCamel,
      'author': instance.author,
      'answer': instance.answer,
      'user_voted': instance.userVoted,
      'userVoted': instance.userVotedCamel,
      'created_at_formatted': instance.createdAtFormatted,
      'createdAtFormatted': instance.createdAtFormattedCamel,
    };

_$QuestionAuthorDtoImpl _$$QuestionAuthorDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$QuestionAuthorDtoImpl(
      name: json['name'] == null ? '' : _parseString(json['name']),
      avatar: _parseStringOrNull(json['avatar']),
      initials: json['initials'] == null ? '' : _parseString(json['initials']),
      isGuest: json['is_guest'] == null ? false : _parseBool(json['is_guest']),
      isGuestCamel:
          json['isGuest'] == null ? false : _parseBool(json['isGuest']),
    );

Map<String, dynamic> _$$QuestionAuthorDtoImplToJson(
        _$QuestionAuthorDtoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'avatar': instance.avatar,
      'initials': instance.initials,
      'is_guest': instance.isGuest,
      'isGuest': instance.isGuestCamel,
    };

_$QuestionAnswerDtoImpl _$$QuestionAnswerDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$QuestionAnswerDtoImpl(
      uuid: json['uuid'] as String,
      answer: json['answer'] == null ? '' : _parseString(json['answer']),
      isOfficial:
          json['is_official'] == null ? true : _parseBool(json['is_official']),
      isOfficialCamel:
          json['isOfficial'] == null ? true : _parseBool(json['isOfficial']),
      organizationId: _parseStringOrNull(json['organization_id']),
      organizationIdCamel: _parseStringOrNull(json['organizationId']),
      organizationName: json['organization_name'] == null
          ? ''
          : _parseString(json['organization_name']),
      organizationNameCamel: json['organizationName'] == null
          ? ''
          : _parseString(json['organizationName']),
      createdAtFormatted: json['created_at_formatted'] == null
          ? ''
          : _parseString(json['created_at_formatted']),
      createdAtFormattedCamel: json['createdAtFormatted'] == null
          ? ''
          : _parseString(json['createdAtFormatted']),
    );

Map<String, dynamic> _$$QuestionAnswerDtoImplToJson(
        _$QuestionAnswerDtoImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'answer': instance.answer,
      'is_official': instance.isOfficial,
      'isOfficial': instance.isOfficialCamel,
      'organization_id': instance.organizationId,
      'organizationId': instance.organizationIdCamel,
      'organization_name': instance.organizationName,
      'organizationName': instance.organizationNameCamel,
      'created_at_formatted': instance.createdAtFormatted,
      'createdAtFormatted': instance.createdAtFormattedCamel,
    };

_$MetaPaginationDtoImpl _$$MetaPaginationDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$MetaPaginationDtoImpl(
      currentPage:
          json['current_page'] == null ? 1 : _parseInt(json['current_page']),
      lastPage: json['last_page'] == null ? 1 : _parseInt(json['last_page']),
      perPage: json['per_page'] == null ? 15 : _parseInt(json['per_page']),
      total: json['total'] == null ? 0 : _parseInt(json['total']),
    );

Map<String, dynamic> _$$MetaPaginationDtoImplToJson(
        _$MetaPaginationDtoImpl instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'total': instance.total,
    };
