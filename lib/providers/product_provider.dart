import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier{
  String selectedCategory= 'not selected';
  String selectedsubCategory= 'not selected';
  File image;
  String pickerError = ' ' ;


  selectCategory(selected){
    this.selectedCategory = selected;
    notifyListeners();
  }

  selectsubCategory(selected){
    this.selectedsubCategory = selected;
    notifyListeners();
  }

  Future<File> getProductImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 20);
    if (pickedFile != null) {
      this.image = File(pickedFile.path);
      notifyListeners();
    } else {
      this.pickerError = 'No Image Selected';
      print('No Image Selected');
      notifyListeners();
    }
    return this.image;
  }
}