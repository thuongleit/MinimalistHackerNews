import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/widgets.dart';
import '../../blocs/blocs.dart';

/// This screen loads the [RELEASE_NOTES.md] file from GitHub,
/// and displays its content, using the Markdown plugin.
class ReleaseNotesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangelogCubit, NetworkState>(
      builder: (context, state) => ReloadablePage<ChangelogCubit>(
        title: FlutterI18n.translate(
            context, 'screen.about.version.release_notes'),
        body: Markdown(
          data: (state.data as String) ?? '',
          onTapLink: (_, url, __) => FlutterWebBrowser.openWebPage(
            url: url,
            customTabsOptions: CustomTabsOptions(
              toolbarColor: Theme.of(context).primaryColor,
            ),
          ),
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
            blockSpacing: 10,
            h2: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)
                .subtitle1
                .copyWith(
                  fontWeight: FontWeight.bold,
                ),
            p: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)
                .bodyText2
                .copyWith(
                  color: Theme.of(context).textTheme.caption.color,
                ),
          ),
        ),
      ),
    );
  }
}
