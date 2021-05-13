import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vendorapp_mulitvendorapp/services/firebase_services.dart';

class UnPublishedProducts extends StatelessWidget {
  const UnPublishedProducts({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services=FirebaseServices();

    return Container(
      child: StreamBuilder(
        stream: _services.products.where('published', isEqualTo: false).snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasError){
            return Text('Something went wrong');
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator() ,
            );
          }
          return SingleChildScrollView(
            child: DataTable(
              showBottomBorder: true,
              dataRowHeight: 60,
              headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
              columns: [
                DataColumn(label: Text('Product Name')),
                DataColumn(label: Text('Image')),
                DataColumn(label: Text('Actions')),
              ],
              rows:_productDetails(snapshot.data)
            ),
          );
        },
      ),
    );
  }
 List<DataRow> _productDetails(QuerySnapshot snapshot){
          List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document){
            if(document!=null){
              return DataRow(
                cells: [
                  DataCell(
                    Container(
                  child: Text(document.data()['productName']),
                 ),
                  ),
                  DataCell(
                      Container(
                        child: Image.network(document.data()['productImage']),
                      ),
                  ),
                  DataCell(
                    Container(
                      child: (document.data()['productImage']),
                    ),
                  ),
                  DataCell(
                    popButton();
                  ),
                ],
              );
            }
          }).toList();
          return newList;
  }
  Widget popUpButton(data){

  }
}
