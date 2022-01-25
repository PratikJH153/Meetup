import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

const filename = "user_db_helper.dart";
const userFolder = "users";

const getUsersURL = "$userFolder/getUsers/";
const addUsersURL = "$userFolder/addUser/";
const endpoint = "http://10.0.2.2:9000/";

final Dio dio = Dio();

Future<Map> GET(String url) async {
  final uri = Uri.parse(endpoint + url);

  try {
    final res = await http.get(uri);
    print("This is res.body:");
    print(res.body);
    print("------");

    return jsonDecode(res.body) as Map;
  } on Exception catch (e) {
    print(e.toString());
    print("ERROR IN:: $filename" + "::line 21");
    return {"flutter-caught-error": e};
  }
}

Future<Map> POST(String url, Map? body) async {
  try {
    final res = await dio.post(endpoint + url,
        data: jsonEncode(body),
        options:
            Options(headers: {Headers.acceptHeader: Headers.jsonContentType}));

    return Map.castFrom(res.data);
  } on Exception catch (e) {
    print(e.toString());
    print("ERROR IN:: $filename");
    return {"flutter-caught-error": e};
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
      return {"status":0,"result":"error"};
    }
    else{
      return jsonDecode(result);
    }
  } on Exception catch (e) {
    return {"status":0,"result":"error"};
  }


}

/// TODO: NOT WORKKING
Future<Map> PATCH(String url, Map? body) async {
  final uri = Uri.parse(endpoint + url);

  try {
    final res = await http.patch(uri,
        body: jsonEncode(body), headers: {
      HttpHeaders.acceptHeader: Headers.jsonContentType,
    });

    return jsonDecode(res.body);
  } on Exception catch (e) {
    return {"status":0,"result":"error"};
  }

}