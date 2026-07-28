import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/widgets/voice_fab/voice_fab_state.dart';

void main() {
  group('VoiceFabNotifier', () {
    test('startListening clears stale transcription and error', () {
      final notifier = VoiceFabNotifier()
        ..updateTranscription('old transcript')
        ..setError('old error');

      notifier.startListening();

      expect(notifier.state.status, VoiceFabStatus.listening);
      expect(notifier.state.transcription, isNull);
      expect(notifier.state.errorMessage, isNull);
    });

    test('reset clears stale transcription and error', () {
      final notifier = VoiceFabNotifier()
        ..updateTranscription('old transcript')
        ..setError('old error');

      notifier.reset();

      expect(notifier.state.status, VoiceFabStatus.idle);
      expect(notifier.state.transcription, isNull);
      expect(notifier.state.errorMessage, isNull);
    });
  });
}
