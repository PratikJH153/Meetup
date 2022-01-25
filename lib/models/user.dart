class UserClass {
  final String? userID;
  final String? username;
  final String? email;
  final String? profileURL;
  final String? gender;
  final int? age;
  final String? bio;
  final List? interests;
  final int? matched;

  UserClass({
    this.userID,
    this.matched,
    required this.username,
    required this.email,
    this.profileURL =
        "https://raw.githubusercontent.com/AKAMasterMind404/meetup-backend/main/assets/placeholder-no-man-1.png?token=GHSAT0AAAAAABOC3R3SRUT6ITAWYT5PVNJMYPONQKA",
    required this.gender,
    required this.age,
    required this.bio,
    required this.interests,
  });

  factory UserClass.fromJson(Map<dynamic, dynamic> userData) {
    return UserClass(
      userID: userData["_id"],
      username: userData["username"]??"null",
      email: userData["email"]??"null",
      profileURL: userData["profileURL"]??"null",
      gender: userData["gender"]??"null",
      age: userData["age"]??-1,
      bio: userData["bio"]??"This is my bio",
      interests: userData["interests"]??[],
      matched: userData["matched"]
    );
  }

  static Map<String, dynamic> toJson(UserClass user) {
    return {
      "id": user.userID,
      "username": user.username,
      "email": user.email,
      "profileURL": user.profileURL,
      "gender": user.gender,
      "age": user.age,
      "bio": user.bio,
      "interests": user.interests,
    };
  }
}
