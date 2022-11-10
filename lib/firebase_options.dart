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
    apiKey: 'AIzaSyAZmN-04uzOKIyUu3-bfSQDMDUHsChPg0E',
    appId: '1:584878089384:web:da1737aebb6a0c23d88e9d',
    messagingSenderId: '584878089384',
    projectId: 'pricemanager-5eb7e',
    authDomain: 'pricemanager-5eb7e.firebaseapp.com',
    storageBucket: 'pricemanager-5eb7e.appspot.com',
    measurementId: 'G-M3MSG3HZM6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAWK25TLvpsSrHwjaVnoV5uXWMhJNfgWCo',
    appId: '1:584878089384:android:f4f3bd8b0d892385d88e9d',
    messagingSenderId: '584878089384',
    projectId: 'pricemanager-5eb7e',
    storageBucket: 'pricemanager-5eb7e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCf4vhuXyELAXHp_vocTX1PQHEMft5LLgc',
    appId: '1:584878089384:ios:9912215def24d61fd88e9d',
    messagingSenderId: '584878089384',
    projectId: 'pricemanager-5eb7e',
    storageBucket: 'pricemanager-5eb7e.appspot.com',
    iosClientId: '584878089384-kfqoh5eqetes4j95vkmgetfss9g5ui51.apps.googleusercontent.com',
    iosBundleId: 'com.example.priceManager',
  );
}
