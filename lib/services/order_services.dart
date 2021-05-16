import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vendorapp_mulitvendorapp/widgets/delivery_boys_list.dart';
class OrderServices {
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  Future<void> updateOrderStatus(documentId, status) {
    var result = orders.doc(documentId).update({'orderStatus': status});

    return result;
  }

  Color statusColor(document) {
    if (document.data()['orderStatus'] == 'Rejected') {
      return Colors.red;
    }
    if (document.data()['orderStatus'] == 'Accepted') {
      return Colors.blueGrey[400];
    }
    if (document.data()['orderStatus'] == 'Picked Up') {
      return Colors.pink[900];
    }
    if (document.data()['orderStatus'] == 'On the way') {
      return Colors.deepPurpleAccent;
    }
    if (document.data()['orderStatus'] == 'Delivered') {
      return Colors.green;
    }

    return Colors.orange;
  }

  Widget statusContainer(document, context) {
    if(document.data()['deliveryBoy']['name'].length>1){
      return document.data()['deliveryBoy']['image']==null ? Container() :  ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Image.network(document.data()['deliveryBoy']['image']),
        ),
        title: new Text(document.data()['deliveryBoy']['name']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                GeoPoint location = document.data()['deliveryBoy']['location'];
                launchMap(location,document.data()['deliveryBoy']['name']);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(4)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 2, bottom: 2),
                  child: Icon(
                    Icons.map,color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10,),
            InkWell(
              onTap: () {
                launchCall('tel:${document.data()['deliveryBoy']['phone']}');
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(4)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 2, bottom: 2),
                  child: Icon(
                    Icons.phone_in_talk,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (document.data()['orderStatus'] == 'Accepted') {
      return Container(
        color: Colors.grey[300],
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 8, 40, 8),
          child: TextButton(
            style: ButtonStyle(
                backgroundColor: ButtonStyleButton.allOrNull<Color>(Colors.orangeAccent) //:-(
            ),
            child: Text(
              'Select Delivery Boy',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              print('Assign delivery boy');
              //Delivery boys list
              showDialog(context: context, builder: (BuildContext context) {
                return DeliveryBoysList(document);
              });
            },
          ),
        ),
      );
    }
    return Container(
      color: Colors.grey[300],
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                color: Colors.blueGrey,
                child: Text(
                  'Accept',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  showMyDialog(
                      'Accept Order', 'Accepted', document.id, context);
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AbsorbPointer(
                absorbing:
                document.data()['orderStatus'] == 'Rejected' ? true : false,
                child: FlatButton(
                  color: document.data()['orderStatus'] == 'Rejected'
                      ? Colors.grey
                      : Colors.red,
                  child: Text(
                    'Reject',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    showMyDialog(
                        'Reject Order', 'Rejected', document.id, context);
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Icon statusIcon(document) {

    if (document.data()['orderStatus'] == 'Accepted') {
      return Icon(Icons.assignment_turned_in_outlined,color: statusColor(document),);
    }
    if (document.data()['orderStatus'] == 'Picked Up') {
      return Icon(Icons.cases,color: statusColor(document),);

    }
    if (document.data()['orderStatus'] == 'On the way') {
      return Icon(Icons.delivery_dining,color: statusColor(document),);

    }
    if (document.data()['orderStatus'] == 'Delivered') {
      return Icon(Icons.shopping_bag_outlined,color: statusColor(document),);

    }

    return Icon(Icons.assignment_turned_in_outlined,color: statusColor(document),);
  }





  showMyDialog(title, status, documentId, context) {
    OrderServices _orderServices = OrderServices();
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text('Are you sure ? '),
            actions: [
              TextButton(
                child: Text(
                  'OK',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  EasyLoading.show(status: 'Updating status');
                  status == 'Accepted'
                      ? _orderServices
                      .updateOrderStatus(documentId, status)
                      .then((value) {
                    EasyLoading.showSuccess('Updated successfully');
                  })
                      : _orderServices
                      .updateOrderStatus(documentId, status)
                      .then((value) {
                    EasyLoading.showSuccess('Updated successfully');
                  });
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void launchCall(number) async =>
      await canLaunch(number) ? await launch(number) : throw 'Could not launch $number';

  void launchMap(GeoPoint location,name)async {
    print(location.latitude);
    final availableMaps = await MapLauncher.installedMaps;

    await availableMaps.first.showMarker(
      coords: Coords(location.latitude, location.longitude),
      title: name,
    );
  }
}


