import 'package:flutter/material.dart';

class FadeLoading extends StatefulWidget {
  @override
  _FadeLoadingState createState() => _FadeLoadingState();
}

class _FadeLoadingState extends State<FadeLoading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).bottomAppBarColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Text(
              String.fromCharCode(Icons.arrow_drop_up.codePoint),
              style: TextStyle(
                  fontFamily: Icons.arrow_drop_up.fontFamily,
                  package: Icons.arrow_drop_up.fontPackage,
                  fontSize: 24.0,
                  color: Colors.grey),
            ),
          ),
          Padding(padding: EdgeInsets.fromLTRB(4, 0, 0, 4)),
          Flexible(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('', style: TextStyle(fontSize: 13.0)),
                  Center(
                    child: SizedBox(
                      child: const CircularProgressIndicator(strokeWidth: 1.0,),
                      height: 10,
                      width: 10,
                    ),
                  ),
                  Text(''),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
