import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendorapp_mulitvendorapp/providers/auth_provider.dart';
import 'package:vendorapp_mulitvendorapp/screens/home_screen.dart';
import 'package:vendorapp_mulitvendorapp/screens/register_screen.dart';
import 'package:vendorapp_mulitvendorapp/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  runApp(
    MultiProvider(
      providers: [
          Provider (create: (_) => AuthProvider(),),
        ],
    child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF84c225),
        fontFamily: 'Lato',
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        RegisterScreen.id:(context)=> RegisterScreen(),
        HomeScreen.id:(context)=> HomeScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}


