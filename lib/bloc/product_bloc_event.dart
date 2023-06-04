part of 'product_bloc.dart';

abstract class ProductBlocEvent extends Equatable {
  const ProductBlocEvent();

  @override
  List<Object> get props => [];
}

class FetchProductEvent extends ProductBlocEvent {}

class UpdateProductEvent extends ProductBlocEvent {
  const UpdateProductEvent({required this.newProduct, required this.key});
  final Product newProduct;
  final String key;
}

class RemoveProductEvent extends ProductBlocEvent {
  const RemoveProductEvent({required this.product});
  final Product product;
}

class SaveProductEvent extends ProductBlocEvent {
  const SaveProductEvent({required this.product});
  final Product product;
}

class UpdateAllProductEvent extends ProductBlocEvent {
  const UpdateAllProductEvent(
      {required this.newPrice, required this.oldPrice, required this.type});
  final String type;
  final double newPrice, oldPrice;
}
