class User {
  String uid, photoUrl, displayName, email, status, memberSince;

  User({this.uid, this.displayName, this.email, this.photoUrl, this.status, this.memberSince});

  factory User.fromJson(Map<String, dynamic> user_json) {
    return User(
        uid: user_json['uid'],
        displayName: user_json['displayName'],
        email: user_json['email'],
        status: user_json['status'],
        photoUrl: user_json['photoUrl'] ?? "",
        memberSince: user_json['memberSince']);
  }
}
