import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier{
  String selectedCategory= 'not selected';
  String selectedsubCategory= 'not selected';
  String categoryImage;
  File image;
  String pickerError = ' ' ;
  String shopName='';
  String productUrl='';


  selectCategory(mainCategory, categoryImage){
    this.selectedCategory = mainCategory;
    this.categoryImage= categoryImage; //need to bring image here
    notifyListeners();
  }

  selectsubCategory(selected){
    this.selectedsubCategory = selected;
    notifyListeners();
  }

  getShopName(shopName){
    this.shopName = shopName;
    notifyListeners();
  }

  //upload product image
  Future<String> uploadProductImage(filePath,productName) async {
    File file = File(filePath); // need file path to upload, we already have inside provider
    var timeStamp= Timestamp.now().microsecondsSinceEpoch;
    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      await _storage
          .ref('productImage/${this.shopName}/$timeStamp').putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
    }
    //now after upload file we need to file url path to save in database
    String downloadURL = await _storage
        .ref('productImage/${this.shopName}/$timeStamp')
        .getDownloadURL();
    this.productUrl=downloadURL;
    notifyListeners();
    return downloadURL;
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

  alertDialog({context,title,content}){
    return showCupertinoDialog(
        context: context,
        builder: (BuildContext context){
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

  //save product data to firestore
Future<void>saveProductDataToDb(
    //need to bring these data here from Add product screen
        {productName,
      description,
      productPrice,
      comparedPrice,
      collection,
      brand,
      sku,
      color,
    tax,
    stockQty,
    lowStockQty,
      context
        }){
    var timeStamp=DateTime.now().microsecondsSinceEpoch;
    User user= FirebaseAuth.instance.currentUser;
    CollectionReference _products =  FirebaseFirestore.instance.collection('products');
   try{
     _products.doc(timeStamp.toString()).set({
       'seller': {'shoName':this.shopName,'sellerUid':user.uid},
       'productName': productName,
       'description':description,
       'price': productPrice,
       'comparedPrice':comparedPrice,
       'collection':collection,
       'brand':brand,
       'sku':sku,
       'category':{'MainCategory':this.selectedCategory,'subCategory':this.selectedsubCategory, 'categoryImage':this.categoryImage},
       'color':color,
       'tax':tax,
       'stockQty':stockQty,
       'lowStockQty':lowStockQty,
       'productId': timeStamp.toString(),
       'productImage':this.productUrl,
       'published':false, //keep initial value as false
     });
     this.alertDialog(
       context: context,
       title: 'SAVE DATA',
       content: 'Product Details saved successfully',
     );
   }catch(e){
     this.alertDialog(
       context: context,
       title: 'SAVE DATA',
       content: '${e.toString()}',
     );
   }
   return null;
  }
}