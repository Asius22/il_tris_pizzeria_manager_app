import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizzeria_model_package/product.dart';
import 'package:il_tris_manager/repository/repository.dart';

part 'product_bloc_event.dart';
part 'product_bloc_state.dart';

class ProductBloc extends Bloc<ProductBlocEvent, ProductBlocState> {
  final ProductRepository _repository = ProductRepository();
  List<Product> _menu = [];
  ProductBloc() : super(ProductBlocInitial()) {
    on<FetchProductEvent>((event, emit) async {
      emit(ProductBlocFetching());
      final prods = await _repository.get();
      _menu = prods;
      _menu.sort(
        (a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()),
      );
      emit(ProductBlocFetched(_menu));
    });

    on<UpdateProductEvent>(
      (event, emit) async {
        _repository.update(event.newProduct, event.key);
        for (var element in _menu) {
          if (element.nome == event.key) {
            _menu
              ..remove(element)
              ..add(event.newProduct);
          }
        }
        emit(ProductBlocFetched(_menu));
      },
    );

    on<RemoveProductEvent>((event, emit) async {
      _repository.remove(event.product);
      _menu.remove(event.product);
      emit(ProductBlocFetched(_menu));
    });

    on<SaveProductEvent>((event, emit) async {
      _repository.save(event.product);
      _menu.add(event.product);
      emit(ProductBlocFetched(_menu));
    });

    on<UpdateAllProductEvent>(
      (event, emit) async {
        String type = event.type;
        double oldPrice = event.oldPrice, newPrice = event.newPrice;

        for (var p in _menu) {
          if (p.type == type && p.prezzi.contains(oldPrice)) {
            p.prezzi
              ..remove(oldPrice)
              ..add(newPrice)
              ..sort((a, b) => a > b ? 1 : 0);
            add(UpdateProductEvent(newProduct: p, key: p.nome));
          }
        }
        emit(ProductBlocFetched(_menu));
      },
    );
  }
}
