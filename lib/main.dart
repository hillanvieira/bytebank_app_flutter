import 'package:bytebank_app/components/connection_error.dart';
import 'package:bytebank_app/http/webclient.dart';
import 'package:bytebank_app/models/contact.dart';
import 'package:bytebank_app/models/transaction.dart';
import 'package:bytebank_app/screens/dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BytebankApp());
  //saveHttp(Transaction(235.98, Contact(0, 'Arnaldo', 2300)))
  //    .then((transaction) => print('test post http $transaction'));
}

class BytebankApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFFF0019),
        accentColor: Color(0xFFFF0019),
        buttonColor: Color(0xFFFF0019),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Color(0xFFFF0019),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Color(0xFFFF0019),
          ),
        ),
      ),
      home: Dashboard(),
    );
  }
}