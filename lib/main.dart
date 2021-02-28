import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_store/pages/home.dart';
import 'package:online_store/widgets/progress.dart';

import 'pages/register.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error connecting to the server');
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Online Store',
            theme: ThemeData(
                primarySwatch: Colors.blue, accentColor: Colors.purple),
            initialRoute: '/',
            routes: {
              '/': (context) => Home(),
              '/register': (context) => Register(),
            },
          );
        }

        return circularProgress();
      },
    );
  }
}
