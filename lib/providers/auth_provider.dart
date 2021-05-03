import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AuthProvider with ChangeNotifier{
  File image;
  bool isPicAvail= false;
  String pickerError =  ' ';
  double shopLatitude;
  double shopLongitude;
  String shopAddress;
  String placeName;

  Future<File> getImage() async{
  final picker = ImagePicker();
  final pickedFile = await picker.getImage(source: ImageSource.gallery);
  if (pickedFile!=null) {
      this.image = File(pickedFile.path);
      notifyListeners();
    }else{
    this.pickerError = 'No Image Selected';
      print('No Image Selected');
      notifyListeners();
    }
  return this.image;

}

 Future getCurrentAddress() async{
   Location location = new Location();

   bool _serviceEnabled;
   PermissionStatus _permissionGranted;
   LocationData _locationData;

   _serviceEnabled = await location.serviceEnabled();
   if (!_serviceEnabled) {
     _serviceEnabled = await location.requestService();
     if (!_serviceEnabled) {
       return;
     }
   }

   _permissionGranted = await location.hasPermission();
   if (_permissionGranted == PermissionStatus.denied) {
     _permissionGranted = await location.requestPermission();
     if (_permissionGranted != PermissionStatus.granted) {
       return;
     }
   }

   _locationData = await location.getLocation();
   this.shopLatitude = _locationData.latitude;
   this.shopLongitude = _locationData.longitude;
   notifyListeners();

   // From coordinates
   final coordinates = new Coordinates(_locationData.latitude, _locationData.longitude);
   var _addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
   var _shopAddress = _addresses.first;
   this.shopAddress = _shopAddress.addressLine;
   this.placeName = _shopAddress.featureName;
   notifyListeners();
   return shopAddress;
 }
}