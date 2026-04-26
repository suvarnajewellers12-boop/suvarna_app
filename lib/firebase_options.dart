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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAgp_0UEd5vE9us_ApTFbWJwgq8eePs6NQ',
    appId: '1:323391620783:android:26b86dfd6bc7961e3db65a',
    messagingSenderId: '323391620783',
    projectId: 'suvarna-jewellers-42d2c',
    storageBucket: 'suvarna-jewellers-42d2c.firebasestorage.app',
  );
}