import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hknews_repository/hknews_repository.dart';

import './utils/routes.dart';
import 'blocs/browser_chooser/browser_cubit.dart';
import 'blocs/theme/theme_cubit.dart';
import 'blocs/blocs.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    Key key,
    @required this.authenticationRepository,
    @required this.userRepository,
    @required this.storiesRepository,
  })  : assert(authenticationRepository != null),
        assert(userRepository != null),
        assert(storiesRepository != null),
        super(key: key);

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;
  final StoriesRepository storiesRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authenticationRepository),
        RepositoryProvider.value(value: userRepository),
        RepositoryProvider.value(value: storiesRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
          BlocProvider<BrowserCubit>(create: (_) => BrowserCubit()),
          BlocProvider<ViewModeCubit>(create: (_) => ViewModeCubit()),
          BlocProvider<AuthenticationBloc>(
            create: (_) => AuthenticationBloc(
                authenticationRepository: authenticationRepository),
          ),
        ],
        child: BlocBuilder<ThemeCubit, AppTheme>(
          builder: (context, theme) => MaterialApp(
            title: 'Simple Hacker News',
            theme: theme.value.themeData,
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
      ),
    );
  }
}
