part of 'product_bloc.dart';

abstract class ProductBlocState extends Equatable {
  const ProductBlocState({this.products = const []});
  final List<Product> products;

  @override
  List<Object> get props => [...products];
}

class ProductBlocInitial extends ProductBlocState {}

class ProductBlocFetching extends ProductBlocState {}

class ProductBlocFetched extends ProductBlocState {
  const ProductBlocFetched(List<Product> products) : super(products: products);
}

class UpdateSuccessState extends ProductBlocState {}
