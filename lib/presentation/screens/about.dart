import 'package:cherry_components/cherry_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';
import 'package:row_collection/row_collection.dart';

import '../../const.dart';
import '../widgets/widgets.dart';
import '../../utils/url_util.dart';
import '../../blocs/changelog/changelog_cubit.dart';
import 'screens.dart';

/// This view contains a list with useful
/// information about the app & its developer.
class AboutScreen extends StatefulWidget {
  const AboutScreen({Key key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  PackageInfo _packageInfo = PackageInfo(
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  // Gets information about the app itself
  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() => _packageInfo = info);
  }

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: FlutterI18n.translate(context, 'app.menu.about'),
      body: ListView(children: <Widget>[
        HeaderText(
          FlutterI18n.translate(
            context,
            'screen.about.headers.about',
          ),
          head: true,
        ),
        ListCell.icon(
          icon: Icons.info_outline,
          title: FlutterI18n.translate(
            context,
            'screen.about.version.title',
            translationParams: {'version': _packageInfo.version},
          ),
          subtitle: FlutterI18n.translate(
            context,
            'screen.about.version.body',
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider<ChangelogCubit>(
                create: (_) => ChangelogCubit()..getChangelog(),
                child: ChangelogScreen(),
              ),
              fullscreenDialog: true,
            ),
          ),
        ),
        Separator.divider(indent: 72),
        ListCell.icon(
          icon: Icons.star_border,
          title: FlutterI18n.translate(
            context,
            'screen.about.review.title',
          ),
          subtitle: FlutterI18n.translate(
            context,
            'screen.about.review.body',
          ),
          onTap: () => LaunchReview.launch(),
        ),
        Separator.divider(indent: 72),
        ListCell.icon(
          icon: Icons.public,
          title: FlutterI18n.translate(
            context,
            'screen.about.free_software.title',
          ),
          subtitle: FlutterI18n.translate(
            context,
            'screen.about.free_software.body',
          ),
          onTap: () => UrlUtils.openWebBrowser(context, Const.appSource),
        ),
        HeaderText(FlutterI18n.translate(
          context,
          'screen.about.headers.author',
        )),
        ListCell.icon(
          icon: Icons.person_outline,
          title: FlutterI18n.translate(
            context,
            'screen.about.author.title',
            translationParams: {'author': Const.author},
          ),
          subtitle: FlutterI18n.translate(
            context,
            'screen.about.author.body',
          ),
          onTap: () => UrlUtils.openWebBrowser(context, Const.authorProfile),
        ),
        Separator.divider(indent: 72),
        ListCell.icon(
          icon: Icons.mail_outline,
          title: FlutterI18n.translate(
            context,
            'screen.about.email.title',
          ),
          subtitle: FlutterI18n.translate(
            context,
            'screen.about.email.body',
          ),
          onTap: () => FlutterEmailSender.send(Email(
            subject: Const.emailSubject,
            recipients: [Const.emailAddress],
          )),
        ),
        HeaderText(FlutterI18n.translate(
          context,
          'screen.about.headers.credits',
        )),
        ListCell.icon(
          icon: Icons.code,
          title: FlutterI18n.translate(
            context,
            'screen.about.flutter.title',
          ),
          subtitle: FlutterI18n.translate(
            context,
            'screen.about.flutter.body',
          ),
          onTap: () => UrlUtils.openWebBrowser(context, Const.flutterPage),
        ),
        Separator.divider(indent: 72),
        ListCell.icon(
          icon: Icons.folder_open,
          title: FlutterI18n.translate(
            context,
            'screen.about.credits.title',
          ),
          subtitle: FlutterI18n.translate(
            context,
            'screen.about.credits.body',
            translationParams: {'api': Const.apiSourceName},
          ),
          onTap: () => UrlUtils.openWebBrowser(context, Const.apiSource),
        ),
        Separator.divider(indent: 72),
      ]),
    );
  }
}
