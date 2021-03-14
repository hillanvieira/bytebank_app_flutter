import 'dart:convert';
import 'package:http/http.dart';
import 'package:bytebank_app/models/transaction.dart';
import '../webclient.dart';

class TransactionWebClient {
  Future<Transaction> saveHttp(
    Transaction transaction,
    String password,
  ) async {
    final String transactionJson = jsonEncode(transaction.toJson());
    jsonEncode(transactionJson);

    final Response response = await client.post(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'password': password,
      },
      body: transactionJson,
    );

    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
        return Transaction.fromJson(jsonDecode(response.body));

      case 401:
        throw HttpException(response.body);

      case 400:
        throw HttpException('there was an error submitting transaction');

      default:
        throw HttpException(
            'there was an unknown error submitting transaction');
    }
  }

  Future<List<Transaction>> findAllHttp() async {
    try {
      final Response response = await client.get(Uri.parse(url));

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

class HttpException implements Exception {
  final String message;

  final Duration duration;

  HttpException(this.message, [this.duration]);

  String toString() {
    String result = "TimeoutException";
    if (duration != null) result = "TimeoutException after $duration";
    if (message != null) result = "$result: $message";
    return result;
  }
}
