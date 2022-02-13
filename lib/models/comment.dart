class Comment {
  final String? commentID;
  final Map? userData;
  final String? message;
  final String? timeStamp;

  Comment({this.commentID, this.userData, this.message, this.timeStamp});

  factory Comment.fromJson(Map<String, dynamic> data) {
    return Comment(
      commentID: data["_id"],
      userData: data["userID"],
      timeStamp: data["timestamp"],
      message: data["message"],
    );
  }

  static Map<String, dynamic> toJson(Comment comment) {
    return {
      "_id": comment.commentID,
      "message": comment.message,
      "userData": comment.userData,
      "timestamp": comment.timeStamp,
    };
  }
}
