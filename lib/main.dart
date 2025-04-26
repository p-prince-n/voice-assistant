import 'package:assistant/global_variable.dart';
import 'package:assistant/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Allen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: GlobalVariable.whiteColor,
        appBarTheme: AppBarTheme(backgroundColor: GlobalVariable.whiteColor),
      ),
      home: const HomePage(),
    );
  }
}
