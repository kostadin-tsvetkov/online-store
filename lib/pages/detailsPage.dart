import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_store/models/product.dart';
import 'package:online_store/widgets/header.dart';

final CollectionReference _ordersReference =
    FirebaseFirestore.instance.collection('orders');

final CollectionReference _orderDetailsReference =
    FirebaseFirestore.instance.collection('orderDetails');

class DetailsPage extends StatelessWidget {
  final Product product;
  final String userId;

  const DetailsPage({Key key, this.product, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, isAppTitle: true),
        body: Container(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10.0),
                child: Image.network(
                  product.photoUrl,
                  width: 350.0,
                  height: 330.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0.0),
                child: Text(
                  product.title,
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                child: Text(
                  product.description,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "\$ " + product.price.toString(),
                  style: TextStyle(color: Colors.black, fontSize: 40),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  addToCart();
                },
                child: Text(
                  'Add to cart',
                  style: TextStyle(fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    textStyle:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ));
  }

  addToCart() async {
    final QuerySnapshot snapshot = await _ordersReference
        .where("user", isEqualTo: userId)
        .where("isCheckedOut", isEqualTo: false)
        .get();

    if (snapshot.docs.length == 0) {
      _ordersReference.add({
        'userId': userId,
        'isCheckedOut': false,
      }).then((value) => addProduct(value.id));
    }
    addProduct(snapshot.docs[0].id);
  }

  addProduct(String orderId) {
    _orderDetailsReference
        .add({"order": orderId, "product": product.id, "quantity": 1});
  }
}
