import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Basic screen, which includes an [AppBar] widget.
/// Used when the desired page doesn't have slivers or reloading.
class SimplePage extends StatelessWidget {
  final String title;
  final Widget body, fab;
  final List<Widget> actions;

  const SimplePage({
    @required this.title,
    @required this.body,
    this.fab,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.rubik(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: actions,
      ),
      body: body,
      floatingActionButton: fab,
    );
  }
}
