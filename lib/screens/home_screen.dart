import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vendorapp_mulitvendorapp/screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String id = ' home-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: (){
            FirebaseAuth.instance.signOut();
            Navigator.pushNamed(context, LoginScreen.id);
          },
          child: Text('Log Out'),
        ),
      ),
    );
  }
}
