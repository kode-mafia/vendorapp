import 'package:flutter/material.dart';
import 'package:vendorapp_mulitvendorapp/screens/dashboard_screen.dart';
import 'package:vendorapp_mulitvendorapp/screens/product_screen.dart';

class DrawerServices {
  Widget drawerScreen(title){
    if(title=='Dashboard'){
      return MainScreen();
    }
    if(title=='Product'){
      return ProductScreen();
    }
    if(title=='Dashboard'){
      return MainScreen();
    }
    if(title=='Dashboard'){
      return MainScreen();
    }
    if(title=='Dashboard'){
      return MainScreen();
    }
    if(title=='Dashboard'){
      return MainScreen();
    }
    if(title=='Dashboard'){
      return MainScreen();
    }
    return MainScreen();
  }
}