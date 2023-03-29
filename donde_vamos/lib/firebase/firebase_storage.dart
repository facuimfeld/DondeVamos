import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorage {
  Future<String> getURLPrincipalPlace(String namePlace) async {
    namePlace = namePlace.replaceAll(' ', '');

    final ref = firebase_storage.FirebaseStorage.instance
        .ref('lugares/$namePlace/portada.jpg');

    var url = await ref.getDownloadURL();
    print('URL2' + url);
    return url;
  }

  Future<String> getURLImageEvent(String nameEvent) async {
    nameEvent = nameEvent.replaceAll(' ', '');

    final ref = firebase_storage.FirebaseStorage.instance
        .ref('eventos/$nameEvent/$nameEvent.jpg');

    var url = await ref.getDownloadURL();
    print('URL2' + url);
    return url;
  }

  Future<List<String>> getURLPlace(String namePlace) async {
    namePlace = namePlace.replaceAll(' ', '');
/*
    final ref = firebase_storage.FirebaseStorage.instance
        .ref('lugares/$namePlace/portada.jpg');
*/
    List<String> urls = [];
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('lugares')
        .child('$namePlace')
        .listAll();
    for (firebase_storage.Reference ref in result.items) {
      String url = await firebase_storage.FirebaseStorage.instance
          .ref(ref.fullPath)
          .getDownloadURL();
      urls.add(url);
    }
    //var url = await ref.getDownloadURL();
    return urls;
  }
}
