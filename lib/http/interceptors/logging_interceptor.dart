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