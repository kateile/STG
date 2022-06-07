import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'ui/render_cubit.dart';
import 'utils/utils.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  MobileAds.instance.initialize();

  try {
    await Future.wait([
      Hive.initFlutter(),
      Firebase.initializeApp(), //In windows does not work
    ]);

    // Pass all uncaught errors from the framework to Crashlytics.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  } catch (_) {}

  /// Initializing Hive boxes
  /// Changing box types may result in error in the runtime
  /// If you want to update these make sure you have renamed your keys or do migration
  await Future.wait([
    Hive.openBox<int>(favoritesBoxKey),
    Hive.openBox<int>(recentsBoxKey),
  ]);

  //Removing screen
  FlutterNativeSplash.remove();

  runApp(
    BlocProvider(
      child: const App(),
      create: (context) {
        return RenderCubit()..read();
      },
    ),
  );
}
