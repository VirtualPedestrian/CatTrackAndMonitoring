import 'package:cattrackandmonitoring/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cattrackandmonitoring/firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:cattrackandmonitoring/dashboard.dart';
import 'package:cattrackandmonitoring/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false ,
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme:
          ColorScheme.fromSeed(seedColor:
          Colors.deepPurple)
      ),
      initialRoute: "/",

      routes: {
        "/": (context) => loginPage(),
        "/signUpPage": (context) => signUpPage(),
        "/loginPage": (context) => dashboardPage(),

      },
    );
  }
}