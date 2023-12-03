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
        return macos;
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
    apiKey: 'AIzaSyAKIJeIQo_KPzDxpY7YzqStwXSwp9ThLWg',
    appId: '1:998818977233:web:a3cb8a0f2df12ac5bcfcf0',
    messagingSenderId: '998818977233',
    projectId: 'coastal-case-405300',
    authDomain: 'coastal-case-405300.firebaseapp.com',
    storageBucket: 'coastal-case-405300.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCsPz2TKh3DDG6wd4FP-zSJ8XTsRvvLQ6Q',
    appId: '1:998818977233:android:68eeeadb0e36f080bcfcf0',
    messagingSenderId: '998818977233',
    projectId: 'coastal-case-405300',
    storageBucket: 'coastal-case-405300.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB16rGICUp7KHNnjOr6FomCYu_m6dZsUUU',
    appId: '1:998818977233:ios:85a6bfdd2b8d38c5bcfcf0',
    messagingSenderId: '998818977233',
    projectId: 'coastal-case-405300',
    storageBucket: 'coastal-case-405300.appspot.com',
    iosBundleId: 'com.example.ecodeVerrifier',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB16rGICUp7KHNnjOr6FomCYu_m6dZsUUU',
    appId: '1:998818977233:ios:e2205a33e8ee7642bcfcf0',
    messagingSenderId: '998818977233',
    projectId: 'coastal-case-405300',
    storageBucket: 'coastal-case-405300.appspot.com',
    iosBundleId: 'com.example.ecodeVerrifier.RunnerTests',
  );
}