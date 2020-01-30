import 'package:flutter/material.dart';
import './ui/screens/home.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HackerNews',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: HomeScreen(title: 'HackerNews'),
      debugShowCheckedModeBanner: false,
    );
  }
}
