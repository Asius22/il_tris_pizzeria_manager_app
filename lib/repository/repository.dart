import 'package:firebase_database/firebase_database.dart';
import 'package:il_tris_manager/model/product.dart';

class ProductRepository {
  static const _path = "Prodotti";
  late final DatabaseReference _dbInstance;
  ProductRepository() {
    _dbInstance = FirebaseDatabase.instance.ref(_path);
  }

  ///riceve il path del db e restituisce i prodotti a cui punta li path
  Future<List<Product>> get() async {
    return await _dbInstance.get().then((value) {
      List<Product> result = [];
      if (value.exists) {
        for (var child in value.children) {
          for (var c in child.children) {
            result.add(
                Product.fromJson(Map<String, dynamic>.from(c.value as Map)));
          }
        }
      }
      return result;
    });
  }

  Future<void> update(Product product, String key) async {
    _dbInstance
        .child(
            _getSubAddress(product.type)) //entra nella subdirectory di prodotti
        .child(key) //prendi il prodotto che stiamo cercando
        .set(product.toJson()); //cambia il suo valore
  }

  Future<void> remove(Product product) async {
    await _dbInstance
        .child(
            _getSubAddress(product.type)) //entra nella subdirectory di prodotti
        .child(product.nome) //prendi il prodotto che stiamo cercando
        .remove()
        .onError((error, stackTrace) => null); //cambia il suo valore
  }

  Future<void> save(Product product) async {
    _dbInstance
        .child(
            _getSubAddress(product.type)) //entra nella subdirectory di prodotti
        .child(product.nome) //prendi il prodotto che stiamo cercando
        .set(product.toJson()); //cambia il suo valore
  }

  String _getSubAddress(String type) {
    switch (type) {
      case "Antipasto":
        return "Antipasti";
      case "Bibita":
        return "Bibite";
      case "Panuozzo":
        return "Panuozzi";
      case "Pizza":
        return "Pizze";
      default:
        return "";
    }
  }
}
