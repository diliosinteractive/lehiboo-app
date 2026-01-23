// File generated manually for Firebase configuration
// Project: lehiboo-77c35

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBqGSXYTnOvwFjqZUmYGf9yMFgAdEDEUPQ',
    appId: '1:44786304054:android:ed9fc5833d30d57ac74497',
    messagingSenderId: '44786304054',
    projectId: 'lehiboo-77c35',
    storageBucket: 'lehiboo-77c35.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCH4KZslwW3n876fHT5j_Mlz5EX9lGSuU8',
    appId: '1:44786304054:ios:ec5276b2fa63b299c74497',
    messagingSenderId: '44786304054',
    projectId: 'lehiboo-77c35',
    storageBucket: 'lehiboo-77c35.firebasestorage.app',
    iosBundleId: 'com.dilios.lehiboo',
  );
}
