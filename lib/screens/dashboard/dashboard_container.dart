import 'package:bytebank_app/components/container.dart';
import 'package:bytebank_app/components/localization/i18n_container.dart';
import 'package:bytebank_app/models/name.dart';
import 'package:bytebank_app/screens/dashboard/dashboard_i18n.dart';
import 'package:bytebank_app/screens/dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardContainer extends BlocContainer {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NameCubit(name:'Guess'),
      child: I18NLoadingContainer(
        viewKey : "dashboard",
        creator: (messages) => DashboardView(DashboardViewLazyI18N(messages)),
      ),
    );
  }
}