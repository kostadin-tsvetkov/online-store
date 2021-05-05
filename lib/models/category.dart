import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String id;
  String name;

  Category(
      {this.id,
      this.name});

  factory Category.fromDocument(DocumentSnapshot doc) {
    Category category = Category(
        name: doc['name']);

    category.id = doc.id;

    return category;
  }
}
