// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCFfTlmJ3Q-qHasjEoXEH7KoLg9GqmogW0',
    appId: '1:863686438950:web:8a70d4a5e7c424a4bc36e7',
    messagingSenderId: '863686438950',
    projectId: 'whatsapp-f82f5',
    authDomain: 'whatsapp-f82f5.firebaseapp.com',
    storageBucket: 'whatsapp-f82f5.appspot.com',
    measurementId: 'G-P1DP4RN208',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDZ7Lo4ppCwdwgny5lUAO3Ayr0dTN6xemY',
    appId: '1:863686438950:android:7c48ee884cd50525bc36e7',
    messagingSenderId: '863686438950',
    projectId: 'whatsapp-f82f5',
    storageBucket: 'whatsapp-f82f5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDvVqiVPXRe0h7xYwyf4zVmII8Yf2pv3VA',
    appId: '1:863686438950:ios:570dbdc2d894c75fbc36e7',
    messagingSenderId: '863686438950',
    projectId: 'whatsapp-f82f5',
    storageBucket: 'whatsapp-f82f5.appspot.com',
    iosBundleId: 'com.example.flutterApplication10',
  );
}
