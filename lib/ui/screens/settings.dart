import 'package:cherry_components/cherry_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/index.dart';
import '../widgets/index.dart';
import '../../utils/const.dart';

/// Here lays all available options for the user to be configurable.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Themes _themeIndex;
  Browser _browserIndex;

  @override
  void initState() {
    // Get the app theme & browser chooser from the 'AppModel' model.
    _themeIndex = context.read<ThemeProvider>().theme;
    _browserIndex = context.read<BrowserProvider>().browser;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: FlutterI18n.translate(context, 'app.menu.settings'),
      body: ListView(
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
                RadioCell<Themes>(
                  title: FlutterI18n.translate(
                    context,
                    'screen.settings.theme.theme.dark',
                  ),
                  groupValue: _themeIndex,
                  value: Themes.dark,
                  onChanged: (value) => _changeTheme(value),
                ),
                RadioCell<Themes>(
                  title: FlutterI18n.translate(
                    context,
                    'screen.settings.theme.theme.black',
                  ),
                  groupValue: _themeIndex,
                  value: Themes.black,
                  onChanged: (value) => _changeTheme(value),
                ),
                RadioCell<Themes>(
                  title: FlutterI18n.translate(
                    context,
                    'screen.settings.theme.theme.light',
                  ),
                  groupValue: _themeIndex,
                  value: Themes.light,
                  onChanged: (value) => _changeTheme(value),
                ),
                RadioCell<Themes>(
                  title: FlutterI18n.translate(
                    context,
                    'screen.settings.theme.theme.system',
                  ),
                  groupValue: _themeIndex,
                  value: Themes.system,
                  onChanged: (value) => _changeTheme(value),
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
                  onChanged: (value) => _changeBrowser(value),
                ),
                RadioCell<Browser>(
                  title: FlutterI18n.translate(
                    context,
                    'screen.settings.browser.browser.external',
                  ),
                  groupValue: _browserIndex,
                  value: Browser.external,
                  onChanged: (value) => _changeBrowser(value),
                ),
              ],
            ),
          ),
          Separator.divider(indent: 72),
        ],
      ),
    );
  }

  // Updates app's theme
  Future<void> _changeTheme(Themes theme) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Saves new settings
    context.read<ThemeProvider>().theme = theme;
    prefs.setInt(Const.prefThemeKey, theme.index);

    // Updates UI
    setState(() => _themeIndex = theme);

    // Hides dialog
    Navigator.of(context).pop();
  }

  // Updates app's chosen browser
  Future<void> _changeBrowser(Browser browser) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Saves new settings
    context.read<BrowserProvider>().browser = browser;
    prefs.setInt(Const.prefBrowserKey, browser.index);

    // Updates UI
    setState(() => _browserIndex = browser);

    // Hides dialog
    Navigator.of(context).pop();
  }
}
