import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:vendorapp_mulitvendorapp/providers/product_provider.dart';
import 'package:vendorapp_mulitvendorapp/services/firebase_services.dart';
import 'package:vendorapp_mulitvendorapp/widgets/category_list.dart';

class EditViewProduct extends StatefulWidget {
  final String productId;

  EditViewProduct({this.productId});

  @override
  _EditViewProductState createState() => _EditViewProductState();
}

class _EditViewProductState extends State<EditViewProduct> {
  FirebaseServices _services = FirebaseServices();
  final _formkey = GlobalKey<FormState>();
  List<String> _collections = [
    'Featured Product',
    'Best Selling',
    'Recently Added',
  ];
  String dropdownValue;
  var _brandText = TextEditingController();
  var _skuText = TextEditingController();
  var _productNameText = TextEditingController();
  var _colorNameText = TextEditingController();
  var _priceText = TextEditingController();
  var _comparedPriceText = TextEditingController();
  var _descriptionText = TextEditingController();
  var _categoryTextController = TextEditingController();
  var _subcategoryTextController = TextEditingController();
  var _stockTextController = TextEditingController();
  var _lowstockTextController = TextEditingController();
  var _taxTextController = TextEditingController();
  bool _visible = false;
  DocumentSnapshot doc;
  double discount;
  String image;
  File _image;
  String categoryImage;
  bool _editing=true; //now can't edit only view

  @override
  void initState() {
    getProductDetails();
    super.initState();
  }

