import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

const filename = "user_db_helper.dart";
const userFolder = "users";

const getUsersURL = "$userFolder/getUsers/";
const addUsersURL = "$userFolder/addUser/";
const endpoint = "http://10.0.2.2:9000/";

class UserDBHelper {
  static Future<Map> GET(String url) async {
    final uri = Uri.parse(url);

    try {
      final res = await http.get(uri);

      return jsonDecode(res.body);
    } on Exception catch (e) {
      print(e.toString());
      print("ERROR IN:: $filename");
      return {"flutter-caught-error": e};
    }
  }

  static Future<Map> POST(String url, Map? body) async {
    final uri = Uri.parse(url);

    try {
      print(body);
      print(jsonEncode(body));
      final res = await Dio().post(url,
          data: jsonEncode(body),
          options: Options(
              headers: {
                Headers.acceptHeader: Headers.jsonContentType
              }));
      print(res);
      // return jsonDecode(res);
      return {};
    } on Exception catch (e) {
      print(e.toString());
      print("ERROR IN:: $filename");
      return {"flutter-caught-error": e};
    }
  }
}
