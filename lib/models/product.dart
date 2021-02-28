import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String title;
  String titleLowerCase;
  String description;
  double price;
  int availableQuantity;

  Product(
      {this.id,
      this.title,
      this.titleLowerCase,
      this.description,
      this.price,
      this.availableQuantity});

  factory Product.fromDocument(DocumentSnapshot doc) {
    Product product = Product(
      title: doc['title'],
      titleLowerCase: doc['titleLowerCase'],
      description: doc['description'],
      price: doc['price'],
      availableQuantity: doc['availableQuantity']
    );
    
    product.id = doc.id;

    return product;
  }
}
