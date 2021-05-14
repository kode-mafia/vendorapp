import 'package:flutter/material.dart';
import 'package:vendorapp_mulitvendorapp/screens/add_newproduct_screen.dart';
import 'package:vendorapp_mulitvendorapp/widgets/published_product.dart';
import 'package:vendorapp_mulitvendorapp/widgets/unpublised_product.dart';

class ProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
         Material(
           elevation: 3,
           child: Padding(
             padding: const EdgeInsets.all(10.0),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Padding(
                   padding: const EdgeInsets.only(left:10.0),
                   child: Container(
                     child: Row(
                       children: [
                         Text('Products'),
                         SizedBox(width: 10,),
                         CircleAvatar(
                           backgroundColor: Colors.black54,
                           maxRadius: 8,
                           child: FittedBox(
                             child: Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Text('20', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                             ),
                           ),
                         ),

                         TabBar(
                           indicatorColor: Theme.of(context).primaryColor,
                           labelColor: Theme.of(context).primaryColor,
                           unselectedLabelColor: Colors.black54,
                           tabs: [
                             Tab(text: 'PUBLISHED',),
                             Tab(text: 'UN PUBLISHED',),
                           ],
                         ),
                         Expanded(
                           child: Container(
                             child: TabBarView(
                               children: [
                                 PublishedProducts(),
                                 UnPublishedProducts(),
                               ],
                             ),
                           ),
                         ),


                       ],
                     ),
                   ),
                 ),
                 FlatButton.icon(
                     onPressed: (){
                       Navigator.pushNamed(context, AddNewProduct.id);
                     },
                     color: Theme.of(context).primaryColor,
                     icon: Icon(Icons.add,color: Colors.white,),
                     label: Text('Add New', style: TextStyle(color: Colors.white),),
                 ),
               ],
             ),
           ),
         )
        ],
      ),
    );
  }
}
