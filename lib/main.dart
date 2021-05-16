import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:vendorapp_mulitvendorapp/providers/auth_provider.dart';
import 'package:vendorapp_mulitvendorapp/providers/order_provider.dart';
import 'package:vendorapp_mulitvendorapp/providers/product_provider.dart';
import 'package:vendorapp_mulitvendorapp/screens/add_edit_coupons.dart';
import 'package:vendorapp_mulitvendorapp/screens/add_newproduct_screen.dart';
import 'package:vendorapp_mulitvendorapp/screens/home_screen.dart';
import 'package:vendorapp_mulitvendorapp/screens/login_screen.dart';
import 'package:vendorapp_mulitvendorapp/screens/register_screen.dart';
import 'package:vendorapp_mulitvendorapp/screens/splash_screen.dart';
import 'package:vendorapp_mulitvendorapp/screens/reset_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;

  runApp(
    MultiProvider(
      providers: [
          Provider (create: (_) => AuthProvider(),),
        Provider (create: (_) => ProductProvider(),),
        Provider (create: (_) => OrderProvider()),
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
      builder: EasyLoading.init(),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        RegisterScreen.id:(context)=> RegisterScreen(),
        HomeScreen.id:(context)=> HomeScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        ResetPassword.id:(context)=>ResetPassword(),
        AddNewProduct.id:(context)=>AddNewProduct(),
        AddEditCoupon.id :(context)=>AddEditCoupon(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}


