class Comment {
  final String? commentID;
  final String? userID;
  final String? message;
  final String? timeStamp;

  Comment({this.commentID, this.userID, this.message, this.timeStamp});

  factory Comment.fromJson(Map<dynamic, dynamic> data) {
    return Comment(
        commentID: data["_id"],
        userID: data["userID"],
        timeStamp: data["timestamp"],
        message: data["message"]
    );
  }

  static Map<String, dynamic> toJson(Comment comment) {
    return {
      "_id": comment.commentID,
      "message": comment.message,
      "userID": comment.userID,
      "timestamp": comment.timeStamp,
    };
  }
}
