part of 'image_bloc.dart';

abstract class ImageState extends Equatable {
  const ImageState();
  @override
  List<Object> get props => [];
}

class ImageInit extends ImageState {}

class ImageInitialized extends ImageState {
  const ImageInitialized(this.rawDataMap);
  final Map<String, Uint8List> rawDataMap;

  @override
  List<Object> get props => [rawDataMap];
}

class ImageUpdatedState extends ImageState {
  const ImageUpdatedState(this.rawDataMap, {required this.imageUpdated});
  final Map<String, Uint8List> rawDataMap;
  final String imageUpdated;

  @override
  List<Object> get props => [rawDataMap, imageUpdated];
}
