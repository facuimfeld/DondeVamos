import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestore {
  Future<void> addTokenId(String userId, String tokenId) async {
    FirebaseFirestore.instance.collection("usuarios").add({
      "userId": userId,
      "tokenId": tokenId,
    }).whenComplete(() {
      print('done!');
    });
  }
}
