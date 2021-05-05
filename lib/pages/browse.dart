import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_store/models/category.dart';
import 'package:online_store/models/product.dart';
import 'package:online_store/widgets/header.dart';
import 'package:online_store/widgets/productCard.dart';
import 'package:online_store/widgets/progress.dart';

final CollectionReference _productsRef =
    FirebaseFirestore.instance.collection('products');

final CollectionReference _categoriesRef =
    FirebaseFirestore.instance.collection('categories');

List<Tab> _tabs = List<Tab>();

class Browse extends StatefulWidget {
  Browse({Key key}) : super(key: key);

  @override
  _BrowseState createState() => _BrowseState();
}

class _BrowseState extends State<Browse> with SingleTickerProviderStateMixin {
  Future<QuerySnapshot> productsFuture;
  Future<QuerySnapshot> categoriesFuture;
  List<Category> categories = [];
  int tabIndex = -1;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  void _setActiveTabIndex() {
    setState(() {
      tabIndex = _tabController.index;
    });
  }

  initTabController() {
    _tabController = new TabController(vsync: this, length: categories.length);
    _tabController.addListener(_setActiveTabIndex);
  }

  //method for fetching the categories
  getCategories() async {
    final QuerySnapshot snapshot = await _categoriesRef.get();
    final List<Category> categoriesTmp = [];
    snapshot.docs.forEach((element) {
      categoriesTmp.add(Category.fromDocument(element));
    });
    setState(() {
      categories.addAll(categoriesTmp);
      initTabController();
    });
  }

  buildCategories() {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
            bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          isScrollable: true,
          tabs: getTabs(),
        )),
      ),
      body: buildProductListing(),
    );
  }

  List<Tab> getTabs() {
    _tabs.clear();
    for (int i = 0; i < categories.length; i++) {
      _tabs.add(getTab(i));
    }
    return _tabs;
  }

  Tab getTab(int index) {
    return Tab(
      child: Text(categories[index].name),
    );
  }

  // Method for fetching product with where clause
  getProductsWithAvailableQuantity() {
    final Future<QuerySnapshot> snapshot = _productsRef
        .where("availableQuantity", isGreaterThan: 0)
        .where("category", isEqualTo: categories[tabIndex].id)
        .get();
    setState(() {
      productsFuture = snapshot;
    });
  }

  Widget buildProductListing() {
    if (tabIndex > -1) {
      getProductsWithAvailableQuantity();
    }

    return FutureBuilder(
      future: productsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<Product> productList = [];

        snapshot.data.docs.forEach((doc) {
          Product product = Product.fromDocument(doc);
          productList.add(product);
        });

        if (productList.length == 0) {
          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 100),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "No products in this category",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }

        return Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.builder(
                  itemCount: productList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 20.0,
                  ),
                  itemBuilder: (context, index) =>
                      ProductCard(product: productList[index])),
            )),
          ],
        );
      },
    );
  }

  //Method for fetching one product by ID
  // getProductById() async {
  //   final String productId = 't2AntbOTSmmj87MxZobP';
  //   final DocumentSnapshot doc = await _productsRef.doc(productId).get();

  //   print(doc.data());
  // }

  // @override
  // Scaffold build(BuildContext context) {
  //   return Scaffold(
  //     appBar: header(context, isAppTitle: true),
  //     body: Text('Browse'),
  //   );
  // }

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      // body: productsFuture == null ? null : buildProductListing(),
      body: categories.isEmpty ? null : buildCategories(),
    );
  }
}
