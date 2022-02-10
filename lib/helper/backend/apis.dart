import 'rest_apis.dart';

class UserAPIS {
  Future<Map> getUsers() async {
    String endpoint = "users/getAllUsers/";
    return GET(endpoint);
  }

  Future<Map> getSingleUserData(String id) async {
    String endpoint = "users/getUserInfoAdmin/$id";
    return GET(endpoint);
  }

  Future<Map> getRecommendations(String id) async {
    String endpoint = "users/getRecommendations/$id";
    return GET(endpoint);
  }

  Future<Map> addUser(Map body) async {
    String endpoint = "users/addUser/";
    return POST(endpoint, body);
  }

  Future<Map> deleteUser(String id) async {
    String endpoint = "users/deleteSingleUser/$id";
    return DELETE(endpoint);
  }

  Future<Map> patchUser(String id, Map body) async {
    String endpoint = "users/updateSingleUser/$id";
    return PATCH(endpoint, body);
  }
}

class PostAPIS {
  Future<Map> getPosts(Map body) async {
    String endpoint = "posts/getAllPosts/";
    return POST(endpoint, body);
  }

  Future<Map> addPost(Map body) async {
    String endpoint = "posts/addPost/";
    return POST(endpoint, body);
  }

  Future<Map> addComment(String pID,Map body) async {
    String endpoint = "posts/addComment/$pID";
    return POST_ALT(endpoint, body);
  }

  Future<Map> getSinglePost(String id) async {
    String endpoint = "posts/getSinglePost/$id";
    return GET(endpoint);
  }

  Future<Map> searchPost(Map body) async {
    String endpoint = "posts/search/";
    return POST(endpoint, body);
  }

  Future<Map> upVote(Map body) async {
    String endpoint = "posts/upvote/";
    return PATCH(endpoint, body);
  }

  Future<Map> downVote(Map body) async {
    String endpoint = "posts/downvote/";
    return PATCH(endpoint, body);
  }

  Future<Map> cancelVote(Map body) async {
    String endpoint = "posts/upvote/";
    return PATCH(endpoint, body);
  }

  Future<Map> cancelUpVote(Map body) async {
    String endpoint = "posts/upvote/";
    return PATCH(endpoint, body);
  }

  Future<Map> cancelDownVote(Map body) async {
    String endpoint = "posts/upvote/";
    return PATCH(endpoint, body);
  }
}

class CommunityAPIS {
  Future<Map> getCommunities() async {
    String endpoint = "communities/getAllCommunities";
    return GET(endpoint);
  }

  Future<Map> getSingleCommunity(String id) async {
    String endpoint = "communities/getSingleCommunity/$id";
    return GET(endpoint);
  }

  Future<Map> addCommunity(Map body) async {
    String endpoint = "communities/addCommunity/";
    return POST(endpoint, body);
  }

  Future<Map> deleteCommunity(String id) async {
    String endpoint = "communities/deleteSingleCommunity/$id";
    return DELETE(endpoint);
  }
}
