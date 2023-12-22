import 'dart:io';

import 'package:equatable/equatable.dart';

class FireImage extends Equatable {
  final String directory;
  final String key;
  final File file;

  const FireImage(
      {required this.key, required this.file, this.directory = "prova"});

  FireImage copyWith({String? directory, String? key, File? file}) => FireImage(
      key: key ?? this.key,
      file: file ?? this.file,
      directory: directory ?? this.directory);
  @override
  List<Object?> get props => [key, file];
}
