import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:meetupapp/helper/ERROR_CODE_CUSTOM.dart';

const filename = "user_db_helper.dart";
const userFolder = "users";

const getUsersURL = "$userFolder/getUsers/";
const addUsersURL = "$userFolder/addUser/";
const endpoint = "http://192.168.0.212:8000/";

// ignore: non_constant_identifier_names
Future<Map> GET(String url) async {
  final uri = Uri.parse(endpoint + url);

  try {
    final res = await http.get(uri);

    return jsonDecode(res.body) as Map;
  } on SocketException {
    print("This is socket exception");
    return {
      "flutter-caught-error": "Socket Exception",
      "message": ErrorCodesCustom[100],
      "errCode": 100 // Server connection error
    };
  } on Exception catch (e) {
    print(e.toString());
    print("ERROR IN:: $filename" + "::line 21");
    return {
      "flutter-caught-error": e,
      "message": ErrorCodesCustom[999],
      "errCode": 999
    };
  }
}

// ignore: non_constant_identifier_names
Future<Map> POST(String url, Map? body, {String? message}) async {
  try {
    final result = await Dio().post(endpoint + url,
        data: jsonEncode(body),
        options:
            Options(headers: {Headers.acceptHeader: Headers.jsonContentType}));

    var dataResult = Map.castFrom(result.data);

    return dataResult;
  } on SocketException {
    return {
      "flutter-caught-error": "Socket Exception",
      "message": ErrorCodesCustom[100],
      "errCode": 100 // Server connection error
    };
  } on Exception catch (e) {
    return {
      "message": ErrorCodesCustom[999],
      "errCode": 999,
      "flutter-caught-error": e,
    };
  }
}

Future<Map> POST_ALT(String url, Map? body) async {
  try {
    final res = await http.post(Uri.parse(endpoint + url),
        body: jsonEncode(body),
        headers: {Headers.acceptHeader: Headers.jsonContentType});

    return jsonDecode(res.body);
  } on SocketException {
    print("This is socket exception");
    return {
      "flutter-caught-error": "Socket Exception",
      "message": ErrorCodesCustom[100],
      "errCode": 100 // Server connection error
    };
  } on Exception catch (e) {
    print(e.toString());
    print("ERROR IN:: $filename" + "::line 21");
    return {
      "flutter-caught-error": e,
      "message": ErrorCodesCustom[999],
      "errCode": 999
    };
  }
}

Future<Map> DELETE(String url) async {
  final uri = Uri.parse(endpoint + url);
  final request = http.Request("DELETE", uri);
  request.headers.addAll(<String, String>{
    HttpHeaders.acceptHeader: Headers.jsonContentType,
  });

  try {
    final response = await request.send();
    final result = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      return {"status": 0, "result": "error"};
    } else {
      return jsonDecode(result);
    }
  } on Exception catch (e) {
    return {"status": 0, "result": "error"};
  }
}

/// TODO: NOT WORKKING
Future<Map> PATCH(String url, Map? body) async {
  final uri = Uri.parse(endpoint + url);

  try {
    final res = await http.patch(uri, body: jsonEncode(body), headers: {
      HttpHeaders.acceptHeader: Headers.jsonContentType,
    });

    return jsonDecode(res.body);
  } on Exception catch (e) {
    return {"status": 0, "result": "error"};
  }
}
