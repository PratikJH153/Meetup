class User {
  final String? userID;
  final String username;
  final String email;
  final String profileURL;
  final String gender;
  final int age;
  final String bio;
  final List<String> interests;

  User({
    this.userID,
    required this.username,
    required this.email,
    this.profileURL =
        "https://raw.githubusercontent.com/AKAMasterMind404/meetup-backend/main/assets/placeholder-no-man-1.png?token=GHSAT0AAAAAABOC3R3SRUT6ITAWYT5PVNJMYPONQKA",
    required this.gender,
    required this.age,
    required this.bio,
    required this.interests,
  });

  factory User.fromJson(Map<String, dynamic> userData) {
    return User(
      userID: userData["_id"],
      username: userData["username"],
      email: userData["email"],
      profileURL: userData["profileURL"],
      gender: userData["gender"],
      age: userData["age"],
      bio: userData["bio"],
      interests: userData["interests"],
    );
  }

  static Map<String, dynamic> toJson(User user) {
    return {
      "_id": user.userID,
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
