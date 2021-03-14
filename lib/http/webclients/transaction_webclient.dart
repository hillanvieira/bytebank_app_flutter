import 'dart:convert';
import 'package:http/http.dart';
import 'package:bytebank_app/models/transaction.dart';
import '../webclient.dart';

class TransactionWebClient {
  Future<Transaction> saveHttp(Transaction transaction, String password) async {
    final String transactionJson = jsonEncode(transaction.toJson());
    jsonEncode(transactionJson);

    final Response response = await client.post(
      Uri.parse(url),
      headers: {'Content-type': 'application/json', 'password': password},
      body: transactionJson,
    );

    return Transaction.fromJson(jsonDecode(response.body));
  }

  Future<List<Transaction>> findAllHttp() async {
    try {
      final Response response =
          await client.get(Uri.parse(url)).timeout(Duration(seconds: 5));

      final List<dynamic> decodedJson = jsonDecode(response.body);
      return decodedJson
          .map((dynamic json) => Transaction.fromJson(json))
          .toList();
    } catch (e) {
      print('Something happened while connecting the server');
      print('Printing out the message: $e');
      return null;
    }
  }

}
