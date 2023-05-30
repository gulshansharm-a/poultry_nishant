import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/main.dart';
import 'package:poultry_app/screens/bottomnav.dart';
import 'package:poultry_app/screens/mainscreens/homepage.dart';
import 'package:poultry_app/screens/start/intropage.dart';
import 'package:poultry_app/widgets/navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Timer(
        Duration(seconds: 4),
        () => NextScreen(
            context,
            isSignedIn && FirebaseAuth.instance.currentUser != null
                ? BottomNavigation()
                : IntroPage()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Image.asset(
        "assets/images/logo.png",
        height: 186,
        width: 186,
        fit: BoxFit.fill,
      )),
    );
  }
}
