import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import './utils/routes.dart';
import 'blocs/browser_chooser/browser_cubit.dart';
import 'blocs/theme/theme_cubit.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<BrowserCubit>(create: (_) => BrowserCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, theme) => MaterialApp(
          title: 'Simple Hacker News',
          theme: theme.themeData,
          // darkTheme: model.darkTheme,
          // themeMode: model.themeMode,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: Routes.generateRoute,
          onUnknownRoute: Routes.errorRoute,
          localizationsDelegates: [
            FlutterI18nDelegate(
              translationLoader: FileTranslationLoader(),
            )..load(null),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
        ),
      ),
    );
  }
}
