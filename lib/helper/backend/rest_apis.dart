import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'database.dart';

Future<Map> GET(String url) async {
  final uri = Uri.parse(endpoint + url);
  Map result = {"result": "", "status": ""};

  try {
    final res = await http.get(uri);
    var decodedResult = jsonDecode(res.body);

    result["result"] = decodedResult;
    result["status"] = SUCCESS_CODE;
  } on SocketException {
    print("This is socket exception");
    result["result"] = socketErrorMessage;
    result["status"] = SERVER_ERROR_CODE;
  } on Exception catch (e) {
    result["result"] = miscellaneousErrorMessage;
    result["status"] = SERVER_ERROR_CODE;
  }
  return result;
}

Future<Map> POST(String url, Map? body, {String? message}) async {
  Map result = {"result": "", "status": 0};

  try {
    final client = Dio();

    final res = await client.post(endpoint + url,
        data: jsonEncode(body),
        options:
            Options(headers: {Headers.acceptHeader: Headers.jsonContentType}));

    var decodedResult = Map.castFrom(res.data);

    result["result"] = decodedResult;
    result["status"] = SUCCESS_CODE;
  } on SocketException {
    print("This is socket exception");
    result["result"] = socketErrorMessage;
    result["status"] = SERVER_ERROR_CODE;
  } on Exception catch (e) {
    result["result"] = miscellaneousErrorMessage;
    result["status"] = SERVER_ERROR_CODE;
  }
  return result;
}

Future<Map> POST_ALT(String url, Map? body) async {
  Map result = {"result": "", "status": 0};

  try {
    final res = await http.post(Uri.parse(endpoint + url),
        body: jsonEncode(body),
        headers: {Headers.acceptHeader: Headers.jsonContentType});

    var decodedResult = jsonDecode(res.body);

    result["result"] = decodedResult;
    result["status"] = SUCCESS_CODE;
  } on SocketException {
    print("This is socket exception");
    result["result"] = socketErrorMessage;
    result["status"] = SERVER_ERROR_CODE;
  } on Exception catch (e) {
    result["result"] = miscellaneousErrorMessage;
    result["status"] = SERVER_ERROR_CODE;
  }
  return result;
}

Future<Map> DELETE(String url) async {
  Map result = {"result": "", "status": 0};

  final uri = Uri.parse(endpoint + url);
  final request = http.Request("DELETE", uri);

  request.headers.addAll(<String, String>{
    HttpHeaders.acceptHeader: Headers.jsonContentType,
  });

  try {
    final response = await request.send();
    final res = await response.stream.bytesToString();

    if (response.statusCode != SUCCESS_CODE) {
      result["result"] = socketErrorMessage;
      result["status"] = SERVER_ERROR_CODE;
    } else {
      Map decodedResult = jsonDecode(res);
      result["result"] = decodedResult;
      result["status"] = SERVER_ERROR_CODE;
    }
  } on Exception catch (e) {
    result["result"] = socketErrorMessage;
    result["status"] = SERVER_ERROR_CODE;
  }

  return result;
}

Future<Map> PATCH(String url, Map? body) async {
  Map result = {"result": "", "status": 0};
  final uri = Uri.parse(endpoint + url);

  try {
    final res = await http.patch(uri, body: jsonEncode(body), headers: {
      HttpHeaders.acceptHeader: Headers.jsonContentType,
    });

    var decodedResult = jsonDecode(res.body);
    result["result"] = decodedResult;
    result["status"] = SUCCESS_CODE;
  } on Exception catch (e) {
    result["result"] = socketErrorMessage;
    result["status"] = SERVER_ERROR_CODE;
  }

  return result;
}
