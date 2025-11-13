// IMPORTANT: This file contains placeholder values.
// You MUST replace them with your actual Firebase project credentials.
// Run: flutterfire configure
// Or manually update the values below with your Firebase project settings.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return windows;
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
    apiKey: 'AIzaSyCR4sxtbiyoMi64kQrKmQ8H2Hk0SyUWSYo',
    appId: '1:777727641177:web:ae94443f2fcdce0e9e1348',
    messagingSenderId: '777727641177',
    projectId: 'bodyfit1',
    authDomain: 'bodyfit1.firebaseapp.com',
    storageBucket: 'bodyfit1.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD-Ps-DZRlmehmZt3o99JbPpjVtMP6inGk',
    appId: '1:777727641177:android:b2f1d3ee0a5a721f9e1348',
    messagingSenderId: '777727641177',
    projectId: 'bodyfit1',
    storageBucket: 'bodyfit1.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBZJ4rcudc8TuXzN5LNJKxb_ZkZBiSeis8',
    appId: '1:777727641177:ios:01a773570eddd0199e1348',
    messagingSenderId: '777727641177',
    projectId: 'bodyfit1',
    storageBucket: 'bodyfit1.firebasestorage.app',
    iosBundleId: 'com.example.bodyfit',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBZJ4rcudc8TuXzN5LNJKxb_ZkZBiSeis8',
    appId: '1:777727641177:ios:01a773570eddd0199e1348',
    messagingSenderId: '777727641177',
    projectId: 'bodyfit1',
    storageBucket: 'bodyfit1.firebasestorage.app',
    iosBundleId: 'com.example.bodyfit',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCR4sxtbiyoMi64kQrKmQ8H2Hk0SyUWSYo',
    appId: '1:777727641177:web:01c90fe5ee3ed8a09e1348',
    messagingSenderId: '777727641177',
    projectId: 'bodyfit1',
    authDomain: 'bodyfit1.firebaseapp.com',
    storageBucket: 'bodyfit1.firebasestorage.app',
  );

}