// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_question_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventQuestionsResponseDto _$EventQuestionsResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _EventQuestionsResponseDto.fromJson(json);
}

/// @nodoc
mixin _$EventQuestionsResponseDto {
  List<EventQuestionDto> get data => throw _privateConstructorUsedError;
  MetaPaginationDto? get meta => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventQuestionsResponseDtoCopyWith<EventQuestionsResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventQuestionsResponseDtoCopyWith<$Res> {
  factory $EventQuestionsResponseDtoCopyWith(EventQuestionsResponseDto value,
          $Res Function(EventQuestionsResponseDto) then) =
      _$EventQuestionsResponseDtoCopyWithImpl<$Res, EventQuestionsResponseDto>;
  @useResult
  $Res call({List<EventQuestionDto> data, MetaPaginationDto? meta});

  $MetaPaginationDtoCopyWith<$Res>? get meta;
}

/// @nodoc
class _$EventQuestionsResponseDtoCopyWithImpl<$Res,
        $Val extends EventQuestionsResponseDto>
    implements $EventQuestionsResponseDtoCopyWith<$Res> {
  _$EventQuestionsResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? meta = freezed,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<EventQuestionDto>,
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as MetaPaginationDto?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MetaPaginationDtoCopyWith<$Res>? get meta {
    if (_value.meta == null) {
      return null;
    }

    return $MetaPaginationDtoCopyWith<$Res>(_value.meta!, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventQuestionsResponseDtoImplCopyWith<$Res>
    implements $EventQuestionsResponseDtoCopyWith<$Res> {
  factory _$$EventQuestionsResponseDtoImplCopyWith(
          _$EventQuestionsResponseDtoImpl value,
          $Res Function(_$EventQuestionsResponseDtoImpl) then) =
      __$$EventQuestionsResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<EventQuestionDto> data, MetaPaginationDto? meta});

  @override
  $MetaPaginationDtoCopyWith<$Res>? get meta;
}

/// @nodoc
class __$$EventQuestionsResponseDtoImplCopyWithImpl<$Res>
    extends _$EventQuestionsResponseDtoCopyWithImpl<$Res,
        _$EventQuestionsResponseDtoImpl>
    implements _$$EventQuestionsResponseDtoImplCopyWith<$Res> {
  __$$EventQuestionsResponseDtoImplCopyWithImpl(
      _$EventQuestionsResponseDtoImpl _value,
      $Res Function(_$EventQuestionsResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? meta = freezed,
  }) {
    return _then(_$EventQuestionsResponseDtoImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<EventQuestionDto>,
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as MetaPaginationDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventQuestionsResponseDtoImpl implements _EventQuestionsResponseDto {
  const _$EventQuestionsResponseDtoImpl(
      {final List<EventQuestionDto> data = const [], this.meta})
      : _data = data;

  factory _$EventQuestionsResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventQuestionsResponseDtoImplFromJson(json);

  final List<EventQuestionDto> _data;
  @override
  @JsonKey()
  List<EventQuestionDto> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final MetaPaginationDto? meta;

  @override
  String toString() {
    return 'EventQuestionsResponseDto(data: $data, meta: $meta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventQuestionsResponseDtoImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.meta, meta) || other.meta == meta));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_data), meta);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventQuestionsResponseDtoImplCopyWith<_$EventQuestionsResponseDtoImpl>
      get copyWith => __$$EventQuestionsResponseDtoImplCopyWithImpl<
          _$EventQuestionsResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventQuestionsResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _EventQuestionsResponseDto implements EventQuestionsResponseDto {
  const factory _EventQuestionsResponseDto(
      {final List<EventQuestionDto> data,
      final MetaPaginationDto? meta}) = _$EventQuestionsResponseDtoImpl;

  factory _EventQuestionsResponseDto.fromJson(Map<String, dynamic> json) =
      _$EventQuestionsResponseDtoImpl.fromJson;

  @override
  List<EventQuestionDto> get data;
  @override
  MetaPaginationDto? get meta;
  @override
  @JsonKey(ignore: true)
  _$$EventQuestionsResponseDtoImplCopyWith<_$EventQuestionsResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

EventQuestionDto _$EventQuestionDtoFromJson(Map<String, dynamic> json) {
  return _EventQuestionDto.fromJson(json);
}

/// @nodoc
mixin _$EventQuestionDto {
  String get uuid => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get question => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'helpful_count', fromJson: _parseInt)
  int get helpfulCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'helpfulCount', fromJson: _parseInt)
  int get helpfulCountCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_public', fromJson: _parseBool)
  bool get isPublic => throw _privateConstructorUsedError;
  @JsonKey(name: 'isPublic', fromJson: _parseBool)
  bool get isPublicCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_pinned', fromJson: _parseBool)
  bool get isPinned => throw _privateConstructorUsedError;
  @JsonKey(name: 'isPinned', fromJson: _parseBool)
  bool get isPinnedCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_answered', fromJson: _parseBool)
  bool get isAnswered => throw _privateConstructorUsedError;
  @JsonKey(name: 'isAnswered', fromJson: _parseBool)
  bool get isAnsweredCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_answer', fromJson: _parseBool)
  bool get hasAnswer => throw _privateConstructorUsedError;
  @JsonKey(name: 'hasAnswer', fromJson: _parseBool)
  bool get hasAnswerCamel => throw _privateConstructorUsedError;
  QuestionAuthorDto? get author => throw _privateConstructorUsedError;
  QuestionAnswerDto? get answer => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_voted', fromJson: _parseBool)
  bool get userVoted => throw _privateConstructorUsedError;
  @JsonKey(name: 'userVoted', fromJson: _parseBool)
  bool get userVotedCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
  String get createdAtFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
  String get createdAtFormattedCamel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventQuestionDtoCopyWith<EventQuestionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventQuestionDtoCopyWith<$Res> {
  factory $EventQuestionDtoCopyWith(
          EventQuestionDto value, $Res Function(EventQuestionDto) then) =
      _$EventQuestionDtoCopyWithImpl<$Res, EventQuestionDto>;
  @useResult
  $Res call(
      {String uuid,
      @JsonKey(fromJson: _parseString) String question,
      @JsonKey(fromJson: _parseString) String status,
      @JsonKey(name: 'helpful_count', fromJson: _parseInt) int helpfulCount,
      @JsonKey(name: 'helpfulCount', fromJson: _parseInt) int helpfulCountCamel,
      @JsonKey(name: 'is_public', fromJson: _parseBool) bool isPublic,
      @JsonKey(name: 'isPublic', fromJson: _parseBool) bool isPublicCamel,
      @JsonKey(name: 'is_pinned', fromJson: _parseBool) bool isPinned,
      @JsonKey(name: 'isPinned', fromJson: _parseBool) bool isPinnedCamel,
      @JsonKey(name: 'is_answered', fromJson: _parseBool) bool isAnswered,
      @JsonKey(name: 'isAnswered', fromJson: _parseBool) bool isAnsweredCamel,
      @JsonKey(name: 'has_answer', fromJson: _parseBool) bool hasAnswer,
      @JsonKey(name: 'hasAnswer', fromJson: _parseBool) bool hasAnswerCamel,
      QuestionAuthorDto? author,
      QuestionAnswerDto? answer,
      @JsonKey(name: 'user_voted', fromJson: _parseBool) bool userVoted,
      @JsonKey(name: 'userVoted', fromJson: _parseBool) bool userVotedCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
      String createdAtFormatted,
      @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
      String createdAtFormattedCamel});

  $QuestionAuthorDtoCopyWith<$Res>? get author;
  $QuestionAnswerDtoCopyWith<$Res>? get answer;
}

/// @nodoc
class _$EventQuestionDtoCopyWithImpl<$Res, $Val extends EventQuestionDto>
    implements $EventQuestionDtoCopyWith<$Res> {
  _$EventQuestionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? question = null,
    Object? status = null,
    Object? helpfulCount = null,
    Object? helpfulCountCamel = null,
    Object? isPublic = null,
    Object? isPublicCamel = null,
    Object? isPinned = null,
    Object? isPinnedCamel = null,
    Object? isAnswered = null,
    Object? isAnsweredCamel = null,
    Object? hasAnswer = null,
    Object? hasAnswerCamel = null,
    Object? author = freezed,
    Object? answer = freezed,
    Object? userVoted = null,
    Object? userVotedCamel = null,
    Object? createdAtFormatted = null,
    Object? createdAtFormattedCamel = null,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      helpfulCount: null == helpfulCount
          ? _value.helpfulCount
          : helpfulCount // ignore: cast_nullable_to_non_nullable
              as int,
      helpfulCountCamel: null == helpfulCountCamel
          ? _value.helpfulCountCamel
          : helpfulCountCamel // ignore: cast_nullable_to_non_nullable
              as int,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      isPublicCamel: null == isPublicCamel
          ? _value.isPublicCamel
          : isPublicCamel // ignore: cast_nullable_to_non_nullable
              as bool,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      isPinnedCamel: null == isPinnedCamel
          ? _value.isPinnedCamel
          : isPinnedCamel // ignore: cast_nullable_to_non_nullable
              as bool,
      isAnswered: null == isAnswered
          ? _value.isAnswered
          : isAnswered // ignore: cast_nullable_to_non_nullable
              as bool,
      isAnsweredCamel: null == isAnsweredCamel
          ? _value.isAnsweredCamel
          : isAnsweredCamel // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAnswer: null == hasAnswer
          ? _value.hasAnswer
          : hasAnswer // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAnswerCamel: null == hasAnswerCamel
          ? _value.hasAnswerCamel
          : hasAnswerCamel // ignore: cast_nullable_to_non_nullable
              as bool,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as QuestionAuthorDto?,
      answer: freezed == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as QuestionAnswerDto?,
      userVoted: null == userVoted
          ? _value.userVoted
          : userVoted // ignore: cast_nullable_to_non_nullable
              as bool,
      userVotedCamel: null == userVotedCamel
          ? _value.userVotedCamel
          : userVotedCamel // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAtFormatted: null == createdAtFormatted
          ? _value.createdAtFormatted
          : createdAtFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      createdAtFormattedCamel: null == createdAtFormattedCamel
          ? _value.createdAtFormattedCamel
          : createdAtFormattedCamel // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $QuestionAuthorDtoCopyWith<$Res>? get author {
    if (_value.author == null) {
      return null;
    }

    return $QuestionAuthorDtoCopyWith<$Res>(_value.author!, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $QuestionAnswerDtoCopyWith<$Res>? get answer {
    if (_value.answer == null) {
      return null;
    }

    return $QuestionAnswerDtoCopyWith<$Res>(_value.answer!, (value) {
      return _then(_value.copyWith(answer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventQuestionDtoImplCopyWith<$Res>
    implements $EventQuestionDtoCopyWith<$Res> {
  factory _$$EventQuestionDtoImplCopyWith(_$EventQuestionDtoImpl value,
          $Res Function(_$EventQuestionDtoImpl) then) =
      __$$EventQuestionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      @JsonKey(fromJson: _parseString) String question,
      @JsonKey(fromJson: _parseString) String status,
      @JsonKey(name: 'helpful_count', fromJson: _parseInt) int helpfulCount,
      @JsonKey(name: 'helpfulCount', fromJson: _parseInt) int helpfulCountCamel,
      @JsonKey(name: 'is_public', fromJson: _parseBool) bool isPublic,
      @JsonKey(name: 'isPublic', fromJson: _parseBool) bool isPublicCamel,
      @JsonKey(name: 'is_pinned', fromJson: _parseBool) bool isPinned,
      @JsonKey(name: 'isPinned', fromJson: _parseBool) bool isPinnedCamel,
      @JsonKey(name: 'is_answered', fromJson: _parseBool) bool isAnswered,
      @JsonKey(name: 'isAnswered', fromJson: _parseBool) bool isAnsweredCamel,
      @JsonKey(name: 'has_answer', fromJson: _parseBool) bool hasAnswer,
      @JsonKey(name: 'hasAnswer', fromJson: _parseBool) bool hasAnswerCamel,
      QuestionAuthorDto? author,
      QuestionAnswerDto? answer,
      @JsonKey(name: 'user_voted', fromJson: _parseBool) bool userVoted,
      @JsonKey(name: 'userVoted', fromJson: _parseBool) bool userVotedCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
      String createdAtFormatted,
      @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
      String createdAtFormattedCamel});

  @override
  $QuestionAuthorDtoCopyWith<$Res>? get author;
  @override
  $QuestionAnswerDtoCopyWith<$Res>? get answer;
}

/// @nodoc
class __$$EventQuestionDtoImplCopyWithImpl<$Res>
    extends _$EventQuestionDtoCopyWithImpl<$Res, _$EventQuestionDtoImpl>
    implements _$$EventQuestionDtoImplCopyWith<$Res> {
  __$$EventQuestionDtoImplCopyWithImpl(_$EventQuestionDtoImpl _value,
      $Res Function(_$EventQuestionDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? question = null,
    Object? status = null,
    Object? helpfulCount = null,
    Object? helpfulCountCamel = null,
    Object? isPublic = null,
    Object? isPublicCamel = null,
    Object? isPinned = null,
    Object? isPinnedCamel = null,
    Object? isAnswered = null,
    Object? isAnsweredCamel = null,
    Object? hasAnswer = null,
    Object? hasAnswerCamel = null,
    Object? author = freezed,
    Object? answer = freezed,
    Object? userVoted = null,
    Object? userVotedCamel = null,
    Object? createdAtFormatted = null,
    Object? createdAtFormattedCamel = null,
  }) {
    return _then(_$EventQuestionDtoImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      helpfulCount: null == helpfulCount
          ? _value.helpfulCount
          : helpfulCount // ignore: cast_nullable_to_non_nullable
              as int,
      helpfulCountCamel: null == helpfulCountCamel
          ? _value.helpfulCountCamel
          : helpfulCountCamel // ignore: cast_nullable_to_non_nullable
              as int,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      isPublicCamel: null == isPublicCamel
          ? _value.isPublicCamel
          : isPublicCamel // ignore: cast_nullable_to_non_nullable
              as bool,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      isPinnedCamel: null == isPinnedCamel
          ? _value.isPinnedCamel
          : isPinnedCamel // ignore: cast_nullable_to_non_nullable
              as bool,
      isAnswered: null == isAnswered
          ? _value.isAnswered
          : isAnswered // ignore: cast_nullable_to_non_nullable
              as bool,
      isAnsweredCamel: null == isAnsweredCamel
          ? _value.isAnsweredCamel
          : isAnsweredCamel // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAnswer: null == hasAnswer
          ? _value.hasAnswer
          : hasAnswer // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAnswerCamel: null == hasAnswerCamel
          ? _value.hasAnswerCamel
          : hasAnswerCamel // ignore: cast_nullable_to_non_nullable
              as bool,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as QuestionAuthorDto?,
      answer: freezed == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as QuestionAnswerDto?,
      userVoted: null == userVoted
          ? _value.userVoted
          : userVoted // ignore: cast_nullable_to_non_nullable
              as bool,
      userVotedCamel: null == userVotedCamel
          ? _value.userVotedCamel
          : userVotedCamel // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAtFormatted: null == createdAtFormatted
          ? _value.createdAtFormatted
          : createdAtFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      createdAtFormattedCamel: null == createdAtFormattedCamel
          ? _value.createdAtFormattedCamel
          : createdAtFormattedCamel // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventQuestionDtoImpl implements _EventQuestionDto {
  const _$EventQuestionDtoImpl(
      {required this.uuid,
      @JsonKey(fromJson: _parseString) this.question = '',
      @JsonKey(fromJson: _parseString) this.status = 'pending',
      @JsonKey(name: 'helpful_count', fromJson: _parseInt)
      this.helpfulCount = 0,
      @JsonKey(name: 'helpfulCount', fromJson: _parseInt)
      this.helpfulCountCamel = 0,
      @JsonKey(name: 'is_public', fromJson: _parseBool) this.isPublic = true,
      @JsonKey(name: 'isPublic', fromJson: _parseBool)
      this.isPublicCamel = true,
      @JsonKey(name: 'is_pinned', fromJson: _parseBool) this.isPinned = false,
      @JsonKey(name: 'isPinned', fromJson: _parseBool)
      this.isPinnedCamel = false,
      @JsonKey(name: 'is_answered', fromJson: _parseBool)
      this.isAnswered = false,
      @JsonKey(name: 'isAnswered', fromJson: _parseBool)
      this.isAnsweredCamel = false,
      @JsonKey(name: 'has_answer', fromJson: _parseBool) this.hasAnswer = false,
      @JsonKey(name: 'hasAnswer', fromJson: _parseBool)
      this.hasAnswerCamel = false,
      this.author,
      this.answer,
      @JsonKey(name: 'user_voted', fromJson: _parseBool) this.userVoted = false,
      @JsonKey(name: 'userVoted', fromJson: _parseBool)
      this.userVotedCamel = false,
      @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
      this.createdAtFormatted = '',
      @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
      this.createdAtFormattedCamel = ''});

  factory _$EventQuestionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventQuestionDtoImplFromJson(json);

  @override
  final String uuid;
  @override
  @JsonKey(fromJson: _parseString)
  final String question;
  @override
  @JsonKey(fromJson: _parseString)
  final String status;
  @override
  @JsonKey(name: 'helpful_count', fromJson: _parseInt)
  final int helpfulCount;
  @override
  @JsonKey(name: 'helpfulCount', fromJson: _parseInt)
  final int helpfulCountCamel;
  @override
  @JsonKey(name: 'is_public', fromJson: _parseBool)
  final bool isPublic;
  @override
  @JsonKey(name: 'isPublic', fromJson: _parseBool)
  final bool isPublicCamel;
  @override
  @JsonKey(name: 'is_pinned', fromJson: _parseBool)
  final bool isPinned;
  @override
  @JsonKey(name: 'isPinned', fromJson: _parseBool)
  final bool isPinnedCamel;
  @override
  @JsonKey(name: 'is_answered', fromJson: _parseBool)
  final bool isAnswered;
  @override
  @JsonKey(name: 'isAnswered', fromJson: _parseBool)
  final bool isAnsweredCamel;
  @override
  @JsonKey(name: 'has_answer', fromJson: _parseBool)
  final bool hasAnswer;
  @override
  @JsonKey(name: 'hasAnswer', fromJson: _parseBool)
  final bool hasAnswerCamel;
  @override
  final QuestionAuthorDto? author;
  @override
  final QuestionAnswerDto? answer;
  @override
  @JsonKey(name: 'user_voted', fromJson: _parseBool)
  final bool userVoted;
  @override
  @JsonKey(name: 'userVoted', fromJson: _parseBool)
  final bool userVotedCamel;
  @override
  @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
  final String createdAtFormatted;
  @override
  @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
  final String createdAtFormattedCamel;

  @override
  String toString() {
    return 'EventQuestionDto(uuid: $uuid, question: $question, status: $status, helpfulCount: $helpfulCount, helpfulCountCamel: $helpfulCountCamel, isPublic: $isPublic, isPublicCamel: $isPublicCamel, isPinned: $isPinned, isPinnedCamel: $isPinnedCamel, isAnswered: $isAnswered, isAnsweredCamel: $isAnsweredCamel, hasAnswer: $hasAnswer, hasAnswerCamel: $hasAnswerCamel, author: $author, answer: $answer, userVoted: $userVoted, userVotedCamel: $userVotedCamel, createdAtFormatted: $createdAtFormatted, createdAtFormattedCamel: $createdAtFormattedCamel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventQuestionDtoImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.helpfulCount, helpfulCount) ||
                other.helpfulCount == helpfulCount) &&
            (identical(other.helpfulCountCamel, helpfulCountCamel) ||
                other.helpfulCountCamel == helpfulCountCamel) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.isPublicCamel, isPublicCamel) ||
                other.isPublicCamel == isPublicCamel) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            (identical(other.isPinnedCamel, isPinnedCamel) ||
                other.isPinnedCamel == isPinnedCamel) &&
            (identical(other.isAnswered, isAnswered) ||
                other.isAnswered == isAnswered) &&
            (identical(other.isAnsweredCamel, isAnsweredCamel) ||
                other.isAnsweredCamel == isAnsweredCamel) &&
            (identical(other.hasAnswer, hasAnswer) ||
                other.hasAnswer == hasAnswer) &&
            (identical(other.hasAnswerCamel, hasAnswerCamel) ||
                other.hasAnswerCamel == hasAnswerCamel) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.answer, answer) || other.answer == answer) &&
            (identical(other.userVoted, userVoted) ||
                other.userVoted == userVoted) &&
            (identical(other.userVotedCamel, userVotedCamel) ||
                other.userVotedCamel == userVotedCamel) &&
            (identical(other.createdAtFormatted, createdAtFormatted) ||
                other.createdAtFormatted == createdAtFormatted) &&
            (identical(
                    other.createdAtFormattedCamel, createdAtFormattedCamel) ||
                other.createdAtFormattedCamel == createdAtFormattedCamel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        uuid,
        question,
        status,
        helpfulCount,
        helpfulCountCamel,
        isPublic,
        isPublicCamel,
        isPinned,
        isPinnedCamel,
        isAnswered,
        isAnsweredCamel,
        hasAnswer,
        hasAnswerCamel,
        author,
        answer,
        userVoted,
        userVotedCamel,
        createdAtFormatted,
        createdAtFormattedCamel
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventQuestionDtoImplCopyWith<_$EventQuestionDtoImpl> get copyWith =>
      __$$EventQuestionDtoImplCopyWithImpl<_$EventQuestionDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventQuestionDtoImplToJson(
      this,
    );
  }
}

abstract class _EventQuestionDto implements EventQuestionDto {
  const factory _EventQuestionDto(
      {required final String uuid,
      @JsonKey(fromJson: _parseString) final String question,
      @JsonKey(fromJson: _parseString) final String status,
      @JsonKey(name: 'helpful_count', fromJson: _parseInt)
      final int helpfulCount,
      @JsonKey(name: 'helpfulCount', fromJson: _parseInt)
      final int helpfulCountCamel,
      @JsonKey(name: 'is_public', fromJson: _parseBool) final bool isPublic,
      @JsonKey(name: 'isPublic', fromJson: _parseBool) final bool isPublicCamel,
      @JsonKey(name: 'is_pinned', fromJson: _parseBool) final bool isPinned,
      @JsonKey(name: 'isPinned', fromJson: _parseBool) final bool isPinnedCamel,
      @JsonKey(name: 'is_answered', fromJson: _parseBool) final bool isAnswered,
      @JsonKey(name: 'isAnswered', fromJson: _parseBool)
      final bool isAnsweredCamel,
      @JsonKey(name: 'has_answer', fromJson: _parseBool) final bool hasAnswer,
      @JsonKey(name: 'hasAnswer', fromJson: _parseBool)
      final bool hasAnswerCamel,
      final QuestionAuthorDto? author,
      final QuestionAnswerDto? answer,
      @JsonKey(name: 'user_voted', fromJson: _parseBool) final bool userVoted,
      @JsonKey(name: 'userVoted', fromJson: _parseBool)
      final bool userVotedCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
      final String createdAtFormatted,
      @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
      final String createdAtFormattedCamel}) = _$EventQuestionDtoImpl;

  factory _EventQuestionDto.fromJson(Map<String, dynamic> json) =
      _$EventQuestionDtoImpl.fromJson;

  @override
  String get uuid;
  @override
  @JsonKey(fromJson: _parseString)
  String get question;
  @override
  @JsonKey(fromJson: _parseString)
  String get status;
  @override
  @JsonKey(name: 'helpful_count', fromJson: _parseInt)
  int get helpfulCount;
  @override
  @JsonKey(name: 'helpfulCount', fromJson: _parseInt)
  int get helpfulCountCamel;
  @override
  @JsonKey(name: 'is_public', fromJson: _parseBool)
  bool get isPublic;
  @override
  @JsonKey(name: 'isPublic', fromJson: _parseBool)
  bool get isPublicCamel;
  @override
  @JsonKey(name: 'is_pinned', fromJson: _parseBool)
  bool get isPinned;
  @override
  @JsonKey(name: 'isPinned', fromJson: _parseBool)
  bool get isPinnedCamel;
  @override
  @JsonKey(name: 'is_answered', fromJson: _parseBool)
  bool get isAnswered;
  @override
  @JsonKey(name: 'isAnswered', fromJson: _parseBool)
  bool get isAnsweredCamel;
  @override
  @JsonKey(name: 'has_answer', fromJson: _parseBool)
  bool get hasAnswer;
  @override
  @JsonKey(name: 'hasAnswer', fromJson: _parseBool)
  bool get hasAnswerCamel;
  @override
  QuestionAuthorDto? get author;
  @override
  QuestionAnswerDto? get answer;
  @override
  @JsonKey(name: 'user_voted', fromJson: _parseBool)
  bool get userVoted;
  @override
  @JsonKey(name: 'userVoted', fromJson: _parseBool)
  bool get userVotedCamel;
  @override
  @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
  String get createdAtFormatted;
  @override
  @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
  String get createdAtFormattedCamel;
  @override
  @JsonKey(ignore: true)
  _$$EventQuestionDtoImplCopyWith<_$EventQuestionDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuestionAuthorDto _$QuestionAuthorDtoFromJson(Map<String, dynamic> json) {
  return _QuestionAuthorDto.fromJson(json);
}

/// @nodoc
mixin _$QuestionAuthorDto {
  @JsonKey(fromJson: _parseString)
  String get name => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get avatar => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get initials => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_guest', fromJson: _parseBool)
  bool get isGuest => throw _privateConstructorUsedError;
  @JsonKey(name: 'isGuest', fromJson: _parseBool)
  bool get isGuestCamel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuestionAuthorDtoCopyWith<QuestionAuthorDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionAuthorDtoCopyWith<$Res> {
  factory $QuestionAuthorDtoCopyWith(
          QuestionAuthorDto value, $Res Function(QuestionAuthorDto) then) =
      _$QuestionAuthorDtoCopyWithImpl<$Res, QuestionAuthorDto>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseString) String name,
      @JsonKey(fromJson: _parseStringOrNull) String? avatar,
      @JsonKey(fromJson: _parseString) String initials,
      @JsonKey(name: 'is_guest', fromJson: _parseBool) bool isGuest,
      @JsonKey(name: 'isGuest', fromJson: _parseBool) bool isGuestCamel});
}

/// @nodoc
class _$QuestionAuthorDtoCopyWithImpl<$Res, $Val extends QuestionAuthorDto>
    implements $QuestionAuthorDtoCopyWith<$Res> {
  _$QuestionAuthorDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? avatar = freezed,
    Object? initials = null,
    Object? isGuest = null,
    Object? isGuestCamel = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      initials: null == initials
          ? _value.initials
          : initials // ignore: cast_nullable_to_non_nullable
              as String,
      isGuest: null == isGuest
          ? _value.isGuest
          : isGuest // ignore: cast_nullable_to_non_nullable
              as bool,
      isGuestCamel: null == isGuestCamel
          ? _value.isGuestCamel
          : isGuestCamel // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionAuthorDtoImplCopyWith<$Res>
    implements $QuestionAuthorDtoCopyWith<$Res> {
  factory _$$QuestionAuthorDtoImplCopyWith(_$QuestionAuthorDtoImpl value,
          $Res Function(_$QuestionAuthorDtoImpl) then) =
      __$$QuestionAuthorDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseString) String name,
      @JsonKey(fromJson: _parseStringOrNull) String? avatar,
      @JsonKey(fromJson: _parseString) String initials,
      @JsonKey(name: 'is_guest', fromJson: _parseBool) bool isGuest,
      @JsonKey(name: 'isGuest', fromJson: _parseBool) bool isGuestCamel});
}

/// @nodoc
class __$$QuestionAuthorDtoImplCopyWithImpl<$Res>
    extends _$QuestionAuthorDtoCopyWithImpl<$Res, _$QuestionAuthorDtoImpl>
    implements _$$QuestionAuthorDtoImplCopyWith<$Res> {
  __$$QuestionAuthorDtoImplCopyWithImpl(_$QuestionAuthorDtoImpl _value,
      $Res Function(_$QuestionAuthorDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? avatar = freezed,
    Object? initials = null,
    Object? isGuest = null,
    Object? isGuestCamel = null,
  }) {
    return _then(_$QuestionAuthorDtoImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      initials: null == initials
          ? _value.initials
          : initials // ignore: cast_nullable_to_non_nullable
              as String,
      isGuest: null == isGuest
          ? _value.isGuest
          : isGuest // ignore: cast_nullable_to_non_nullable
              as bool,
      isGuestCamel: null == isGuestCamel
          ? _value.isGuestCamel
          : isGuestCamel // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionAuthorDtoImpl implements _QuestionAuthorDto {
  const _$QuestionAuthorDtoImpl(
      {@JsonKey(fromJson: _parseString) this.name = '',
      @JsonKey(fromJson: _parseStringOrNull) this.avatar,
      @JsonKey(fromJson: _parseString) this.initials = '',
      @JsonKey(name: 'is_guest', fromJson: _parseBool) this.isGuest = false,
      @JsonKey(name: 'isGuest', fromJson: _parseBool)
      this.isGuestCamel = false});

  factory _$QuestionAuthorDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionAuthorDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseString)
  final String name;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? avatar;
  @override
  @JsonKey(fromJson: _parseString)
  final String initials;
  @override
  @JsonKey(name: 'is_guest', fromJson: _parseBool)
  final bool isGuest;
  @override
  @JsonKey(name: 'isGuest', fromJson: _parseBool)
  final bool isGuestCamel;

  @override
  String toString() {
    return 'QuestionAuthorDto(name: $name, avatar: $avatar, initials: $initials, isGuest: $isGuest, isGuestCamel: $isGuestCamel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionAuthorDtoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.initials, initials) ||
                other.initials == initials) &&
            (identical(other.isGuest, isGuest) || other.isGuest == isGuest) &&
            (identical(other.isGuestCamel, isGuestCamel) ||
                other.isGuestCamel == isGuestCamel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, avatar, initials, isGuest, isGuestCamel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionAuthorDtoImplCopyWith<_$QuestionAuthorDtoImpl> get copyWith =>
      __$$QuestionAuthorDtoImplCopyWithImpl<_$QuestionAuthorDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionAuthorDtoImplToJson(
      this,
    );
  }
}

abstract class _QuestionAuthorDto implements QuestionAuthorDto {
  const factory _QuestionAuthorDto(
      {@JsonKey(fromJson: _parseString) final String name,
      @JsonKey(fromJson: _parseStringOrNull) final String? avatar,
      @JsonKey(fromJson: _parseString) final String initials,
      @JsonKey(name: 'is_guest', fromJson: _parseBool) final bool isGuest,
      @JsonKey(name: 'isGuest', fromJson: _parseBool)
      final bool isGuestCamel}) = _$QuestionAuthorDtoImpl;

  factory _QuestionAuthorDto.fromJson(Map<String, dynamic> json) =
      _$QuestionAuthorDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseString)
  String get name;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get avatar;
  @override
  @JsonKey(fromJson: _parseString)
  String get initials;
  @override
  @JsonKey(name: 'is_guest', fromJson: _parseBool)
  bool get isGuest;
  @override
  @JsonKey(name: 'isGuest', fromJson: _parseBool)
  bool get isGuestCamel;
  @override
  @JsonKey(ignore: true)
  _$$QuestionAuthorDtoImplCopyWith<_$QuestionAuthorDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuestionAnswerDto _$QuestionAnswerDtoFromJson(Map<String, dynamic> json) {
  return _QuestionAnswerDto.fromJson(json);
}

/// @nodoc
mixin _$QuestionAnswerDto {
  String get uuid => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get answer => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_official', fromJson: _parseBool)
  bool get isOfficial => throw _privateConstructorUsedError;
  @JsonKey(name: 'isOfficial', fromJson: _parseBool)
  bool get isOfficialCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'organization_id', fromJson: _parseStringOrNull)
  String? get organizationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'organizationId', fromJson: _parseStringOrNull)
  String? get organizationIdCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'organization_name', fromJson: _parseString)
  String get organizationName => throw _privateConstructorUsedError;
  @JsonKey(name: 'organizationName', fromJson: _parseString)
  String get organizationNameCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
  String get createdAtFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
  String get createdAtFormattedCamel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuestionAnswerDtoCopyWith<QuestionAnswerDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionAnswerDtoCopyWith<$Res> {
  factory $QuestionAnswerDtoCopyWith(
          QuestionAnswerDto value, $Res Function(QuestionAnswerDto) then) =
      _$QuestionAnswerDtoCopyWithImpl<$Res, QuestionAnswerDto>;
  @useResult
  $Res call(
      {String uuid,
      @JsonKey(fromJson: _parseString) String answer,
      @JsonKey(name: 'is_official', fromJson: _parseBool) bool isOfficial,
      @JsonKey(name: 'isOfficial', fromJson: _parseBool) bool isOfficialCamel,
      @JsonKey(name: 'organization_id', fromJson: _parseStringOrNull)
      String? organizationId,
      @JsonKey(name: 'organizationId', fromJson: _parseStringOrNull)
      String? organizationIdCamel,
      @JsonKey(name: 'organization_name', fromJson: _parseString)
      String organizationName,
      @JsonKey(name: 'organizationName', fromJson: _parseString)
      String organizationNameCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
      String createdAtFormatted,
      @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
      String createdAtFormattedCamel});
}

/// @nodoc
class _$QuestionAnswerDtoCopyWithImpl<$Res, $Val extends QuestionAnswerDto>
    implements $QuestionAnswerDtoCopyWith<$Res> {
  _$QuestionAnswerDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? answer = null,
    Object? isOfficial = null,
    Object? isOfficialCamel = null,
    Object? organizationId = freezed,
    Object? organizationIdCamel = freezed,
    Object? organizationName = null,
    Object? organizationNameCamel = null,
    Object? createdAtFormatted = null,
    Object? createdAtFormattedCamel = null,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      answer: null == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as String,
      isOfficial: null == isOfficial
          ? _value.isOfficial
          : isOfficial // ignore: cast_nullable_to_non_nullable
              as bool,
      isOfficialCamel: null == isOfficialCamel
          ? _value.isOfficialCamel
          : isOfficialCamel // ignore: cast_nullable_to_non_nullable
              as bool,
      organizationId: freezed == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String?,
      organizationIdCamel: freezed == organizationIdCamel
          ? _value.organizationIdCamel
          : organizationIdCamel // ignore: cast_nullable_to_non_nullable
              as String?,
      organizationName: null == organizationName
          ? _value.organizationName
          : organizationName // ignore: cast_nullable_to_non_nullable
              as String,
      organizationNameCamel: null == organizationNameCamel
          ? _value.organizationNameCamel
          : organizationNameCamel // ignore: cast_nullable_to_non_nullable
              as String,
      createdAtFormatted: null == createdAtFormatted
          ? _value.createdAtFormatted
          : createdAtFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      createdAtFormattedCamel: null == createdAtFormattedCamel
          ? _value.createdAtFormattedCamel
          : createdAtFormattedCamel // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionAnswerDtoImplCopyWith<$Res>
    implements $QuestionAnswerDtoCopyWith<$Res> {
  factory _$$QuestionAnswerDtoImplCopyWith(_$QuestionAnswerDtoImpl value,
          $Res Function(_$QuestionAnswerDtoImpl) then) =
      __$$QuestionAnswerDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      @JsonKey(fromJson: _parseString) String answer,
      @JsonKey(name: 'is_official', fromJson: _parseBool) bool isOfficial,
      @JsonKey(name: 'isOfficial', fromJson: _parseBool) bool isOfficialCamel,
      @JsonKey(name: 'organization_id', fromJson: _parseStringOrNull)
      String? organizationId,
      @JsonKey(name: 'organizationId', fromJson: _parseStringOrNull)
      String? organizationIdCamel,
      @JsonKey(name: 'organization_name', fromJson: _parseString)
      String organizationName,
      @JsonKey(name: 'organizationName', fromJson: _parseString)
      String organizationNameCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
      String createdAtFormatted,
      @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
      String createdAtFormattedCamel});
}

/// @nodoc
class __$$QuestionAnswerDtoImplCopyWithImpl<$Res>
    extends _$QuestionAnswerDtoCopyWithImpl<$Res, _$QuestionAnswerDtoImpl>
    implements _$$QuestionAnswerDtoImplCopyWith<$Res> {
  __$$QuestionAnswerDtoImplCopyWithImpl(_$QuestionAnswerDtoImpl _value,
      $Res Function(_$QuestionAnswerDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? answer = null,
    Object? isOfficial = null,
    Object? isOfficialCamel = null,
    Object? organizationId = freezed,
    Object? organizationIdCamel = freezed,
    Object? organizationName = null,
    Object? organizationNameCamel = null,
    Object? createdAtFormatted = null,
    Object? createdAtFormattedCamel = null,
  }) {
    return _then(_$QuestionAnswerDtoImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      answer: null == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as String,
      isOfficial: null == isOfficial
          ? _value.isOfficial
          : isOfficial // ignore: cast_nullable_to_non_nullable
              as bool,
      isOfficialCamel: null == isOfficialCamel
          ? _value.isOfficialCamel
          : isOfficialCamel // ignore: cast_nullable_to_non_nullable
              as bool,
      organizationId: freezed == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String?,
      organizationIdCamel: freezed == organizationIdCamel
          ? _value.organizationIdCamel
          : organizationIdCamel // ignore: cast_nullable_to_non_nullable
              as String?,
      organizationName: null == organizationName
          ? _value.organizationName
          : organizationName // ignore: cast_nullable_to_non_nullable
              as String,
      organizationNameCamel: null == organizationNameCamel
          ? _value.organizationNameCamel
          : organizationNameCamel // ignore: cast_nullable_to_non_nullable
              as String,
      createdAtFormatted: null == createdAtFormatted
          ? _value.createdAtFormatted
          : createdAtFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      createdAtFormattedCamel: null == createdAtFormattedCamel
          ? _value.createdAtFormattedCamel
          : createdAtFormattedCamel // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionAnswerDtoImpl implements _QuestionAnswerDto {
  const _$QuestionAnswerDtoImpl(
      {required this.uuid,
      @JsonKey(fromJson: _parseString) this.answer = '',
      @JsonKey(name: 'is_official', fromJson: _parseBool)
      this.isOfficial = true,
      @JsonKey(name: 'isOfficial', fromJson: _parseBool)
      this.isOfficialCamel = true,
      @JsonKey(name: 'organization_id', fromJson: _parseStringOrNull)
      this.organizationId,
      @JsonKey(name: 'organizationId', fromJson: _parseStringOrNull)
      this.organizationIdCamel,
      @JsonKey(name: 'organization_name', fromJson: _parseString)
      this.organizationName = '',
      @JsonKey(name: 'organizationName', fromJson: _parseString)
      this.organizationNameCamel = '',
      @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
      this.createdAtFormatted = '',
      @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
      this.createdAtFormattedCamel = ''});

  factory _$QuestionAnswerDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionAnswerDtoImplFromJson(json);

  @override
  final String uuid;
  @override
  @JsonKey(fromJson: _parseString)
  final String answer;
  @override
  @JsonKey(name: 'is_official', fromJson: _parseBool)
  final bool isOfficial;
  @override
  @JsonKey(name: 'isOfficial', fromJson: _parseBool)
  final bool isOfficialCamel;
  @override
  @JsonKey(name: 'organization_id', fromJson: _parseStringOrNull)
  final String? organizationId;
  @override
  @JsonKey(name: 'organizationId', fromJson: _parseStringOrNull)
  final String? organizationIdCamel;
  @override
  @JsonKey(name: 'organization_name', fromJson: _parseString)
  final String organizationName;
  @override
  @JsonKey(name: 'organizationName', fromJson: _parseString)
  final String organizationNameCamel;
  @override
  @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
  final String createdAtFormatted;
  @override
  @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
  final String createdAtFormattedCamel;

  @override
  String toString() {
    return 'QuestionAnswerDto(uuid: $uuid, answer: $answer, isOfficial: $isOfficial, isOfficialCamel: $isOfficialCamel, organizationId: $organizationId, organizationIdCamel: $organizationIdCamel, organizationName: $organizationName, organizationNameCamel: $organizationNameCamel, createdAtFormatted: $createdAtFormatted, createdAtFormattedCamel: $createdAtFormattedCamel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionAnswerDtoImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.answer, answer) || other.answer == answer) &&
            (identical(other.isOfficial, isOfficial) ||
                other.isOfficial == isOfficial) &&
            (identical(other.isOfficialCamel, isOfficialCamel) ||
                other.isOfficialCamel == isOfficialCamel) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.organizationIdCamel, organizationIdCamel) ||
                other.organizationIdCamel == organizationIdCamel) &&
            (identical(other.organizationName, organizationName) ||
                other.organizationName == organizationName) &&
            (identical(other.organizationNameCamel, organizationNameCamel) ||
                other.organizationNameCamel == organizationNameCamel) &&
            (identical(other.createdAtFormatted, createdAtFormatted) ||
                other.createdAtFormatted == createdAtFormatted) &&
            (identical(
                    other.createdAtFormattedCamel, createdAtFormattedCamel) ||
                other.createdAtFormattedCamel == createdAtFormattedCamel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uuid,
      answer,
      isOfficial,
      isOfficialCamel,
      organizationId,
      organizationIdCamel,
      organizationName,
      organizationNameCamel,
      createdAtFormatted,
      createdAtFormattedCamel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionAnswerDtoImplCopyWith<_$QuestionAnswerDtoImpl> get copyWith =>
      __$$QuestionAnswerDtoImplCopyWithImpl<_$QuestionAnswerDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionAnswerDtoImplToJson(
      this,
    );
  }
}

abstract class _QuestionAnswerDto implements QuestionAnswerDto {
  const factory _QuestionAnswerDto(
      {required final String uuid,
      @JsonKey(fromJson: _parseString) final String answer,
      @JsonKey(name: 'is_official', fromJson: _parseBool) final bool isOfficial,
      @JsonKey(name: 'isOfficial', fromJson: _parseBool)
      final bool isOfficialCamel,
      @JsonKey(name: 'organization_id', fromJson: _parseStringOrNull)
      final String? organizationId,
      @JsonKey(name: 'organizationId', fromJson: _parseStringOrNull)
      final String? organizationIdCamel,
      @JsonKey(name: 'organization_name', fromJson: _parseString)
      final String organizationName,
      @JsonKey(name: 'organizationName', fromJson: _parseString)
      final String organizationNameCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
      final String createdAtFormatted,
      @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
      final String createdAtFormattedCamel}) = _$QuestionAnswerDtoImpl;

  factory _QuestionAnswerDto.fromJson(Map<String, dynamic> json) =
      _$QuestionAnswerDtoImpl.fromJson;

  @override
  String get uuid;
  @override
  @JsonKey(fromJson: _parseString)
  String get answer;
  @override
  @JsonKey(name: 'is_official', fromJson: _parseBool)
  bool get isOfficial;
  @override
  @JsonKey(name: 'isOfficial', fromJson: _parseBool)
  bool get isOfficialCamel;
  @override
  @JsonKey(name: 'organization_id', fromJson: _parseStringOrNull)
  String? get organizationId;
  @override
  @JsonKey(name: 'organizationId', fromJson: _parseStringOrNull)
  String? get organizationIdCamel;
  @override
  @JsonKey(name: 'organization_name', fromJson: _parseString)
  String get organizationName;
  @override
  @JsonKey(name: 'organizationName', fromJson: _parseString)
  String get organizationNameCamel;
  @override
  @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
  String get createdAtFormatted;
  @override
  @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
  String get createdAtFormattedCamel;
  @override
  @JsonKey(ignore: true)
  _$$QuestionAnswerDtoImplCopyWith<_$QuestionAnswerDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MetaPaginationDto _$MetaPaginationDtoFromJson(Map<String, dynamic> json) {
  return _MetaPaginationDto.fromJson(json);
}

/// @nodoc
mixin _$MetaPaginationDto {
  @JsonKey(name: 'current_page', fromJson: _parseInt)
  int get currentPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_page', fromJson: _parseInt)
  int get lastPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'per_page', fromJson: _parseInt)
  int get perPage => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseInt)
  int get total => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MetaPaginationDtoCopyWith<MetaPaginationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetaPaginationDtoCopyWith<$Res> {
  factory $MetaPaginationDtoCopyWith(
          MetaPaginationDto value, $Res Function(MetaPaginationDto) then) =
      _$MetaPaginationDtoCopyWithImpl<$Res, MetaPaginationDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'current_page', fromJson: _parseInt) int currentPage,
      @JsonKey(name: 'last_page', fromJson: _parseInt) int lastPage,
      @JsonKey(name: 'per_page', fromJson: _parseInt) int perPage,
      @JsonKey(fromJson: _parseInt) int total});
}

/// @nodoc
class _$MetaPaginationDtoCopyWithImpl<$Res, $Val extends MetaPaginationDto>
    implements $MetaPaginationDtoCopyWith<$Res> {
  _$MetaPaginationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? lastPage = null,
    Object? perPage = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      lastPage: null == lastPage
          ? _value.lastPage
          : lastPage // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MetaPaginationDtoImplCopyWith<$Res>
    implements $MetaPaginationDtoCopyWith<$Res> {
  factory _$$MetaPaginationDtoImplCopyWith(_$MetaPaginationDtoImpl value,
          $Res Function(_$MetaPaginationDtoImpl) then) =
      __$$MetaPaginationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'current_page', fromJson: _parseInt) int currentPage,
      @JsonKey(name: 'last_page', fromJson: _parseInt) int lastPage,
      @JsonKey(name: 'per_page', fromJson: _parseInt) int perPage,
      @JsonKey(fromJson: _parseInt) int total});
}

/// @nodoc
class __$$MetaPaginationDtoImplCopyWithImpl<$Res>
    extends _$MetaPaginationDtoCopyWithImpl<$Res, _$MetaPaginationDtoImpl>
    implements _$$MetaPaginationDtoImplCopyWith<$Res> {
  __$$MetaPaginationDtoImplCopyWithImpl(_$MetaPaginationDtoImpl _value,
      $Res Function(_$MetaPaginationDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? lastPage = null,
    Object? perPage = null,
    Object? total = null,
  }) {
    return _then(_$MetaPaginationDtoImpl(
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      lastPage: null == lastPage
          ? _value.lastPage
          : lastPage // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MetaPaginationDtoImpl implements _MetaPaginationDto {
  const _$MetaPaginationDtoImpl(
      {@JsonKey(name: 'current_page', fromJson: _parseInt) this.currentPage = 1,
      @JsonKey(name: 'last_page', fromJson: _parseInt) this.lastPage = 1,
      @JsonKey(name: 'per_page', fromJson: _parseInt) this.perPage = 15,
      @JsonKey(fromJson: _parseInt) this.total = 0});

  factory _$MetaPaginationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetaPaginationDtoImplFromJson(json);

  @override
  @JsonKey(name: 'current_page', fromJson: _parseInt)
  final int currentPage;
  @override
  @JsonKey(name: 'last_page', fromJson: _parseInt)
  final int lastPage;
  @override
  @JsonKey(name: 'per_page', fromJson: _parseInt)
  final int perPage;
  @override
  @JsonKey(fromJson: _parseInt)
  final int total;

  @override
  String toString() {
    return 'MetaPaginationDto(currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetaPaginationDtoImpl &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.lastPage, lastPage) ||
                other.lastPage == lastPage) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, currentPage, lastPage, perPage, total);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MetaPaginationDtoImplCopyWith<_$MetaPaginationDtoImpl> get copyWith =>
      __$$MetaPaginationDtoImplCopyWithImpl<_$MetaPaginationDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MetaPaginationDtoImplToJson(
      this,
    );
  }
}

abstract class _MetaPaginationDto implements MetaPaginationDto {
  const factory _MetaPaginationDto(
      {@JsonKey(name: 'current_page', fromJson: _parseInt)
      final int currentPage,
      @JsonKey(name: 'last_page', fromJson: _parseInt) final int lastPage,
      @JsonKey(name: 'per_page', fromJson: _parseInt) final int perPage,
      @JsonKey(fromJson: _parseInt) final int total}) = _$MetaPaginationDtoImpl;

  factory _MetaPaginationDto.fromJson(Map<String, dynamic> json) =
      _$MetaPaginationDtoImpl.fromJson;

  @override
  @JsonKey(name: 'current_page', fromJson: _parseInt)
  int get currentPage;
  @override
  @JsonKey(name: 'last_page', fromJson: _parseInt)
  int get lastPage;
  @override
  @JsonKey(name: 'per_page', fromJson: _parseInt)
  int get perPage;
  @override
  @JsonKey(fromJson: _parseInt)
  int get total;
  @override
  @JsonKey(ignore: true)
  _$$MetaPaginationDtoImplCopyWith<_$MetaPaginationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
