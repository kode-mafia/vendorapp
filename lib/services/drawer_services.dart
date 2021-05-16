import 'package:flutter/material.dart';
import 'package:vendorapp_mulitvendorapp/screens/banner_screen.dart';
import 'package:vendorapp_mulitvendorapp/screens/coupon_screen.dart';
import 'package:vendorapp_mulitvendorapp/screens/dashboard_screen.dart';
import 'package:vendorapp_mulitvendorapp/screens/order_screen.dart';
import 'package:vendorapp_mulitvendorapp/screens/product_screen.dart';



class DrawerServices{

  Widget drawerScreen(title){
    if(title == 'Dashboard'){
      return MainScreen();
    }
    if(title == 'Product'){
      return ProductScreen();
    }

    if(title == 'Banner'){
      return BannerScreen();
    }
    if(title == 'Coupons'){
      return CouponScreen();
    }
    if(title == 'Orders'){
      return OrderScreen();
    }

    return MainScreen();
  }
}