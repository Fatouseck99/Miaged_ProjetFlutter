import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:appli_miaged/login/login-page.dart';

import 'login/register.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialColor miagedColor = MaterialColor(
      0xFF137f8b,
      <int, Color>{
        50: Color(0xFFE1F5FE),
        100: Color(0xFFB3E5FC),
        200: Color(0xFF81D4FA),
        300: Color(0xFF4FC3F7),
        400: Color(0xFF29B6F6),
        500: Color(0xFF03A9F4),
        600: Color(0xFF039BE5),
        700: Color(0xFF0288D1),
        800: Color(0xFF0277BD),
        900: Color(0xFF01579B),
      },
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: miagedColor,
        //primaryColor: const Color(0xFF137f8b),
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
