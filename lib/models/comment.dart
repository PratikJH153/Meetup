// ignore_for_file: prefer_typing_uninitialized_variables

class Comment {
  final String? commentID;
  final String? userID;
  final String? username;
  final String? userProfile;
  final String? message;
  final String? timeStamp;

  Comment({
    this.commentID,
    this.userID,
    this.username,
    this.userProfile,
    this.message,
    this.timeStamp,
  });

  factory Comment.fromJson(Map data) {
    // print("COMMENT DATA");
    // print(data);

    var user = data["userID"];
    var profile;
    var username;
    var uid;

    if (user != null) {
      uid = data["userID"]["_id"];
      profile = data["userID"]["profileURL"];
      username = data["userID"]["username"];
    }

    return Comment(
      commentID: data["_id"],
      userID: uid,
      userProfile: profile,
      username: username,
      timeStamp: data["timestamp"],
      message: data["message"],
    );
  }

  static Map<String, dynamic> toJson(Comment comment) {
    return {
      "_id": comment.commentID,
      "message": comment.message,
      "userID": comment.userID,
      "username": comment.username,
      "userProfile": comment.userProfile,
      "timestamp": comment.timeStamp,
    };
  }
}
