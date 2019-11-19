import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_sagga/LoginScn.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Sagga',
      initialRoute: '/',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: LoginScn(),
    );
  }
}
