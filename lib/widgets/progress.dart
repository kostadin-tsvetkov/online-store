import 'package:flutter/material.dart';

Container circularProgress() {
  return Container(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.lime),
    ),
  );
}

Container linearProgress(context) {
  return Container(
    padding: EdgeInsets.only(bottom: 10.0),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
    ),
  );
}
