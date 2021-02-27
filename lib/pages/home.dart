import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:online_store/pages/browse.dart';
import 'package:online_store/pages/cart.dart';
import 'package:online_store/pages/profile.dart';
import 'package:online_store/pages/search.dart';

final CollectionReference _usersRef =
    FirebaseFirestore.instance.collection('users');

final GoogleSignIn _googleSignIn = GoogleSignIn();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuthenticated = false;
  PageController pageController;
  int pageIndex = 0;
  final _formKey = GlobalKey<FormState>();
  String username;
  String password;

  @override
  void initState() {
    super.initState();

    pageController = PageController();

    //Detects when user signed in
    _googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignInWithGoogle(account);
    }, onError: (err) {
      print('Error signing in: $err');
    });

    //Reauthenticate user when app is reopened
    _googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignInWithGoogle(account);
    }).catchError((err) {
      print('Error signing in: $err');
    });
  }

  handleSignInWithGoogle(GoogleSignInAccount account) {
    if (account != null) {
      createGoogleUserInFirestore();
      setState(() {
        isAuthenticated = true;
      });
    } else {
      setState(() {
        isAuthenticated = false;
      });
    }
  }

  createGoogleUserInFirestore() async {
    final GoogleSignInAccount user = _googleSignIn.currentUser;
    final DocumentSnapshot doc = await _usersRef.doc(user.id).get();

    createUserInFirestore(doc);
  }

  loginWithGoogle() {
    _googleSignIn.signIn();
  }

  logout() {
    _googleSignIn.signOut();
  }

  submitSignInForm() {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      username.trim();
      password.trim();
      signIn(username, password);
    }
  }

  signIn(String username, String password) async {
    final QuerySnapshot queryResult = await _usersRef
        .where("email", isEqualTo: username)
        .where("password", isEqualTo: password)
        .get();
    if (queryResult.size == 1) {
      setState(() {
        isAuthenticated = true;
      });
    }
  }

  createUserInFirestore(DocumentSnapshot doc) {
    if (!doc.exists) {
    } else {}
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTapNavigationItem(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
  }

  Widget buildAuthScreen() {
    return RaisedButton(onPressed: () => logout(), child: Text('Logout'));
  }

  // Scaffold buildAuthScreen() {
  //   return Scaffold(
  //     body: PageView(
  //       children: [Browse(), Search(), Cart(), Profile()],
  //       controller: pageController,
  //       onPageChanged: onPageChanged,
  //       physics: NeverScrollableScrollPhysics(),
  //     ),
  //     bottomNavigationBar: CupertinoTabBar(
  //       currentIndex: pageIndex,
  //       onTap: onTapNavigationItem,
  //       activeColor: Theme.of(context).primaryColor,
  //       items: [
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.home),
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.search),
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.shopping_cart),
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.account_circle),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Online Store',
              style: TextStyle(
                  fontSize: 60.0, color: Colors.white, fontFamily: "Lobster"),
            ),
            SizedBox(height: 50.0),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 3),
                        child: TextFormField(
                          onSaved: (value) => username = value,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter some text";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Email',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 3),
                        child: TextFormField(
                          onSaved: (value) => password = value,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter some text";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Password',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    height: 55.0,
                    width: 350.0,
                    child: RaisedButton(
                      onPressed: submitSignInForm,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Theme.of(context).primaryColorDark,
                              Theme.of(context).accentColor,
                            ],
                          ),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Sign In",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 35.0,
                              fontFamily: "Lobster",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50.0),
            Container(
              margin: EdgeInsets.all(10),
              height: 45.0,
              width: 260.0,
              child: GestureDetector(
                onTap: () => loginWithGoogle(),
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    image: DecorationImage(
                        image: AssetImage('assets/images/google_signin.png'),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              height: 45.0,
              width: 260.0,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    image: DecorationImage(
                        image: AssetImage('assets/images/continue_with_fb.png'),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50.0),
            FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              color: Colors.transparent,
              textColor: Colors.white,
              child: Text(
                'Register',
                style: TextStyle(fontSize: 30, fontFamily: "Lobster"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuthenticated ? buildAuthScreen() : buildUnAuthScreen();
  }
}
