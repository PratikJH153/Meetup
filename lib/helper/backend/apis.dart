import 'rest_apis.dart';

class UserAPIS {
  Future<Map> getUsers() async {
    print("CALLING getUsers()");
    String endpoint = "users/getAllUsers/";
    return GET(endpoint);
  }

  Future<Map> getSingleUserData(String id) async {
    print("CALLING getSingleUserData(String id)");
    String endpoint = "users/getUserInfoAdmin/$id";
    return GET(endpoint);
  }

  Future<Map> getRecommendations(String id) async {
    print("CALLING getRecommendations(String id)");
    String endpoint = "users/getRecommendations/$id";
    return GET(endpoint);
  }

  Future<Map> addUser(Map body) async {
    print("CALLING addUser(Map body)");
    String endpoint = "users/addUser/";
    return POST(endpoint, body);
  }

  Future<Map> deleteUser(String id) async {
    print("CALLING deleteUser(String id)");
    String endpoint = "users/deleteSingleUser/$id";
    return DELETE(endpoint);
  }

  Future<Map> patchUser(String id, Map body) async {
    print("CALLING patchUser(String id, Map body)");
    String endpoint = "users/updateSingleUser/$id";
    return PATCH(endpoint, body);
  }
}

class PostAPIS {
  Future<Map> getPosts(Map body) async {
    print("CALLING getPosts(Map body)");
    String endpoint = "posts/getAllPosts/";
    return POST(endpoint, body);
  }

  Future<Map> getRelatedPosts(String tag) async {
    print("CALLING getRelatedPosts(String tag)");
    String endpoint = "posts/getRelatedPosts/$tag";
    return GET(endpoint);
  }
  Future<Map> getTrendingPosts() async {
    print("CALLING getTrendingPosts()");
    String endpoint = "posts/getTrendingPosts/";
    return GET(endpoint);
  }

  Future<Map> addPost(Map body) async {
    print("CALLING addPost(Map body)");
    String endpoint = "posts/addPost/";
    return POST(endpoint, body);
  }

  Future<Map> addComment(String pID, Map body) async {
    print("CALLING addComment(String pID, Map body)");
    String endpoint = "posts/addComment/$pID";
    return POST(endpoint, body);
  }

  Future<Map> deleteComment(Map body) async {
    print("CALLING deleteComment(Map body)");
    String endpoint = "posts/deleteComment";
    return DELETE(endpoint, body: body);
  }

  Future<Map> getComments(String id) async {
    print("CALLING getComments(String id)");
    String endpoint = "posts/getComments/$id";
    return GET(endpoint);
  }

  Future<Map> searchPost(Map body) async {
    print("CALLING searchPost(Map body)");
    String endpoint = "posts/search/";
    return POST(endpoint, body);
  }

  Future<Map> upVote(Map body) async {
    print("CALLING upVote(Map body)");
    String endpoint = "posts/upvote/";
    return POST(endpoint, body);
  }

  Future<Map> downVote(Map body) async {
    print("CALLING downVote(Map body)");
    String endpoint = "posts/downvote/";
    return POST(endpoint, body);
  }

  Future<Map> cancelUpVote(Map body) async {
    print("CALLING cancelUpVote(Map body)");
    String endpoint = "posts/cancelupvote/";
    return POST(endpoint, body);
  }

  Future<Map> cancelDownVote(Map body) async {
    print("CALLING cancelDownVote(Map body)");
    String endpoint = "posts/canceldownvote/";
    return POST(endpoint, body);
  }
}
