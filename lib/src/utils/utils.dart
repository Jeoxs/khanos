import 'package:flutter/material.dart';
import 'package:khanos/src/preferences/user_preferences.dart';
import 'package:khanos/src/utils/theme_utils.dart';

final _prefs = new UserPreferences();

bool isNumeric(String s) {
  if (s.isEmpty) return false;

  final n = num.tryParse(s);

  return (n == null) ? false : true;
}

void mostrarAlerta(BuildContext context, String mensaje) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
          title: Text('Alert'),
          content: Text(mensaje),
          actions: <Widget>[
            FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop()),
          ]);
    },
  );
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Map<String, dynamic> processApiError(Map<String, dynamic> error) {
  int errorCode = error['code'];
  String errorMessage = error['message'];
  int id = 0;

  if (error['id'] != null) {
    id = error['id'];
  }

  Map<String, dynamic> result;

  switch (errorCode) {
    case 401: //UNAUTHORIZED
      result = {'code': errorCode, 'message': errorMessage, 'id': id};
      _prefs.authFlag = false;
      break;
    default:
      result = {'code': errorCode, 'message': errorMessage, 'id': id};
  }

  return result;
}

Widget errorPage(Map<String, dynamic> error) {
  return Column(
    children: [
      Expanded(
        flex: 7,
        child: Hero(
          tag: 'Clipboard',
          child: Image.asset('assets/images/khanos_transparent.png'),
        ),
      ),
      Expanded(
        flex: 4,
        child: Column(
          children: <Widget>[
            Text(
              'Error ${error['code']}',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: CustomColors.TextHeader),
            ),
            SizedBox(height: 15),
            Text(
              '${error['message']}',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: CustomColors.TextBody,
                  fontFamily: 'opensans'),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ],
  );
}
