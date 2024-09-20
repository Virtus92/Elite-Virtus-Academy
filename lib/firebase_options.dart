import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:nb_utils/nb_utils.dart';

///firebase configs
/// Refer this Step Add Firebase Option Step from the link below

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
        return firebaseConfig;
      case TargetPlatform.iOS:
        return firebaseConfig;
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

  static final FirebaseOptions firebaseConfig = FirebaseOptions(
    apiKey: 'AIzaSyCSjMom4jt_tFTxVjDYtE9j9uCQgjhVVs0',
    appId: isIOS ? '1:601408664475:android:2bded0d17f0def9800273e' : '1:601408664475:ios:31d70588d2f282ed00273e',
    messagingSenderId: '601408664475',
    projectId: 'eva---elite-virtus-academia',
    storageBucket: 'eva---elite-virtus-academia.appspot.com',
    iosBundleId: 'academy.virtus.elite',
  );
}
