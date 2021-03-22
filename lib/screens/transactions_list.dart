import 'package:bytebank_app/components/centered_message.dart';
import 'package:bytebank_app/components/connection_error.dart';
import 'package:bytebank_app/components/container.dart';
import 'package:bytebank_app/components/loading_centered_message.dart';
import 'package:bytebank_app/http/webclients/transaction_webclient.dart';
import 'package:bytebank_app/models/transaction.dart';
import 'package:flutter/material.dart';


class TransactionsListContainer extends BlocContainer{
  @override
  Widget build(BuildContext context) {
   return TransactionsList();
  }

}

class TransactionsList extends StatefulWidget {
  @override
  _TransactionsListState createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  List<Transaction> transactions = [];

  @override
  Widget build(BuildContext context) {
    final TransactionWebClient _webClient = new TransactionWebClient();

    //Function that update screen when Scroll at end of the list.
    _onEndScrollAtBorders({ScrollMetrics metrics, DragEndDetails dragDetails}) {
      if (dragDetails != null) {
        if (metrics.atEdge &&
            dragDetails.velocity.pixelsPerSecond.direction != 0) {
          setState(() {});
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: FutureBuilder<List<Transaction>>(
        initialData: [],
        future: _webClient.findAllHttp().then((transactionsJson) {
          return transactionsJson;
        }),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return LoadingCenteredMessage(
                message: 'Loading transaction list',
              );
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              final List<Transaction> transactions = snapshot.data;

              if (!snapshot.hasData) {
                return ConnectionError();
              }
              if (transactions.isEmpty) {
                return CenteredMessage(
                  'No transactions found',
                  icon: Icons.list_alt,
                  iconSize: 100.0,
                  fontSize: 32.0,
                );
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollEndNotification) {
                    _onEndScrollAtBorders(
                      metrics: scrollNotification.metrics,
                      dragDetails: scrollNotification.dragDetails,
                    );
                  }
                  return false;
                },
                child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.monetization_on),
                          title: Text(
                            transactions[index].value.toString(),
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            transactions[index]
                                .contact
                                .accountNumber
                                .toString(),
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      );
                    }),
              );

              break;
          }

          return CenteredMessage(
            'empty list',
            icon: Icons.error,
            iconSize: 100.0,
            fontSize: 36.0,
          );
        },
      ),
    );
  }
}
