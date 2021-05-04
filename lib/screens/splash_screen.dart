import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vendorapp_mulitvendorapp/screens/home_screen.dart';
import 'package:vendorapp_mulitvendorapp/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {

  static const String id = ' splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(
        Duration(
          seconds: 3,
        ),(){
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user==null) {
          Navigator.pushReplacementNamed(context, LoginScreen.id);
        }else{
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        }
      });
    }
    );
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/shapeyou_logo.png'),
            Text("Shape You - Vendor App", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}