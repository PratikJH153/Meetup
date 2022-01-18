import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meetupapp/models/user.dart';

class UserDBHelper {
  static const endpoint = "http://10.0.2.2:9000/user/";

  static Future<bool> addUserData(User user) async {
    final url = Uri.parse("$endpoint/addUser");
    final userData = User.toJson(user);
    try {
      print(userData);
      final response = await http.post(
        url,
        body: json.encode(userData),
      );
      final body = json.decode(response.body);
      print(body);
      return true;
    } catch (err) {
      print("ERROR FROM USER DB HELPER: " + err.toString());
      rethrow;
    }
  }
}
