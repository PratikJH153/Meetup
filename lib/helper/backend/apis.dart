import 'database.dart';
import 'rest_apis.dart';

class UserAPIS {
  Future<Map> getUsers() async {
    if (kDebugMode) {
      print("CALLING getUsers()");
    }
    String endpoint = "users/getAllUsers/";
    return GET(endpoint);
  }

  Future<Map> getSingleUserData(String id) async {
    // GETS USER DATA AND FILLS UserProvider
    if (kDebugMode) {
      print("CALLING getSingleUserData(String id)");
    }
    String endpoint = "users/getUserInfoAdmin/$id";
    return GET(endpoint);
  }

  Future<Map> getRecommendations(String id) async {
    if (kDebugMode) {
      print("CALLING getRecommendations(String id)");
    }
    String endpoint = "users/getRecommendations/$id";
    return GET(endpoint);
  }

  Future<Map> addUser(Map body) async {
    if (kDebugMode) {
      print("CALLING addUser(Map body)");
    }
    String endpoint = "users/addUser/";
    return POST(endpoint, body);
  }

  Future<Map> deleteUser(String id) async {
    if (kDebugMode) {
      print("CALLING deleteUser(String id)");
    }
    String endpoint = "users/deleteSingleUser/$id";
    return DELETE(endpoint);
  }

  Future<Map> patchUser(String id, Map body) async {
    if (kDebugMode) {
      print("CALLING patchUser(String id, Map body)");
    }
    String endpoint = "users/updateUserInfo/$id";
    return PATCH(endpoint, body);
  }

  static Future<Map> getCheckUserExists(String id) async {
    if (kDebugMode) {
      print("CALLING getCheckUserExists(String id)");
    }
    String endpoint = "users/checkUserExists/$id";
    return GET(endpoint);
  }
}

class PostAPIS {
  Future<Map> getPosts(Map body) async {
    if (kDebugMode) {
      print("CALLING getPosts(Map body)");
    }
    String endpoint = "posts/getAllPosts/";
    return POST(endpoint, body);
  }

  Future<Map> getUserPosts(String userID) async {
    if (kDebugMode) {
      print("CALLING getUser(Map body)");
    }
    String endpoint = "posts/getUserPosts/$userID";
    return GET(endpoint);
  }

  Future<Map> getRelatedPosts(String tag) async {
    if (kDebugMode) {
      print("CALLING getRelatedPosts(String tag)");
    }
    String endpoint = "posts/getRelatedPosts/$tag";
    return GET(endpoint);
  }

  Future<Map> getTrendingPosts() async {
    if (kDebugMode) {
      print("CALLING getTrendingPosts()");
    }
    String endpoint = "posts/getTrendingPosts/";
    return GET(endpoint);
  }

  Future<Map> addPost(Map body) async {
    if (kDebugMode) {
      print("CALLING addPost(Map body)");
    }
    String endpoint = "posts/addPost/";
    return POST(endpoint, body);
  }

  Future<Map> addComment(String pID, Map body) async {
    if (kDebugMode) {
      print("CALLING addComment(String pID, Map body)");
    }
    String endpoint = "posts/addComment/$pID";
    return POST(endpoint, body);
  }

  Future<Map> deleteComment(Map body) async {
    if (kDebugMode) {
      print("CALLING deleteComment(Map body)");
    }
    if (kDebugMode) {
      print(body);
    }
    String endpoint = "posts/deleteComment/";
    return DELETE(endpoint, body: body);
  }

  Future<Map> getComments(String id) async {
    if (kDebugMode) {
      print("CALLING getComments(String id)");
    }
    String endpoint = "posts/getComments/$id";
    return GET(endpoint);
  }

  Future<Map> searchPost(Map body) async {
    if (kDebugMode) {
      print("CALLING searchPost(Map body)");
    }
    String endpoint = "posts/search/";
    return POST(endpoint, body);
  }

  Future<Map> upVote(Map body) async {
    if (kDebugMode) {
      print("CALLING upVote(Map body)");
    }
    String endpoint = "posts/upvote/";
    return POST(endpoint, body);
  }

  Future<Map> downVote(Map body) async {
    if (kDebugMode) {
      print("CALLING downVote(Map body)");
    }
    String endpoint = "posts/downvote/";
    return POST(endpoint, body);
  }

  Future<Map> cancelUpVote(Map body) async {
    if (kDebugMode) {
      print("CALLING cancelUpVote(Map body)");
    }
    String endpoint = "posts/cancelupvote/";
    return POST(endpoint, body);
  }

  Future<Map> cancelDownVote(Map body) async {
    if (kDebugMode) {
      print("CALLING cancelDownVote(Map body)");
    }
    String endpoint = "posts/canceldownvote/";
    return POST(endpoint, body);
  }
}
