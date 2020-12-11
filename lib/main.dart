import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hknews_repository/hknews_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import './app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build();
  await Firebase.initializeApp();

  if (kDebugMode) {
    // Force disable Crashlytics collection while doing every day development.
    // Temporarily toggle this to true if you want to test crash reporting in your app.
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(false);
  }
  final authRepo = AuthenticationRepositoryImpl();
  runApp(
    MyApp(
      authenticationRepository: authRepo,
      userRepository: UserRepositoryImpl(authenticationRepository: authRepo),
      storiesRepository: StoriesRepositoryImpl(),
    ),
  );
}
