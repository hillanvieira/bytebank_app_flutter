import 'package:bytebank_app/components/localization/i18n_cubit.dart';
import 'package:bytebank_app/components/localization/i18n_messages.dart';
import 'package:bytebank_app/components/localization/locale.dart';
import 'package:bytebank_app/components/response_dialog.dart';
import 'package:bytebank_app/components/transaction_auth_dialog.dart';
import 'package:bytebank_app/main.dart';
import 'package:bytebank_app/models/contact.dart';
import 'package:bytebank_app/models/name.dart';
import 'package:bytebank_app/models/transaction.dart';
import 'package:bytebank_app/screens/contacts_list.dart';
import 'package:bytebank_app/screens/dashboard/dashboard_i18n.dart';
import 'package:bytebank_app/screens/dashboard/dashboard_view.dart';
import 'package:bytebank_app/screens/transaction_form.dart';
import 'package:bytebank_app/widgets/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../matchers/matchers.dart';
import '../mocks/mocks.dart';
import 'actions.dart';

void main() {
  Widget dashboardView = MultiBlocProvider(
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
        BlocProvider<TransactionFormCubit>(
          create: (BuildContext contextTF) => TransactionFormCubit(),
        ),
      ],
      child: DashboardView(DashboardViewLazyI18N(I18NMessages({
        "transfer": "Transfer",
        "transaction_feed": "Transaction Feed",
        "change_name": "Change Name"
      }))));

  testWidgets('Should transfer to a contact', (tester) async {
    final mockContactDao = MockContactDao();
    final mockTransactionWebClient = MockTransactionWebClient();
    await tester.pumpWidget(AppDependencies(
      contactDao: mockContactDao,
      transactionWebClient: mockTransactionWebClient,
      child: MaterialApp(
        home: dashboardView,
      ),
    ));

    final dashboard = find.byType(DashboardView);
    expect(dashboard, findsOneWidget);

    final alex = Contact(0, 'Alex', 1000);
    when(mockContactDao.findAll()).thenAnswer((invocation) async => [alex]);

    await clickOnTheTransferFeatureItem(tester);
    await tester.pumpAndSettle();

    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget);

    verify(mockContactDao.findAll()).called(1);

    final contactItem = find.byWidgetPredicate((widget) {
      if (widget is ContactItem) {
        return widget.contact.name == 'Alex' &&
            widget.contact.accountNumber == 1000;
      }
      return false;
    });
    expect(contactItem, findsOneWidget);

    await tester.tap(contactItem);
    await tester.pumpAndSettle();

    final transactionForm = find.byType(TransactionForm);
    expect(transactionForm, findsOneWidget);

    final contactName = find.text('Alex');
    expect(contactName, findsOneWidget);
    final contactAccountNumber = find.text('1000');
    expect(contactAccountNumber, findsOneWidget);

    final textFieldValue = find.byWidgetPredicate((widget){
      return textFieldByLabelTextMatcher(widget, 'Value');
    });
    expect(textFieldValue, findsOneWidget);
    await tester.enterText(textFieldValue, '200');

    final transferButton = find.widgetWithText(ElevatedButton, 'Transfer');
    expect(transferButton, findsOneWidget);
    await tester.tap(transferButton);
    await tester.pumpAndSettle();

    final transactionAuthDialog = find.byType(TransactionAuthDialog);
    expect(transactionAuthDialog, findsOneWidget);

    final textFieldPassword = find.byKey(transactionAuthDialogTextFieldPasswordKey);
    expect(textFieldPassword, findsOneWidget);
    await tester.enterText(textFieldPassword, '1000');

    final cancelButton = find.widgetWithText(TextButton, 'Cancel');
    expect(cancelButton, findsOneWidget);
    final confirmButton = find.widgetWithText(TextButton, 'Confirm');
    expect(confirmButton, findsOneWidget);

    when(mockTransactionWebClient.saveHttp(any, '1000'))
        .thenAnswer((_) async => Transaction(null,200,alex));

    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    final successDialog = find.byType(SuccessDialog);
    expect(successDialog, findsOneWidget);


    final okButton = find.widgetWithText(TextButton, 'Ok');
    expect(okButton, findsOneWidget);
    await tester.tap(okButton);
    await tester.pumpAndSettle();

    final contactsListBack = find.byType(ContactsList);
    expect(contactsListBack, findsOneWidget);
  });
}