  Future<void> getProductDetails() async {
    _services.products
        .doc(widget.productId)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        doc = document;
        setState(() {
          _brandText.text = document.data()['brand'];
          _skuText.text = document.data()['sku'];
          _productNameText.text = document.data()['productName'];
          _colorNameText.text = document.data()['color'];
          _priceText.text = document.data()['price'].toString();
          _priceText.text = document.data()['comparedPrice'].toString();
          discount = ((double.parse(_priceText.text) /
                  int.parse(_comparedPriceText.text)) *
              100);
          image = document.data()['productImage'];
          _categoryTextController.text =
              document.data()['category']['mainCategory'];
          _subcategoryTextController.text =
              document.data()['category']['subCategory'];
          dropdownValue = document.data()['collection'];
          _stockTextController.text = document.data()['stockQty'].toString();
          _lowstockTextController.text =
              document.data()['lowstockQty'].toString();
          _taxTextController.text = document.data()['tax'].toString();
          categoryImage = document.data()['categoryImage'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          //to make back button white
          color: Colors.white,
        ),
        actions: [
          FlatButton(
            child: Text('Edit',style: TextStyle(color: Colors.white),),
            onPressed: (){
              setState(() {
                _editing=false;
              });
            },
          )
        ],
      ),
      bottomSheet: Container(
        height: 60,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.black87,
                  child: Center(
                      child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
            ),
            Expanded(
              child: AbsorbPointer(
                absorbing: _editing,
                child: InkWell(
                  onTap: (){
                      if(_formkey.currentState.validate()){
                        EasyLoading.show(status:'Saving.....');
                        if(_image!=null){
                          //first upload new image and save data
                          _provider.uploadProductImage(_image.path, _productNameText.text).then((url){
                            if(url!=null){
                              EasyLoading.dismiss();
                              _provider.updateProduct(
                                context: context,
                                productName: _productNameText.text,
                                color: _colorNameText.text,
                                tax: double.parse(_taxTextController.text),
                                stockQty: int.parse(_stockTextController.text),
                                sku: _skuText.text,
                                price: double.parse(_priceText.text),
                                lowStockQty: int.parse(_lowstockTextController.text),
                                description: _descriptionText.text,
                                collection: dropdownValue,
                                brand: _brandText.text,
                                comparedPrice: int.parse(_comparedPriceText.text),
                                productId: widget.productId,
                                image: image,
                                category: _categoryTextController,
                                subCategory: _subcategoryTextController.text,
                                categoryImage: categoryImage,
                              );
                            }
                          });
                        }else{
                          //no need to change image, so just save new data, no need to upload
                          _provider.updateProduct(
                            context: context,
                            productName: _productNameText.text,
                            color: _colorNameText.text,
                            tax: double.parse(_taxTextController.text),
                            stockQty: int.parse(_stockTextController.text),
                            sku: _skuText.text,
                            price: double.parse(_priceText.text),
                            lowStockQty: int.parse(_lowstockTextController.text),
                            description: _descriptionText.text,
                            collection: dropdownValue,
                            brand: _brandText.text,
                            comparedPrice: int.parse(_comparedPriceText.text),
                            productId: widget.productId,
                            image: image,
                            category: _categoryTextController,
                            subCategory: _subcategoryTextController.text,
                            categoryImage: categoryImage,
                          );
                          EasyLoading.dismiss();
                        }
                      }
                  },
                  child: Container(
                    color: Colors.pinkAccent,
                    child: Center(
                        child: Text('Save', style: TextStyle(color: Colors.white))),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: doc == null
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formkey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    AbsorbPointer(
                      absorbing: _editing,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 80,
                                height: 40,
                                child: TextFormField(
                                  controller: _brandText,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    hintText: 'Brand',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(),
                                    filled: true,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('SKU'),
                                  Container(
                                    width: 50,
                                    child: TextFormField(
                                      controller: _skuText,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                            child: TextFormField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                              controller: _productNameText,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: TextFormField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                              controller: _colorNameText,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 80,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                    prefixText: '\$',
                                  ),
                                  controller: _priceText,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Container(
                                width: 80,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                    prefixText: '\$',
                                  ),
                                  controller: _comparedPriceText,
                                  style: TextStyle(
                                      fontSize: 18,
                                      decoration: TextDecoration.lineThrough),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.red,
                                ),
                                child: Text(
                                  '${discount.toStringAsFixed(0)}% OFF',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Inclusive of all Taxes',
                            style: TextStyle(color: Colors.grey),
                          ),
                          InkWell(
                            onTap: (){
                              _provider.getProductImage().then((image){
                                setState(() {
                                  _image = image;
                                });
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _image != null ? Image.file(_image, height: 300,) : Image.network(image, height: 300,),),
                          ),
                          Text(
                            'About this Product',
                            style: TextStyle(fontSize: 20),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              maxLines: null,
                              controller: _descriptionText,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(color: Colors.grey),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                              bottom: 10,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Category',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: AbsorbPointer(
                                    absorbing: true,
                                    //this will block user entering category name manually
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Select a category';
                                        }
                                        return null;
                                      },
                                      controller: _categoryTextController,
                                      decoration: InputDecoration(
                                        hintText: 'Not Selected',
                                        //item code
                                        labelStyle: TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey[300],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit_outlined),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CategoryList();
                                        }).whenComplete(() {
                                      setState(() {
                                        _categoryTextController.text =
                                            _provider.selectedCategory;
                                        _visible = true;
                                      });
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: _visible,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10, bottom: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Sub Category',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: AbsorbPointer(
                                      absorbing: true,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Select a sub category';
                                          }
                                          return null;
                                        },
                                        controller: _subcategoryTextController,
                                        decoration: InputDecoration(
                                          hintText: 'Not Selected',
                                          //item code
                                          labelStyle:
                                              TextStyle(color: Colors.grey),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _editing?false:true,
                                    child: IconButton(
                                      icon: Icon(Icons.edit_outlined),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SubCategoryList();
                                            }).whenComplete(() {
                                          setState(() {
                                            _subcategoryTextController.text =
                                                _provider.selectedsubCategory;
                                          });
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Text(
                                  'Collection',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                DropdownButton<String>(
                                  hint: Text('Select Collection'),
                                  value: dropdownValue,
                                  icon: Icon(Icons.arrow_drop_down),
                                  onChanged: (String value) {
                                    setState(() {
                                      dropdownValue = value;
                                    });
                                  },
                                  items: _collections
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text('Stock: '),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                  controller: _stockTextController,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Low Stock: '),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                  controller: _lowstockTextController,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Tax %'),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                  controller: _taxTextController,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
