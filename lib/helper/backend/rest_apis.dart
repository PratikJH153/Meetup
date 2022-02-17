import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'database.dart';

final client = Dio();

Function _post = client.post;
Function _patch = client.patch;
Function _delete = client.delete;
Function _get = client.get;

Future<Map> GET(String url) async {
  return await REQUEST(_get, url);
}

Future<Map> POST(String url, Map? body, {String? message}) async {
  return await REQUEST(_post, url, body: body);
}

Future<Map> DELETE(String url, {Map? body}) async {
  return await REQUEST(_delete, url, body: body);
}

Future<Map> PATCH(String url, Map? body) async {
  return await REQUEST(_patch, url, body: body);
}

Future<Map> REQUEST(Function function, String url, {Map? body}) async {
  Map result = {"local_result": "", "local_status": 0};

  try {
    var response;

    if (body == null) {
      response = await function(endpoint + url);
    } else {
      response = await function(endpoint + url,
          data: body == null ? null : jsonEncode(body),
          options: Options(headers: {Headers.acceptHeader: Headers.jsonContentType}));
    }
    var decodedResult = Map.castFrom(response.data);

    result["local_result"] = decodedResult;
    result["local_status"] = SUCCESS_CODE;
  } on SocketException {
    print("This is socket exception");
    result["local_result"] = socketErrorMessage;
    result["local_status"] = SERVER_ERROR_CODE;
  } on Exception catch (e) {
    result["local_result"] = miscellaneousErrorMessage;
    result["local_status"] = SERVER_ERROR_CODE;
  }
  return result;
}