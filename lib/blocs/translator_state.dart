part of 'translator_bloc.dart';

class TranslatorBlocState extends Equatable {
  const TranslatorBlocState();

  @override
  List<Object?> get props => [];
}

class TranslatorBlocInitial extends TranslatorBlocState {}

class TranslatorBlocInitializing extends TranslatorBlocState {}

class TranslatorBlocInitialized extends TranslatorBlocState {}

class TranslatorBlocLoading extends TranslatorBlocState {
  final double progress;
  const TranslatorBlocLoading(this.progress);

  @override
  List<Object?> get props => [progress];
}
