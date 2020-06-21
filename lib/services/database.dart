import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:random_Fun/models/Post.dart';
import 'package:random_Fun/models/user.dart';

class Database {
  final db = Firestore.instance.collection('users');
  static int count = 0;

  Future<void> addUserToDatabase(User user) async {
    var now = new DateTime.now();
    var formatter = DateFormat.yMd().add_jm();
    String curr_date_str = formatter.format(now);

    await db
        .document(user.uid)
        .setData({
          "uid": user.uid,
          "displayName": user.displayName ?? "",
          "email": user.email,
          "photoUrl":
              user.photoUrl ?? "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcdn3.iconfinder.com%2Fdata%2Ficons%2Fusers-23%2F64%2F_Male_Profile_Round_Circle_Users-512.png&f=1&nofb=1",
          "status": "Heyy , there I am new here !",
          "memberSince": curr_date_str
        })
        .then((value) => {print("User is added to db !")})
        .catchError((error) {
          return Future.error("Some issues");
        });
  }

  Future<List<Post>> getPostsLists(String uid) async {
    return await Firestore.instance.collection('all_posts/$uid/my_posts').getDocuments().then((value) => value.documents.map((e) => Post.fromJson(e.data)).toList());
  }

  Future<bool> updatePhotoUrl(String uid, String photoUrl) async {
    await db.document(uid).updateData({'photoUrl': photoUrl}).then((value) {
      return true;
    });
    return false;
  }

  Future<bool> createNewPost(String uid, Map<String, dynamic> newPost) async {
    count = count + 1;
    Firestore.instance.collection('all_posts').document(uid).setData({'postOwner': uid, 'createdAt': FieldValue.serverTimestamp()});

    Firestore.instance
        .collection('all_posts')
        .document(uid)
        .collection('my_posts')
        .document()
        .setData({'todo': newPost['todo'], 'desc': newPost['desc'], 'link': newPost['link'], 'category': newPost['category'], 'createdAt': FieldValue.serverTimestamp(), 'likes': 0})
        .then((status) {})
        .catchError((errorMsg) {
          return Future.error("Unable to update post currently !");
        });
  }

  Stream getAllUserPosts() {
    return Firestore.instance.collection('all_posts').snapshots();
  }

  Stream<User> getUserDetails(String uid) {
    DocumentReference ref = db.document(uid);
    final snapshots = ref.snapshots();
    return snapshots.map((snapshot) => User.fromJson(snapshot.data));
  }

  Future getUser(String uid) async {
    final user = await db.document(uid).get();
    return user.data;
  }

  Future<dynamic> getUserByName(String name) async {
    return await db.getDocuments().then((value) => value.documents.where((user) => user.data['displayName'].toLowerCase().contains(name.toLowerCase())).toList());
  }

  Stream getAllPosts(String uid) {
    return Firestore.instance.collection('/all_posts/$uid/my_posts').snapshots();
  }

  Future<bool> updateStatus(String uid, String status) async {
    await db.document(uid).updateData({'status': status}).then((value) {
      return true;
    });
    return false;
  }

  Future<bool> checkNewUser(User user) async {
    bool isNewUser = true;

    DocumentSnapshot snap = await db.document(user.uid).get();
    if (snap.exists) {
      isNewUser = false;
    } else {
      isNewUser = true;
    }
    return isNewUser;

    // .then((docRef) {
    //   if (docRef.exists) {
    //     isNewUser = false;
    //     return isNewUser;
    //   }
    // });
  }
}
