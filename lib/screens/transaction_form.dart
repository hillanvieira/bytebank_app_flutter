import 'dart:async';

import 'package:bytebank_app/components/response_dialog.dart';
import 'package:bytebank_app/components/transaction_auth_dialog.dart';
import 'package:bytebank_app/http/webclients/transaction_webclient.dart';
import 'package:bytebank_app/models/contact.dart';
import 'package:bytebank_app/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _webClient = new TransactionWebClient();

  @override
  Widget build(BuildContext context) {
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
              Text(
                widget.contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
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
                          Transaction(value, widget.contact);
                      showDialog(
                          context: context,
                          builder: (contextDialog) {
                            return TransactionAuthDialog(
                              onConfirm: (String password) async {
                                await _send(
                                    transactionCreated, password, context);
                              },
                            );
                          });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _send(Transaction transactionCreated, String password,
      BuildContext context) async {
    /* Future.delayed(Duration(microseconds: 1)).then((value){
      showDialog(
          context: context,
          builder: (contextDialog) {

            return LoadingDialog();
          });
    });*/
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
        await showDialog(
            context: context,
            builder: (contextDialog) {
              return SuccessDialog('Successful transaction');
            });
        Navigator.pop(context);
      }
    });
  }

  Future runIt(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (contextDialog) {
          return SuccessDialog('Successful transaction');
        });
  }
}
