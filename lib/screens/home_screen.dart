import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:vendorapp_mulitvendorapp/services/drawer_services.dart';
import 'package:vendorapp_mulitvendorapp/widgets/drawer_menu_widget.dart';

import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DrawerServices _services = DrawerServices();
  GlobalKey<SliderMenuContainerState> _key =
  new GlobalKey<SliderMenuContainerState>();
  String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliderMenuContainer(
          appBarColor: Colors.white,
          appBarHeight: 80,
          key: _key,
          sliderMenuOpenSize: 250,
          title: Text('',),
          trailing: Row(
            children: [
              IconButton(
                onPressed: (){},
                icon: Icon(CupertinoIcons.search),
              ),
              IconButton(
                onPressed: (){},
                icon: Icon(CupertinoIcons.bell),
              )
            ],
          ),
          sliderMenu: MenuWidget(
            onItemClick: (title) {
              _key.currentState.closeDrawer();
              setState(() {
                this.title = title;
              });
            },
          ),
          sliderMain: _services.drawerScreen(title)),
    );
  }
}
