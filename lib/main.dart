import 'package:flutter/material.dart';
import 'package:mine_sweeper/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Mine Sweeper Demo';
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home' : (context) => Home(title: title),
      },
    );
  }
}

