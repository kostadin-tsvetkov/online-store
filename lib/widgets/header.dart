import 'package:flutter/material.dart';

AppBar header(context, { bool isAppTitle = false, String titleText }) {
  return AppBar(
    title: Text(
      isAppTitle ? 'Online Store' : titleText,
       style: TextStyle(
         color: Colors.white,
         fontFamily: 'Lobster',
         fontSize: 30.0
       ),
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).primaryColor,
  );
}
