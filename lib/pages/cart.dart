import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final CollectionReference _ordersReference =
    FirebaseFirestore.instance.collection('orders');

final CollectionReference _orderDetailsReference =
    FirebaseFirestore.instance.collection('orderDetails');

class Cart extends StatefulWidget {
  final String userId;

  Cart({Key key, this.userId}) : super(key: key);

  @override
  _CartState createState() => _CartState(userId: userId);
}

class _CartState extends State<Cart> {
  String userId;
  QuerySnapshot orderSnapshot;
  QuerySnapshot orderDetailsSnapshot;

  _CartState({this.userId});

  @override
  void initState() {
    super.initState();
    getOrder();
  }

  getOrder() async {
    QuerySnapshot snapshot = await _ordersReference
        .where("userId", isEqualTo: userId)
        .where("isCheckedOut", isEqualTo: false)
        .get();

    if (snapshot.docs.length != 0) {
      getOrderDetails(snapshot);
    }
  }

  getOrderDetails(QuerySnapshot orderSnapshot) async {
    QuerySnapshot snapshot = await _orderDetailsReference
        .where("order", isEqualTo: orderSnapshot.docs[0].id)
        .get();

    setState(() {
      orderSnapshot = orderSnapshot;
      orderDetailsSnapshot = snapshot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('Cart');
  }
}
