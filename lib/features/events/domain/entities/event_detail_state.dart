import 'package:freezed_annotation/freezed_annotation.dart';

import 'event.dart';
import 'locked_event_shell.dart';

part 'event_detail_state.freezed.dart';

@freezed
sealed class EventDetailState with _$EventDetailState {
  const factory EventDetailState.loaded(Event event) = EventDetailLoaded;
  const factory EventDetailState.locked(LockedEventShell shell) =
      EventDetailLocked;
}
