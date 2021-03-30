import 'package:bytebank_app/components/localization/locale.dart';
import 'package:bytebank_app/components/theme.dart';
import 'package:bytebank_app/database/dao/contact_dao.dart';
import 'package:bytebank_app/http/webclients/transaction_webclient.dart';
import 'package:bytebank_app/screens/dashboard/dashboard_container.dart';
import 'package:bytebank_app/widgets/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(BytebankApp(
    contactDao: ContactDao(),
    transactionWebClient: TransactionWebClient(),
  ));
  //print(Uuid().v4());
  //saveHttp(Transaction(235.98, Contact(0, 'Arnaldo', 2300)))
  //    .then((transaction) => print('test post http $transaction'));
}

class LogObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    print('${bloc.runtimeType} > $change');
    super.onChange(bloc, change);
  }
}

class BytebankApp extends StatelessWidget {
  final ContactDao contactDao;
  final TransactionWebClient transactionWebClient;

  const BytebankApp({
    @required this.contactDao,
    @required this.transactionWebClient,
  }) : assert(
          contactDao != null,
          transactionWebClient != null,
        );

  @override
  Widget build(BuildContext context) {
    // na prática evitar log do genero, pois pode vazar informações sensíveis para o log
    Bloc.observer = LogObserver();

    return AppDependencies(
      transactionWebClient: transactionWebClient,
      contactDao: contactDao,
      child: MaterialApp(
        theme: bytebankTheme,
        home: LocalizationContainer(
          child: DashboardContainer(),
        ),
      ),
    );
  }
}
