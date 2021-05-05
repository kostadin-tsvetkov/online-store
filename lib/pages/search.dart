import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_store/models/product.dart';
import 'package:online_store/widgets/progress.dart';

final CollectionReference _productsRef =
    FirebaseFirestore.instance.collection('products');


class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchFieldController = TextEditingController();
  Future<QuerySnapshot> searchResultFuture;

  handleSearchSubmit(String searchParameter) {
    searchParameter.toLowerCase();

    final Future<QuerySnapshot> result = _productsRef
        .where("titleLowerCase", isEqualTo: searchParameter)
        .get();
    setState(() {
      searchResultFuture = result;
    });
  }

  clearSearchField() {
    searchFieldController.clear();
  }

  AppBar buildSearchField(BuildContext context) {
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: TextFormField(
        controller: searchFieldController,
        decoration: InputDecoration(
          hintText: 'Search for products',
          prefixIcon: Icon(
            Icons.search,
            size: 28.0,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: clearSearchField,
          ),
        ),
        onFieldSubmitted: handleSearchSubmit,
      ),
    );
  }

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchField(context),
      body: searchResultFuture == null ? null : buildSearchResult(),
    );
  }

  Widget buildSearchResult() {
    return FutureBuilder(
      future: searchResultFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<ProductResult> searchResult = [];

        snapshot.data.docs.forEach((doc) {
          Product product = Product.fromDocument(doc);
          searchResult.add(ProductResult(product));
        });

        return ListView(
          children: searchResult,
        );
      },
    );
  }
}

class ProductResult extends StatelessWidget {
  final Product product;

  ProductResult(this.product);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => print('Tapped'),
            child: ListTile(
              leading: Image.network(product.photoUrl),
              title: Text(product.title, style: TextStyle(fontWeight: FontWeight.bold),),
              subtitle: Text(product.description),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
