import 'package:cherry_components/cherry_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';

import '../widgets/widgets.dart';
import '../../blocs/blocs.dart';

/// Here lays all available options for the user to be configurable.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  AppTheme _themeIndex;
  Browser _browserIndex;
  ReadingMode _readingModeIndex;

  @override
  void initState() {
    // Get the app theme & browser chooser from the 'AppModel' model.
    _themeIndex = context.read<ThemeCubit>().state;
    _browserIndex = context.read<BrowserCubit>().state;
    _readingModeIndex = context.read<ReadingModeCubit>().state;

    super.initState();
  }

  @override
  Widget build(BuildContext parentContext) {
    return SimplePage(
      title: FlutterI18n.translate(parentContext, 'app.menu.settings'),
      body: Builder(
        builder: (context) => ListView(
          children: <Widget>[
            HeaderText(
              FlutterI18n.translate(
                context,
                'screen.settings.headers.general',
              ),
              head: true,
            ),
            ListCell.icon(
              icon: Icons.palette,
              title: FlutterI18n.translate(
                context,
                'screen.settings.theme.title',
              ),
              subtitle: FlutterI18n.translate(
                context,
                'screen.settings.theme.body',
              ),
              onTap: () => showBottomRoundDialog(
                context: context,
                title: FlutterI18n.translate(
                  context,
                  'screen.settings.theme.title',
                ),
                children: <Widget>[
                  RadioCell<AppTheme>(
                    title: FlutterI18n.translate(
                      context,
                      'screen.settings.theme.theme.dark',
                    ),
                    groupValue: _themeIndex,
                    value: AppTheme.dark,
                    onChanged: (value) => _changeTheme(context, value),
                  ),
                  RadioCell<AppTheme>(
                    title: FlutterI18n.translate(
                      context,
                      'screen.settings.theme.theme.black',
                    ),
                    groupValue: _themeIndex,
                    value: AppTheme.black,
                    onChanged: (value) => _changeTheme(context, value),
                  ),
                  RadioCell<AppTheme>(
                    title: FlutterI18n.translate(
                      context,
                      'screen.settings.theme.theme.light',
                    ),
                    groupValue: _themeIndex,
                    value: AppTheme.light,
                    onChanged: (value) => _changeTheme(context, value),
                  ),
                  RadioCell<AppTheme>(
                    title: FlutterI18n.translate(
                      context,
                      'screen.settings.theme.theme.system',
                    ),
                    groupValue: _themeIndex,
                    value: AppTheme.system,
                    onChanged: (value) => _changeTheme(context, value),
                  ),
                ],
              ),
            ),
            Separator.divider(indent: 72),
            ListCell.icon(
              icon: Icons.open_in_browser,
              title: FlutterI18n.translate(
                context,
                'screen.settings.browser.title',
              ),
              subtitle: FlutterI18n.translate(
                context,
                'screen.settings.browser.body',
              ),
              onTap: () => showBottomRoundDialog(
                context: context,
                title: FlutterI18n.translate(
                  context,
                  'screen.settings.browser.title',
                ),
                children: <Widget>[
                  RadioCell<Browser>(
                    title: FlutterI18n.translate(
                      context,
                      'screen.settings.browser.browser.internal',
                    ),
                    groupValue: _browserIndex,
                    value: Browser.internal,
                    onChanged: (value) => _changeBrowser(context, value),
                  ),
                  RadioCell<Browser>(
                    title: FlutterI18n.translate(
                      context,
                      'screen.settings.browser.browser.external',
                    ),
                    groupValue: _browserIndex,
                    value: Browser.external,
                    onChanged: (value) => _changeBrowser(context, value),
                  ),
                ],
              ),
            ),
            Separator.divider(indent: 72),
            ListCell.icon(
              icon: Icons.chrome_reader_mode,
              title: FlutterI18n.translate(
                context,
                'screen.settings.reading_mode.title',
              ),
              subtitle: FlutterI18n.translate(
                context,
                'screen.settings.reading_mode.body',
              ),
              onTap: () => showBottomRoundDialog(
                context: context,
                title: FlutterI18n.translate(
                  context,
                  'screen.settings.reading_mode.title',
                ),
                children: <Widget>[
                  RadioCell<ReadingMode>(
                    title: FlutterI18n.translate(
                      context,
                      'screen.settings.reading_mode.mode.title_only',
                    ),
                    groupValue: _readingModeIndex,
                    value: ReadingMode.titleOnly,
                    onChanged: (value) => _changeReadingMode(context, value),
                  ),
                  RadioCell<ReadingMode>(
                    title: FlutterI18n.translate(
                      context,
                      'screen.settings.reading_mode.mode.minimalist',
                    ),
                    groupValue: _readingModeIndex,
                    value: ReadingMode.minimalist,
                    onChanged: (value) => _changeReadingMode(context, value),
                  ),
                  RadioCell<ReadingMode>(
                    title: FlutterI18n.translate(
                      context,
                      'screen.settings.reading_mode.mode.with_content',
                    ),
                    groupValue: _readingModeIndex,
                    value: ReadingMode.withContent,
                    onChanged: (value) => _changeReadingMode(context, value),
                  ),
                ],
              ),
            ),
            Separator.divider(indent: 72),
          ],
        ),
      ),
    );
  }

  // Updates app's theme
  void _changeTheme(BuildContext context, AppTheme theme) {
    context.read<ThemeCubit>().updateTheme(theme);
    setState(() => _themeIndex = theme);
    Navigator.of(context).pop();
    _displayMessage(context, "Theme has changed");
  }

  // Updates app's chosen browser
  void _changeBrowser(BuildContext context, Browser browser) {
    context.read<BrowserCubit>().chooseBrowser(browser);
    setState(() => _browserIndex = browser);
    Navigator.of(context).pop();
    _displayMessage(context, "Browser has changed");
  }

  void _changeReadingMode(BuildContext context, ReadingMode mode) {
    context.read<ReadingModeCubit>().changeMode(mode);
    setState(() => _readingModeIndex = mode);
    Navigator.of(context).pop();
    _displayMessage(context, "Reading Mode has changed");
  }

  void _displayMessage(BuildContext context, String message) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
