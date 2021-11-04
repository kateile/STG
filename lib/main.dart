import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'utils/consts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  try {
    await Future.wait([
      Hive.initFlutter(),
      Firebase.initializeApp(), //In windows does not work
    ]);

    // Pass all uncaught errors from the framework to Crashlytics.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  } catch (_) {

  }

  /// Initializing Hive boxes
  /// Changing box types may result in error in the runtime
  /// If you want to update these make sure you have renamed your keys or do migration
  await Future.wait([
    Hive.openBox<int>(favoritesBoxKey),
    Hive.openBox<int>(recentsBoxKey),
  ]);

  runApp(const App());
}
