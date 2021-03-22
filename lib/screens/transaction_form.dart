import 'dart:async';

import 'package:bytebank_app/components/container.dart';
import 'package:bytebank_app/components/loading_centered_message.dart';
import 'package:bytebank_app/components/response_dialog.dart';
import 'package:bytebank_app/components/transaction_auth_dialog.dart';
import 'package:bytebank_app/http/webclients/transaction_webclient.dart';
import 'package:bytebank_app/models/contact.dart';
import 'package:bytebank_app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class TransactionFormState {
  const TransactionFormState();
}

@immutable
class SendingState extends TransactionFormState {
  const SendingState();
}

@immutable
class ShowFormState extends TransactionFormState {
  const ShowFormState();
}

@immutable
class SentState extends TransactionFormState {
  const SentState();
}

@immutable
class FatalErrorFormState extends TransactionFormState {
  final String _message;

  const FatalErrorFormState(this._message);
}

class TransactionFormCubit extends Cubit<TransactionFormState> {
  TransactionFormCubit() : super(ShowFormState());

  final TransactionWebClient _webClient = new TransactionWebClient();

  Future _send(Transaction transactionCreated,
      String password,
      BuildContext context,) async {
    /* Future.delayed(Duration(microseconds: 1)).then((value){
      showDialog(
          context: context,
          builder: (contextDialog) {

            return LoadingDialog();
          });
    });*/

    emit(SendingState());

    final transaction = _webClient.saveHttp(transactionCreated, password);

    await transaction.catchError((e) {
      showDialog(
          context: context,
          builder: (contextDialog) {
            return FailureDialog('Timeout submitting the  transaction');
          });
    }, test: (e) => e is TimeoutException).catchError((e) {
      showDialog(
          context: context,
          builder: (contextDialog) {
            return FailureDialog(e.message);
          });
    }, test: (e) => e is HttpException).catchError((e) {
      showDialog(
          context: context,
          builder: (contextDialog) {
            return FailureDialog('${e.message} Contact support unknown error');
          });
    }, test: (e) => e is Exception).then((value) async {
      if (value != null) {

        emit(SentState());

        await showDialog(
            context: context,
            builder: (contextDialog) {
              return SuccessDialog('Successful transaction');
            });

        Navigator.pop(context);
      }
    });

    emit(SentState());

  }
}

class TransactionFormContainer extends BlocContainer {
  final Contact contact;

  TransactionFormContainer(this.contact);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TransactionFormCubit(),
      child: TransactionForm(contact),
    );
  }
}

class TransactionForm extends StatelessWidget {
  final Contact contact;

  TransactionForm(this.contact);

  final TextEditingController _valueController = TextEditingController();
  final String transactionId = Uuid().v4();

  @override
  Widget build(BuildContext context) {
    print("transaction form ID: $transactionId");
    TransactionFormCubit transactionFormCubit = BlocProvider.of<TransactionFormCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BlocBuilder<TransactionFormCubit, TransactionFormState>(
                  builder: (context, state) {
                    return  Visibility(
                      visible: (transactionFormCubit.state is SendingState),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LoadingCenteredMessage(
                          message: 'Sending...',
                        ),
                      ),
                    );
                  }
              ),
              Text(
                contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text('Transfer'),
                    onPressed: () {
                      final double value =
                      double.tryParse(_valueController.text);
                      final transactionCreated =
                      Transaction(transactionId, value, contact);
                      showDialog(
                          context: context,
                          builder: (BuildContext contextDialog) {
                            Widget dialog = TransactionAuthDialog(
                                  onConfirm: (String password) {
                                 BlocProvider.of<TransactionFormCubit>(context)._send(
                                        transactionCreated, password, context);
                                  },
                                );

                              return BlocProvider<TransactionFormCubit>.value(
                              value: transactionFormCubit, //
                              child: dialog,
                            );
                          }
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future runIt(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (contextDialog) {
          return SuccessDialog('Successful transaction');
        });
  }
}
