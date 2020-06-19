import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lockie/models/code.dart';

class CodesRepository{
  final String uid;
  final DocumentReference userDoc;

  CodesRepository({this.uid}) : this.userDoc = Firestore.instance.collection("users").document(uid);

  Future<void> addNewCode(Code code) {
    if(code == null) return Future.value();
    return userDoc.updateData({
      "codes": FieldValue.arrayUnion([code.asDocument])
    });
  }

  Future<void> removeCode(Code code) {
    return userDoc.updateData({
    "codes": FieldValue.arrayRemove([code.asDocument])
    });
  }

  Stream<List<Code>> codes() {
    return userDoc.snapshots().map((snapshot) {
      List<dynamic> codes = snapshot.data['codes'];
      List<Code> l = new List<Code>();
      for (int i = 0; i < codes.length; ++i) {
        l.add(Code.fromObject(codes[i]));
      }
      return l;
    });
  }

  Future<void> updateCode(Code oldCode, Code newCode) {
    return Firestore.instance.runTransaction((Transaction t) {
      return t.get(userDoc).then((DocumentSnapshot snap) {
        List<dynamic> codes = snap.data['codes'];
        for(int i = 0;i < codes.length; ++i) {
          if(codes[i]['name'] == oldCode.name && codes[i]['seed'] == oldCode.seed) {
            codes[i] = newCode.asDocument;
          }
        }
        return t.update(userDoc, {
          'codes': codes
        });
      });
    });
  }
}