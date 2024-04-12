import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:il_tris_manager/model/fire_images.dart';

///Questa classe deve fare da intermediario tra il cloud storage ed il client
///ha una sua istanza di FirebaseStorage, fetcha i dati e restituisce una lista di Uin8List
///

class ImageRepository extends ChangeNotifier {
  late final FirebaseStorage _storageRef;
  final Map<String, Uint8List> _imageDataList = {};
  static const _directories = [
    "pizza",
    "panuozzo",
    "antipasto",
    "dolce",
    "frittura",
    "primo",
    "secondo"
  ];

  Map<String, Uint8List> get list => _imageDataList;
  final SettableMetadata _metadata = SettableMetadata(
      contentType: "image/jpeg", cacheControl: "public, max-age=3600");
  ImageRepository() {
    _storageRef = FirebaseStorage.instance;
    _fetchImages();
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
          await element.getData().then((value) {
            _imageDataList.putIfAbsent(key, () => value!);
            notifyListeners();
          }).catchError(
            (e) {
              return e;
            },
          );
        }
      }
    }
  }

  Future<FireImage?> saveImage(FireImage image) async {
    Uint8List? imageBytes;
    bool esito = true;
    try {
      imageBytes = image.file.readAsBytesSync();
    } on FileSystemException {
      esito = false;
      log("Si è verificato un errore in fase di lettura del file");
    } finally {
      if (imageBytes != null) {
        _imageDataList.putIfAbsent(
            "${image.directory}/${image.key}.jpg", () => imageBytes!);
        _storageRef
            .ref(image.directory)
            .child("${image.key.toLowerCase().replaceAll(" ", "_")}.jpg")
            .putData(imageBytes, _metadata);
      }
    }
    return esito ? image : null;
  }

  Future<void> updateImage(
      Uint8List image, String key, String directory) async {
    _imageDataList["$directory/$key"] = image;
    _storageRef.ref(directory).child(key).putData(image, _metadata);
  }

  Future<void> deleteImage(String key) async {
    String name, directory;
    directory = key.substring(0, key.indexOf("/"));
    name = key.substring(key.indexOf("/") + 1, key.length);
    _imageDataList.remove(key);
    _storageRef.ref(directory).child(name).delete();
  }
}
