import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:il_tris_manager/repository/image_repository.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImageRepository _repository = ImageRepository();
  ImageBloc() : super(ImageInit()) {
    on<ImageInitEvent>((event, emit) async {
      Map<String, Uint8List> datas = await _repository.getAll();
      emit(ImageInitialized(datas));
    });
  }
}
