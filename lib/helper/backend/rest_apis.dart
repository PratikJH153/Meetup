import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'database.dart';

Future<Map> GET(String url) async {
  final uri = Uri.parse(endpoint + url);
  Map result = {"local_result": "", "local_status": 0};

  try {
    final res = await http.get(uri);
    var decodedResult = jsonDecode(res.body);

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

Future<Map> POST(String url, Map? body, {String? message}) async {
  Map result = {"local_result": "", "local_status": 0};

  try {
    final client = Dio();

    final res = await client.post(endpoint + url,
        data: jsonEncode(body),
        options:
            Options(headers: {Headers.acceptHeader: Headers.jsonContentType}));

    var decodedResult = Map.castFrom(res.data);

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

Future<Map> POST_ALT(String url, Map? body) async {
  Map result = {"local_result": "", "local_status": 0};

  try {
    final res = await http.post(Uri.parse(endpoint + url),
        body: jsonEncode(body),
        headers: {Headers.acceptHeader: Headers.jsonContentType});

    var decodedResult = jsonDecode(res.body);

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

Future<Map> DELETE(String url) async {
  Map result = {"local_result": "", "local_status": 0};

  final uri = Uri.parse(endpoint + url);
  final request = http.Request("DELETE", uri);

  request.headers.addAll(<String, String>{
    HttpHeaders.acceptHeader: Headers.jsonContentType,
  });

  try {
    final response = await request.send();
    final res = await response.stream.bytesToString();

    if (response.statusCode != SUCCESS_CODE) {
      result["local_result"] = socketErrorMessage;
      result["local_status"] = SERVER_ERROR_CODE;
    } else {
      Map decodedResult = jsonDecode(res);
      result["local_result"] = decodedResult;
      result["local_status"] = SERVER_ERROR_CODE;
    }
  } on Exception catch (e) {
    result["local_result"] = socketErrorMessage;
    result["local_status"] = SERVER_ERROR_CODE;
  }

  return result;
}

Future<Map> PATCH(String url, Map? body) async {
  Map result = {"local_result": "", "local_status": 0};
  final uri = Uri.parse(endpoint + url);

  try {
    final res = await http.patch(uri, body: jsonEncode(body), headers: {
      HttpHeaders.acceptHeader: Headers.jsonContentType,
    });

    var decodedResult = jsonDecode(res.body);
    result["local_result"] = decodedResult;
    result["local_status"] = SUCCESS_CODE;
  } on Exception catch (e) {
    result["local_result"] = socketErrorMessage;
    result["local_status"] = SERVER_ERROR_CODE;
  }

  return result;
}
