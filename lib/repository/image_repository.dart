import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

///Questa classe deve fare da intermediario tra il cloud storage ed il client
///ha una sua istanza di FirebaseStorage, fetcha i dati e restituisce una lista di Uin8List
///

class ImageRepository {
  late final FirebaseStorage _storageRef;
  final Map<String, Uint8List> _imageDataList = {};
  static const _directories = ["pizza", "panuozzo"];
  ImageRepository() {
    _storageRef = FirebaseStorage.instance;
  }

  Future<Map<String, Uint8List>> getAll() async {
    if (_imageDataList.isEmpty) {
      await _fetchImages();
    }
    return _imageDataList;
  }

  Future<void> _fetchImages() async {
    for (var directory in _directories) {
      final all = await _storageRef.ref(directory).listAll();
      //per ogni cartella
      for (var element in all.items) {
        // per ogni elemento della cartella
        final key = element.fullPath; //usa il path come
        if (!_imageDataList.containsKey(key)) {
          //aggiungi i dati dell'immagine solo se non sono già stati inseriti
          await element
              .getData()
              .then((value) => _imageDataList.putIfAbsent(key, () => value!))
              .catchError(
            (e) {
              log("$key: fetch error");
              return e;
            },
          );
        }
      }
    }
  }
}
