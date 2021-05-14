import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:vendorapp_mulitvendorapp/providers/product_provider.dart';
import 'package:vendorapp_mulitvendorapp/widgets/category_list.dart';

class AddNewProduct extends StatefulWidget {
  static const String id = 'add-new-product-screen';

  const AddNewProduct({Key key}) : super(key: key);

  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _formKey = GlobalKey<FormState>();
  List<String> _collections = [
    'Featured Product',
    'Best Selling',
    'Recently Added',
  ];
  String dropdownValue;
  var _categoryTextController = TextEditingController();
  var _subcategoryTextController = TextEditingController();
  var _comparedPriceTextController = TextEditingController();
  var _brandTextController = TextEditingController();
  var _lowStockTextController=TextEditingController();
  var _stockTextController=TextEditingController();
  File _image;
  bool _visible = false;
  bool _track=false;
  String productName;
  String description;
  double productPrice;
  double comparedPrice;
  String sku;
  String color;
  double tax;
  int stockQty;

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    _provider.resetProvider();
    return DefaultTabController(
      length: 2,
      initialIndex: 1,//will keep initial index 1 to avoid textfield clearing automatically
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Material(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Container(
                          child: Text('Products / Add'),
                        ),
                      ),
                      // ignore: deprecated_member_use
                      FlatButton.icon(
                        onPressed: () {
                          if(_formKey.currentState.validate()){
                            //only if filled necessary field
                          if(_categoryTextController.text.isEmpty){
    if(_subcategoryTextController.text.isNotEmpty){
    if(_image!=null){
    //image should be selected
    //upload image to storage
    EasyLoading.dismiss();
    _provider.uploadProductImage(_image.path, productName).then((url){
    if(url!=null){
    //upload image to firestore
    _provider.saveProductDataToDb(
    context: context,
    comparedPrice: int.parse(_comparedPriceTextController.text),
    brand: _brandTextController.text,
    collection: dropdownValue,
    description: description,
    lowStockQty: int.parse(_lowStockTextController.text),
    productName: productName,
    productPrice: productPrice,
    sku: sku,
    stockQty: int.parse(_stockTextController.text),
    tax: tax,
    color: color,
    );

    setState(() {
      //clear all existing value after submitting the form
    _formKey.currentState.reset();
    _comparedPriceTextController.clear();
   dropdownValue=null;
   _subcategoryTextController.clear();
   _categoryTextController.clear();
   _brandTextController.clear();
   _track=false;
   _image=null;
   _visible=false;
    });

    }else{
    //image not selected
    _provider.alertDialog(
    context:context,
    title: 'IMAGE UPLOAD',
    content: 'Failed to upload image',
    );
    }
    });
    }
    //image not selected
    _provider.alertDialog(
    context:context,
    title: 'PRODUCT NAME',
    content: 'Product Image not selected',
    );
    }
    }else{
    _provider.alertDialog(
    context: context,
    title: 'Sub Category',
    content: 'Sub Category not selected',
    );
    }
                          }else{
                            _provider.alertDialog(
                              context: context,
                              title: 'Main Category',
                              content: 'Main Category not selected',
                            );
                          }
                         }
                        }
                        color: Theme.of(context).primaryColor,
                        icon: Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TabBar(
                indicatorColor: Theme.of(context).primaryColor,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(
                    text: 'GENERAL',
                  ),
                  Tab(
                    text: 'INVENTORY',
                  ),
                  Tab(),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: TabBarView(children: [
                      ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  validator:(value){
                                    if(value.isEmpty){
                                      return 'Enter Product Name';
                                    }
                                    setState(() {
                                      productName=value;
                                    });
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Product Name',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ))),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLength: 500,
                                  maxLines: 5,

                                  validator:(value){
                                    if(value.isEmpty){
                                      return 'Enter Product Description';
                                    }
                                    setState(() {
                                      description=value;
                                    });
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'About Product',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      _provider.getProductImage().then((image) {
                                        setState(() {
                                          _image = image;
                                        });
                                      });
                                    },
                                    child: SizedBox(
                                      width: 150,
                                      height: 150,
                                      child: Card(
                                        child: _image == null
                                            ? Text('Select Image')
                                            : Image.file(_image),
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  validator:(value){
                                    if(value.isEmpty){
                                      return 'Enter Selling Price';
                                    }
                                    setState(() {
                                      productPrice=double.parse(value);
                                    });
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Price',
                                    // final selling price
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  controller: _comparedPriceTextController,
                                  validator:(value){
                                    //not compulsary
                                    if(productPrice>double.parse(value)){ //always compared price should be higher
                                      return 'Compared Price should be higher than selling price';
                                    }
                                    return null;
                                  },

                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Compared Price',
                                    //price before discount
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ),
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
                                TextFormField(
                                  controller: _brandTextController,
                                  decoration: InputDecoration(
                                    labelText: 'Brand',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  validator: (value){
                                    if(value.isEmpty){
                                      return 'Enter SKU';
                                    }
                                    setState(() {
                                      sku=value;
                                    });
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'SKU', //item code
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ),
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
                                          absorbing: true, //this will block user entering category name manually
                                          child: TextFormField(
                                            validator: (value){
                                              if(value.isEmpty){
                                                return 'Select a category';
                                              }
                                              return null;
                                            },
                                            controller: _categoryTextController,
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
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 20),
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
                                              validator: (value){
                                                if(value.isEmpty){
                                                  return 'Select a sub category';
                                                }
                                                return null;
                                              },
                                              controller:
                                                  _subcategoryTextController,
                                              decoration: InputDecoration(
                                                hintText: 'Not Selected',
                                                //item code
                                                labelStyle:
                                                    TextStyle(color: Colors.grey),
                                                enabledBorder:
                                                    UnderlineInputBorder(
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
                                                builder:
                                                    (BuildContext context) {
                                                  return SubCategoryList();
                                                }).whenComplete(() {
                                              setState(() {
                                                _subcategoryTextController
                                                        .text =
                                                    _provider
                                                        .selectedsubCategory;
                                              });
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  validator: (value){
                                    if(value.isEmpty){
                                      return 'Enter color';
                                    }
                                    setState(() {
                                      color=value;
                                    });
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Color. Eg:- red,white,black,grey,pink', //item code
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  validator: (value){
                                    if(value.isEmpty){
                                      return 'Enter tax %';
                                    }
                                    setState(() {
                                      tax=double.parse(value);
                                    });
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'GST%', //item code
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SwitchListTile(
                              title: Text('Track Inventory',),
                              activeColor: Theme.of(context).primaryColor,
                              subtitle: Text('Switch ON to track Inventory',style: TextStyle(color: Colors.grey, fontSize: 12),),
                              value: _track,
                              onChanged: (selected){
                                   setState(() {
                                     _track = !_track;
                                   });
                              },
                            ),
                            Visibility(
                              visible: _track,
                              child: SizedBox(height: 300,
                              width: double.infinity,
                              child: Card(
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _stockTextController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'Inventory Quantity*', //item code
                                          labelStyle: TextStyle(color: Colors.grey),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        //not compulsory
                                        controller: _lowStockTextController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'Inventory Low Stock Quantity*', //item code
                                          labelStyle: TextStyle(color: Colors.grey),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
