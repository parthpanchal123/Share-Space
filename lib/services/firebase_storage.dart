import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_Fun/services/firestore_path.dart';

class Storage {
  Future<String> uploadProfileImage(File file, String uid) async {
    String path = FirestorePath().user_url(uid) + '/avatar.png';

    StorageReference ref = FirebaseStorage.instance.ref().child(path);
    final uploadTask =
        ref.putFile(file, StorageMetadata(contentType: 'image/png'));
    final snapshot = await uploadTask.onComplete;
    if (snapshot.error != null) {
      print('upload error code: ${snapshot.error}');
      throw snapshot.error;
    }
    final downloadUrl = await snapshot.ref.getDownloadURL();
    print('downloadUrl: $downloadUrl');
    return downloadUrl;
  }
}
