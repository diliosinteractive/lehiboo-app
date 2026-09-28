import '../entities/locked_event_shell.dart';

class EventPasswordRequiredException implements Exception {
  final LockedEventShell shell;
  const EventPasswordRequiredException(this.shell);

  @override
  String toString() =>
      'EventPasswordRequiredException(uuid=${shell.uuid}, title=${shell.title})';
}

/// A rejected password attempt.
///
/// The verify endpoint sits behind the named `event-password` limiter, so
/// Laravel stamps every response — this 403 included — with the requester's
/// remaining budget for this event. Carrying it here keeps the sheet honest:
/// the counter is shared with `GET /events/{slug}?password=`, so a locally
/// counted total would drift from the budget that actually locks the user out.
/// Both fields stay null when a proxy strips the `X-RateLimit-*` headers.
class InvalidEventPasswordException implements Exception {
  final int? remainingAttempts;
  final int? attemptLimit;

  const InvalidEventPasswordException({
    this.remainingAttempts,
    this.attemptLimit,
  });

  @override
  String toString() => 'InvalidEventPasswordException('
      'remainingAttempts=$remainingAttempts, attemptLimit=$attemptLimit)';
}

class EventNotProtectedException implements Exception {
  const EventNotProtectedException();

  @override
  String toString() => 'EventNotProtectedException()';
}

/// The `event-password` budget is exhausted for this requester and event.
///
/// [retryAfter] mirrors the `Retry-After` header: the submit button stays
/// locked for exactly that long, and the server reports zero attempts left.
class EventPasswordRateLimitedException implements Exception {
  final Duration retryAfter;
  final int? attemptLimit;

  const EventPasswordRateLimitedException(this.retryAfter, {this.attemptLimit});

  @override
  String toString() => 'EventPasswordRateLimitedException('
      'retryAfter=${retryAfter.inSeconds}s, attemptLimit=$attemptLimit)';
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
