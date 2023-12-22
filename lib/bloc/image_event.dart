part of 'image_bloc.dart';

abstract class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object> get props => [];
}

class ImageInitEvent extends ImageEvent {}

class NewImageFetchedEvent extends ImageEvent {}

class SaveImageEvent extends ImageEvent {
  final FireImage image;

  const SaveImageEvent({required this.image}) : super();
}

class UpdateImageEvent extends ImageEvent {
  final Uint8List image;
  final String key;
  final String directory;
  const UpdateImageEvent(
      {required this.image, required this.key, required this.directory})
      : super();
}

class DeleteImageEvent extends ImageEvent {
  final String key;
  const DeleteImageEvent({required this.key}) : super();
}
