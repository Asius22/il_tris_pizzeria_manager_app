import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:il_tris_manager/model/fire_images.dart';
import 'package:il_tris_manager/repository/image_repository.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImageRepository _repository = ImageRepository();
  ImageBloc() : super(ImageInit()) {
    _repository.addListener(
      () => add(NewImageFetchedEvent()),
    );

    on<NewImageFetchedEvent>((event, emit) {
      emit(ImageInitialized({..._repository.list}));
    });

    on<SaveImageEvent>((event, emit) async {
      _repository.saveImage(event.image);
      emit(ImageInitialized({..._repository.list}));
    });

    on<UpdateImageEvent>(
      (event, emit) {
        _repository.updateImage(event.image, event.key, event.directory);
        emit(ImageUpdatedState({..._repository.list}, imageUpdated: event.key));
      },
    );
    on<DeleteImageEvent>(
      (event, emit) {
        _repository.deleteImage(event.key);
        emit(ImageInitialized({..._repository.list}));
      },
    );
  }
}
