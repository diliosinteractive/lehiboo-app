// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EventDetailState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Event event) loaded,
    required TResult Function(LockedEventShell shell) locked,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Event event)? loaded,
    TResult? Function(LockedEventShell shell)? locked,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Event event)? loaded,
    TResult Function(LockedEventShell shell)? locked,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EventDetailLoaded value) loaded,
    required TResult Function(EventDetailLocked value) locked,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(EventDetailLoaded value)? loaded,
    TResult? Function(EventDetailLocked value)? locked,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EventDetailLoaded value)? loaded,
    TResult Function(EventDetailLocked value)? locked,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventDetailStateCopyWith<$Res> {
  factory $EventDetailStateCopyWith(
          EventDetailState value, $Res Function(EventDetailState) then) =
      _$EventDetailStateCopyWithImpl<$Res, EventDetailState>;
}

/// @nodoc
class _$EventDetailStateCopyWithImpl<$Res, $Val extends EventDetailState>
    implements $EventDetailStateCopyWith<$Res> {
  _$EventDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$EventDetailLoadedImplCopyWith<$Res> {
  factory _$$EventDetailLoadedImplCopyWith(_$EventDetailLoadedImpl value,
          $Res Function(_$EventDetailLoadedImpl) then) =
      __$$EventDetailLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Event event});
}

/// @nodoc
class __$$EventDetailLoadedImplCopyWithImpl<$Res>
    extends _$EventDetailStateCopyWithImpl<$Res, _$EventDetailLoadedImpl>
    implements _$$EventDetailLoadedImplCopyWith<$Res> {
  __$$EventDetailLoadedImplCopyWithImpl(_$EventDetailLoadedImpl _value,
      $Res Function(_$EventDetailLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
  }) {
    return _then(_$EventDetailLoadedImpl(
      null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as Event,
    ));
  }
}

/// @nodoc

class _$EventDetailLoadedImpl implements EventDetailLoaded {
  const _$EventDetailLoadedImpl(this.event);

  @override
  final Event event;

  @override
  String toString() {
    return 'EventDetailState.loaded(event: $event)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventDetailLoadedImpl &&
            (identical(other.event, event) || other.event == event));
  }

  @override
  int get hashCode => Object.hash(runtimeType, event);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventDetailLoadedImplCopyWith<_$EventDetailLoadedImpl> get copyWith =>
      __$$EventDetailLoadedImplCopyWithImpl<_$EventDetailLoadedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Event event) loaded,
    required TResult Function(LockedEventShell shell) locked,
  }) {
    return loaded(event);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Event event)? loaded,
    TResult? Function(LockedEventShell shell)? locked,
  }) {
    return loaded?.call(event);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Event event)? loaded,
    TResult Function(LockedEventShell shell)? locked,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(event);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EventDetailLoaded value) loaded,
    required TResult Function(EventDetailLocked value) locked,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(EventDetailLoaded value)? loaded,
    TResult? Function(EventDetailLocked value)? locked,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EventDetailLoaded value)? loaded,
    TResult Function(EventDetailLocked value)? locked,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class EventDetailLoaded implements EventDetailState {
  const factory EventDetailLoaded(final Event event) = _$EventDetailLoadedImpl;

  Event get event;
  @JsonKey(ignore: true)
  _$$EventDetailLoadedImplCopyWith<_$EventDetailLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EventDetailLockedImplCopyWith<$Res> {
  factory _$$EventDetailLockedImplCopyWith(_$EventDetailLockedImpl value,
          $Res Function(_$EventDetailLockedImpl) then) =
      __$$EventDetailLockedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({LockedEventShell shell});

  $LockedEventShellCopyWith<$Res> get shell;
}

/// @nodoc
class __$$EventDetailLockedImplCopyWithImpl<$Res>
    extends _$EventDetailStateCopyWithImpl<$Res, _$EventDetailLockedImpl>
    implements _$$EventDetailLockedImplCopyWith<$Res> {
  __$$EventDetailLockedImplCopyWithImpl(_$EventDetailLockedImpl _value,
      $Res Function(_$EventDetailLockedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shell = null,
  }) {
    return _then(_$EventDetailLockedImpl(
      null == shell
          ? _value.shell
          : shell // ignore: cast_nullable_to_non_nullable
              as LockedEventShell,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $LockedEventShellCopyWith<$Res> get shell {
    return $LockedEventShellCopyWith<$Res>(_value.shell, (value) {
      return _then(_value.copyWith(shell: value));
    });
  }
}

/// @nodoc

class _$EventDetailLockedImpl implements EventDetailLocked {
  const _$EventDetailLockedImpl(this.shell);

  @override
  final LockedEventShell shell;

  @override
  String toString() {
    return 'EventDetailState.locked(shell: $shell)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventDetailLockedImpl &&
            (identical(other.shell, shell) || other.shell == shell));
  }

  @override
  int get hashCode => Object.hash(runtimeType, shell);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventDetailLockedImplCopyWith<_$EventDetailLockedImpl> get copyWith =>
      __$$EventDetailLockedImplCopyWithImpl<_$EventDetailLockedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Event event) loaded,
    required TResult Function(LockedEventShell shell) locked,
  }) {
    return locked(shell);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Event event)? loaded,
    TResult? Function(LockedEventShell shell)? locked,
  }) {
    return locked?.call(shell);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Event event)? loaded,
    TResult Function(LockedEventShell shell)? locked,
    required TResult orElse(),
  }) {
    if (locked != null) {
      return locked(shell);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EventDetailLoaded value) loaded,
    required TResult Function(EventDetailLocked value) locked,
  }) {
    return locked(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(EventDetailLoaded value)? loaded,
    TResult? Function(EventDetailLocked value)? locked,
  }) {
    return locked?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EventDetailLoaded value)? loaded,
    TResult Function(EventDetailLocked value)? locked,
    required TResult orElse(),
  }) {
    if (locked != null) {
      return locked(this);
    }
    return orElse();
  }
}

abstract class EventDetailLocked implements EventDetailState {
  const factory EventDetailLocked(final LockedEventShell shell) =
      _$EventDetailLockedImpl;

  LockedEventShell get shell;
  @JsonKey(ignore: true)
  _$$EventDetailLockedImplCopyWith<_$EventDetailLockedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
