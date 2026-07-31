/// Serializes every mutation of the persisted authentication credentials.
///
/// Secure storage exposes independent asynchronous key writes, so checking an
/// auth epoch immediately before `write()` is not sufficient: an old refresh
/// can begin writing, a new login can persist its tokens, and then the old
/// write can complete last. All login/refresh/logout writers share this FIFO
/// boundary so one credential pair is fully replaced before another mutation
/// can begin.
class AuthCredentialMutationCoordinator {
  AuthCredentialMutationCoordinator();

  static final AuthCredentialMutationCoordinator instance =
      AuthCredentialMutationCoordinator();

  Future<void> _tail = Future<void>.value();

  Future<T> run<T>(Future<T> Function() mutation) {
    final turn = _tail.then<T>((_) => mutation());
    _tail = turn.then<void>(
      (_) {},
      onError: (Object _, StackTrace __) {},
    );
    return turn;
  }
}
