import 'package:bytebank_app/components/container.dart';
import 'package:bytebank_app/components/localization.dart';
import 'package:bytebank_app/models/name.dart';
import 'package:bytebank_app/screens/contacts_list.dart';
import 'package:bytebank_app/screens/name.dart';
import 'package:bytebank_app/screens/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => NameCubit(name: 'Guess'), child: DashboardView());
  }
}

class DashboardView extends BlocContainer {
  @override
  Widget build(BuildContext context) {
    final DashboardViewI18N i18n = new DashboardViewI18N(context);
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NameCubit, String>(builder: (context, state) {
          return Text(
            'Welcome $state',
          );
        }),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("images/bytebank_logo.png"),
          ),
          SingleChildScrollView(
            child: Container(
              height: 116.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _FeatureItem(
                    i18n.transfer,
                    Icons.monetization_on,
                    onClick: () {
                      navigateTo(context, ContactsListContainer());
                    },
                  ),
                  _FeatureItem(
                    i18n.transaction_feed,
                    Icons.description,
                    onClick: () {
                      navigateTo(context, TransactionsListContainer());
                    },
                  ),
                  _FeatureItem(
                    i18n.change_name,
                    Icons.person,
                    onClick: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            //value: BlocProvider.of<NameCubit>(context),
                            value: context.read<NameCubit>(),
                            child: NameView(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


class DashboardViewI18N extends ViewI18N {
  DashboardViewI18N(BuildContext context) : super(context);

  String get transfer =>
      localize({"pt-br": "Transferir", "en": "Transfer"});

  // _ é para constante. defina se você vai usar também para não constante!
  String get transaction_feed =>
      localize({"pt-br": "Transações", "en": "Transaction Feed"});

  String get change_name =>
      localize({"pt-br": "Mudar nome", "en": 'Change name'});

}




class _FeatureItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Function onClick;

  _FeatureItem(
    this.name,
    this.icon, {
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => onClick(),
        child: Ink(
          padding: EdgeInsets.all(8.0),
          height: 100,
          width: 150,
          color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 24.0,
              ),
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

