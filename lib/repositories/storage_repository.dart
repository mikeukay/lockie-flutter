import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageRepository {
  final String uid;
  final StorageReference userDir;

  StorageRepository({this.uid}) : this.userDir = FirebaseStorage().ref().child(uid);

  Future<String> uploadFile(String localFilePath) async {
    final String uuid = Uuid().v1();
    final String filename = uuid + localFilePath.split('.').last;
    StorageUploadTask uploadTask = this.userDir.child(filename).putFile(
      File(localFilePath)
    );
    StorageTaskSnapshot snap = await uploadTask.onComplete;
    return (await snap.ref.getDownloadURL()).toString();
  }

}