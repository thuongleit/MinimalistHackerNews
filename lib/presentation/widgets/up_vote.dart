import 'package:flutter/material.dart';

class UpVote extends StatelessWidget {
  const UpVote({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      String.fromCharCode(Icons.arrow_drop_up.codePoint),
      style: TextStyle(
          fontFamily: Icons.arrow_drop_up.fontFamily,
          package: Icons.arrow_drop_up.fontPackage,
          fontSize: 24.0,
          color: Colors.grey),
    );
  }
}
