import 'package:cherry_components/cherry_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/index.dart';
import '../widgets/index.dart';

/// Here lays all available options for the user to be configurable.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Themes _themeIndex;

  @override
  void initState() {
    // Get the app theme & image quality from the 'AppModel' model.
    _themeIndex = context.read<ThemeProvider>().theme;

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
        ],
      ),
    );
  }

  // Updates app's theme
  Future<void> _changeTheme(Themes theme) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Saves new settings
    context.read<ThemeProvider>().theme = theme;
    prefs.setInt('theme', theme.index);

    // Updates UI
    setState(() => _themeIndex = theme);

    // Hides dialog
    Navigator.of(context).pop();
  }
}
