// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyD5GOBfsz_WCEy4gnDZDMj7ip9X1wfk0nw',
    appId: '1:262575149280:android:319adeabe88a6bbac18085',
    messagingSenderId: '262575149280',
    projectId: 'iltrispizzeria',
    databaseURL: 'https://iltrispizzeria-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'iltrispizzeria.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBDr1akYP5tqEE11RxCf3ctKQqWimr6ixo',
    appId: '1:262575149280:ios:95a4a2310636e921c18085',
    messagingSenderId: '262575149280',
    projectId: 'iltrispizzeria',
    databaseURL: 'https://iltrispizzeria-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'iltrispizzeria.appspot.com',
    iosClientId: '262575149280-k1dvndmopjla83qui0fqpqge9acv1jes.apps.googleusercontent.com',
    iosBundleId: 'com.example.ilTrisManager',
  );
}