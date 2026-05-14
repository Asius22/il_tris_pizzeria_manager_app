part of 'translator_bloc.dart';

abstract class TranslatorBlocEvent extends Equatable {
  const TranslatorBlocEvent();

  @override
  List<Object?> get props => [];
}

class TranslateProductsEvent extends TranslatorBlocEvent {
  final List<Product> products;
  final String targetLanguage;
  final OnDeviceTranslator deviceTranslator;
  const TranslateProductsEvent(
      this.products, this.targetLanguage, this.deviceTranslator);

  @override
  List<Object?> get props => [products, targetLanguage];
}

class InitializeTranslatorEvent extends TranslatorBlocEvent {
  const InitializeTranslatorEvent();
}

class TranslateNewProductEvent extends TranslatorBlocEvent {
  final List<String> lingue;
  final Product prodotti;
  const TranslateNewProductEvent(this.lingue, this.prodotti);
}

class TranslateAllProductEvent extends TranslatorBlocEvent {
  final List<String> lingue;
  final List<Product> prodotti;
  const TranslateAllProductEvent(this.lingue, this.prodotti);
}

// Add more events as needed
