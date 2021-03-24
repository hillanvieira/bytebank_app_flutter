import 'package:bytebank_app/models/name.dart';
import 'package:bytebank_app/screens/contacts_list.dart';
import 'package:bytebank_app/screens/dashboard/dashboard_feature_item.dart';
import 'package:bytebank_app/screens/dashboard/dashboard_i18n.dart';
import 'package:bytebank_app/screens/name.dart';
import 'package:bytebank_app/screens/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardView extends StatelessWidget {
  final DashboardViewLazyI18N _i18n;

  DashboardView(this._i18n);

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
                  FeatureItem(
                    _i18n.transfer,
                    Icons.monetization_on,
                    onClick: () {

                      Navigator
                          .of(context)
                          .push(
                          MaterialPageRoute(
                              builder: (context) => ContactsListContainer()
                          )
                      );

                      // navigateTo(context, ContactsListContainer());
                    },
                  ),
                  FeatureItem(
                    _i18n.transaction_feed,
                    Icons.description,
                    onClick: () {
                      Navigator
                          .of(context)
                          .push(
                          MaterialPageRoute(
                              builder: (context) => TransactionsListContainer()
                          )
                      );
                    },
                  ),
                  FeatureItem(
                    _i18n.change_name,
                    Icons.person,
                    onClick: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              BlocProvider.value(
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