import 'dart:convert';

import 'package:bytebank_app/models/contact.dart';
import 'package:bytebank_app/models/transaction.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    print('Request');
    print('url: ${data.toHttpRequest().url}');
    print('headers: ${data.toHttpRequest().headers}');
    print('body: ${data.toHttpRequest().body}');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    print('Response');
    print('status code: ${data.toHttpResponse().statusCode}');
    print('headers: ${data.toHttpResponse().headers}');
    print('body: ${data.toHttpResponse().body}');
    return data;
  }
}

const url = 'http://192.168.1.70:8080/transactions';
final Client client = HttpClientWithInterceptor.build(
  interceptors: [LoggingInterceptor()],
);

Future<List<Transaction>> findAllHttp() async {
  try {
    final Response response =
        await client.get(Uri.parse(url)).timeout(Duration(seconds: 5));

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
  } catch (e) {
    print('Something happened while connecting the server');
    print('Printing out the message: $e');
    return null;
  }
}

Future<Transaction> saveHttp(Transaction transaction) async{

  final Map<String, dynamic> transactionMap = {
    'value' : transaction.value,
    'contact' : {
      'name' : transaction.contact.name,
      "accountNumber": transaction.contact.accountNumber
    }
  };

  final String transactionJson = jsonEncode(transactionMap);
  jsonEncode(transactionJson);
  final Response response = await client.post(
    Uri.parse(url),
    headers: {'Content-type' : 'application/json','password' : '1000'},
    body: transactionJson,
  );

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
