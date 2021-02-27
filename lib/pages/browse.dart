import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_store/widgets/header.dart';
import 'package:online_store/widgets/progress.dart';

final CollectionReference _productsRef =
    FirebaseFirestore.instance.collection('products');

class Browse extends StatefulWidget {
  Browse({Key key}) : super(key: key);

  @override
  _BrowseState createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  @override
  void initState() {
    super.initState();
  }

  createProduct() async  {
     
  }

  //Method for fetching product with where clause
  // getProductsWithAvailableQuantity() async {
  //   final QuerySnapshot snapshot =
  //       await _productsRef.where("available_quantity", isGreaterThan: 0).get();
  //   snapshot.docs.forEach((element) {
  //     print(element.data());
  //   });
  // }

  //Method for fetching one product by ID
  // getProductById() async {
  //   final String productId = 't2AntbOTSmmj87MxZobP';
  //   final DocumentSnapshot doc = await _productsRef.doc(productId).get();

  //   print(doc.data());
  // }

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: StreamBuilder(
        stream: _productsRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          return Container(
            child: ListView(
              children: snapshot.data.docs
              .map<Widget>((product) => Text(product['name']))
              .toList(),
            ),
          );
        },
      ),
    );
  }
}
