import 'package:flutter/material.dart';

class ErrorHt extends StatelessWidget {
  final String error;

  const ErrorHt({Key key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17.0,
              ),
            ),
            FlatButton(
              child: Text("Retry"),
              onPressed: null,
            )
          ],
        ),
      ),
    );
  }
}
