import 'package:bytebank_app/components/localization/i18n_cubit.dart';
import 'package:bytebank_app/components/localization/i18n_messages.dart';
import 'package:bytebank_app/components/localization/locale.dart';
import 'package:bytebank_app/models/name.dart';
import 'package:bytebank_app/screens/dashboard/dashboard_i18n.dart';
import 'package:bytebank_app/screens/dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Should display the main image when the Dashboard is opended',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MultiBlocProvider(
          providers: [
            BlocProvider<CurrentLocaleCubit>(
              create: (BuildContext contextCL) => CurrentLocaleCubit(),
            ),
            BlocProvider<NameCubit>(
              create: (BuildContext contextNC) => NameCubit(name: 'Guess'),
            ),
            BlocProvider<I18NMessagesCubit>(
              create: (BuildContext contextI18N) => I18NMessagesCubit("dashboard"),
            ),
          ],
          child: DashboardView(DashboardViewLazyI18N(I18NMessages({
            "transfer": "Transfer",
            "transaction_feed": "Transaction Feed",
            "change_name": "Change Name"
          })))),
    ));
    final mainImage = find.byType(Image);
    expect(mainImage, findsOneWidget);
  });
}
