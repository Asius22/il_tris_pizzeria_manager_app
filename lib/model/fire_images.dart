import 'dart:io';

import 'package:equatable/equatable.dart';

class FireImage extends Equatable {
  final String key;
  final File file;

  const FireImage({required this.key, required this.file});

  @override
  List<Object?> get props => [key, file];
}
