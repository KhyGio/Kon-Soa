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
    apiKey: 'AIzaSyDx4x0piTXOjZ4wQkKt33Lr1sJ0SHSJOkA',
    appId: '1:867029141932:android:08bd17303e81dd7789d209',
    messagingSenderId: '867029141932',
    projectId: 'konsoa',
    databaseURL: 'https://konsoa-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'konsoa.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBDi2G2aKeGXVUUEyL_9egmpkXwx_Rj4Og',
    appId: '1:867029141932:ios:4212c800eccdae4489d209',
    messagingSenderId: '867029141932',
    projectId: 'konsoa',
    databaseURL: 'https://konsoa-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'konsoa.firebasestorage.app',
    iosClientId: '867029141932-dq2a5c9ck49641ftfpam53hauln5um83.apps.googleusercontent.com',
    iosBundleId: 'com.vaathanaa007.konsoa',
  );
}
