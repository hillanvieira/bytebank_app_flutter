import 'dart:convert';
import 'package:http/http.dart';
import 'package:bytebank_app/models/contact.dart';
import 'package:bytebank_app/models/transaction.dart';
import '../webclient.dart';

class TransactionWebClient {
  Future<Transaction> saveHttp(Transaction transaction) async {

    Map<String, dynamic> transactionMap = _toTransactionMap(transaction);

    final String transactionJson = jsonEncode(transactionMap);

    jsonEncode(transactionJson);

    final Response response = await client.post(
      Uri.parse(url),
      headers: {'Content-type': 'application/json', 'password': '1000'},
      body: transactionJson,
    );

    return _toTransaction(response);
  }

  Future<List<Transaction>> findAllHttp() async {
    try {
      final Response response =
          await client.get(Uri.parse(url)).timeout(Duration(seconds: 5));

      List<Transaction> transactions = _toTransactions(response);

      return transactions;
    } catch (e) {
      print('Something happened while connecting the server');
      print('Printing out the message: $e');
      return null;
    }
  }

  List<Transaction> _toTransactions(Response response) {
    final List<dynamic> decodedJson = jsonDecode(response.body);
    final List<Transaction> transactions = [];
    for (Map<String, dynamic> transactionJson in decodedJson) {
      final Map<String, dynamic> contactJson = transactionJson['contact'];
      final Transaction transaction = Transaction(
        transactionJson['value'],
        Contact(
          0,
          contactJson['name'],
          contactJson['accountNumber'],
        ),
      );

      transactions.add(transaction);
    }
    return transactions;
  }

  Transaction _toTransaction(Response response) {
    Map<String, dynamic> json = jsonDecode(response.body);
    final Map<String, dynamic> contactJson = json['contact'];
    return Transaction(
      json['value'],
      Contact(
        0,
        contactJson['name'],
        contactJson['accountNumber'],
      ),
    );
  }

  Map<String, dynamic> _toTransactionMap(Transaction transaction) {
    final Map<String, dynamic> transactionMap = {
      'value': transaction.value,
      'contact': {
        'name': transaction.contact.name,
        "accountNumber": transaction.contact.accountNumber
      }
    };
    return transactionMap;
  }
}
