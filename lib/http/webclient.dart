import 'dart:convert';
import 'package:bytebank_app/http/interceptors/logging_interceptor.dart';
import 'package:bytebank_app/models/contact.dart';
import 'package:bytebank_app/models/transaction.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';


final Client client = HttpClientWithInterceptor.build(
  interceptors: [LoggingInterceptor()],
);

const url = 'http://192.168.1.70:8080/transactions';

