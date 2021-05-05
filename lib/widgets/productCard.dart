import 'package:flutter/material.dart';
import 'package:online_store/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Function press;

  const ProductCard({
    Key key,
    this.product,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16.0)),
          child: Image.network(
            product.photoUrl,
            width: 180.0,
            height: 160.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: Text(
            product.title,
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
        ),
        Text(
          "\$ " + product.price.toString(),
          style: TextStyle(color: Colors.black),
        )
      ],
    );
  }
}
