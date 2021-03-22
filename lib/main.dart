import 'package:bytebank_app/components/localization.dart';
import 'package:bytebank_app/components/theme.dart';
import 'package:bytebank_app/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(BytebankApp());
  //print(Uuid().v4());
  //saveHttp(Transaction(235.98, Contact(0, 'Arnaldo', 2300)))
  //    .then((transaction) => print('test post http $transaction'));
}

class LogObserver extends BlocObserver{
  @override
  void onChange(BlocBase bloc, Change change) {
print('${bloc.runtimeType} > $change');
    super.onChange(bloc, change);
  }
}

class BytebankApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    Bloc.observer = LogObserver();
    return MaterialApp(
      theme: bytebankTheme,
      home: LocalizationContainer(
        child: DashboardContainer(),
      ),
    );
  }
}
