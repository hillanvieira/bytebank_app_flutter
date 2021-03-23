import 'dart:convert';


import 'package:bytebank_app/http/webclient.dart';
import 'package:http/http.dart';

const String MESSAGES_URI =
    "https://gist.githubusercontent.com/hillanvieira/b26794d0ba96a956daf6db69fdb0fda6/raw/335b87de3a2170f3fdcda63ffd6a19f33182fad0/";

class I18NWebClient {
  final String _viewKey;

  I18NWebClient(this._viewKey);

  Future<Map<String, dynamic>> findAll() async {
    final Response response = await client.get(Uri.parse('$MESSAGES_URI$_viewKey.json'));
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson;
  }
}
