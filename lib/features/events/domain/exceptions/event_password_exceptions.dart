import '../entities/locked_event_shell.dart';

class EventPasswordRequiredException implements Exception {
  final LockedEventShell shell;
  const EventPasswordRequiredException(this.shell);

  @override
  String toString() =>
      'EventPasswordRequiredException(uuid=${shell.uuid}, title=${shell.title})';
}

class InvalidEventPasswordException implements Exception {
  const InvalidEventPasswordException();

  @override
  String toString() => 'InvalidEventPasswordException()';
}

class EventNotProtectedException implements Exception {
  const EventNotProtectedException();

  @override
  String toString() => 'EventNotProtectedException()';
}

class EventPasswordRateLimitedException implements Exception {
  final Duration retryAfter;
  const EventPasswordRateLimitedException(this.retryAfter);

  @override
  String toString() =>
      'EventPasswordRateLimitedException(retryAfter=${retryAfter.inSeconds}s)';
}

class EventValidationException implements Exception {
  const EventValidationException();

  @override
  String toString() => 'EventValidationException()';
}

class EventNotFoundException implements Exception {
  const EventNotFoundException();

  @override
  String toString() => 'EventNotFoundException()';
}
