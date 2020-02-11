import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10.0,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
