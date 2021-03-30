import 'package:bytebank_app/components/localization/i18n_cubit.dart';
import 'package:bytebank_app/components/localization/i18n_messages.dart';
import 'package:bytebank_app/components/localization/locale.dart';
import 'package:bytebank_app/main.dart';
import 'package:bytebank_app/models/contact.dart';
import 'package:bytebank_app/models/name.dart';
import 'package:bytebank_app/screens/contact_form.dart';
import 'package:bytebank_app/screens/contacts_list.dart';
import 'package:bytebank_app/screens/dashboard/dashboard_container.dart';
import 'package:bytebank_app/screens/dashboard/dashboard_i18n.dart';
import 'package:bytebank_app/screens/dashboard/dashboard_view.dart';
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
      ],
      child: DashboardView(DashboardViewLazyI18N(I18NMessages({
        "transfer": "Transfer",
        "transaction_feed": "Transaction Feed",
        "change_name": "Change Name"
      }))));

  testWidgets('Should save a contact', (tester) async {
    final mockContactDao = MockContactDao();
    final mockTransactionWebClient = MockTransactionWebClient();
    await tester.pumpWidget(AppDependencies(
      contactDao: mockContactDao,
      transactionWebClient: mockTransactionWebClient,
      child: MaterialApp(
        home: dashboardView,
      ),
    ));

    final hillan = Contact(0, 'Hillan', 3069);
    when(mockContactDao.findAll()).thenAnswer((invocation) async => [hillan]);

    final dashboard = find.byType(DashboardView);
    expect(dashboard, findsOneWidget);

    await clickOnTheTransferFeatureItem(tester);
    await tester.pumpAndSettle();

    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget);

    verify(mockContactDao.findAll()).called(1);

    final fabNewContact = find.widgetWithIcon(FloatingActionButton, Icons.add);
    expect(fabNewContact, findsOneWidget);
    await tester.tap(fabNewContact);
    await tester.pumpAndSettle();

    final contactForm = find.byType(ContactForm);
    expect(contactForm, findsOneWidget);

    final nameTextField =
        find.byWidgetPredicate((widget) => textFieldByLabelTextMatcher(widget, 'Full name'));
    expect(nameTextField, findsOneWidget);
    await tester.enterText(nameTextField, 'Alex');

    final accountNumberTextField =
        find.byWidgetPredicate((widget) => textFieldByLabelTextMatcher(widget, 'Account number'));
    expect(accountNumberTextField, findsOneWidget);
    await tester.enterText(accountNumberTextField, '1000');

    final createButton = find.widgetWithText(ElevatedButton, 'Create');
    expect(createButton, findsOneWidget);
    await tester.tap(createButton);
    await tester.pumpAndSettle();

    verify(mockContactDao.save(Contact(0,'Alex', 1000)));

    final contactsListBack = find.byType(ContactsList);
    expect(contactsListBack, findsOneWidget);

    verify(mockContactDao.findAll());
  });
}
