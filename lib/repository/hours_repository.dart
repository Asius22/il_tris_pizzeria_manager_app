import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:pizzeria_model_package/business_hours.dart';
import 'package:pizzeria_model_package/opening_hours_list.dart';

class HoursRepository {
  static const _path = "Orari";
  final DatabaseReference _dbInstance = FirebaseDatabase.instance.ref(_path);
  HoursRepository();

  ///riceve il path del db e restituisce i prodotti a cui punta il path
  Future<BusinessHours> get() async {
    return await _dbInstance.get().then((value) {
      Map<String, OpeningHoursList> map = {};
      for (var child in value.children) {
        String key = child.key ?? "";
        Map<String, dynamic> valueMap =
            Map<String, dynamic>.from((child.value as Map));
        OpeningHoursList value = OpeningHoursList.fromJson(valueMap);
        map.putIfAbsent(key, () => value);
      }
      log(map.toString());
      return BusinessHours.fromDays(daysMap: map);
    });
  }

  Future<void> update(String key, OpeningHoursList hours) async {
    save(key, hours);
  }

  /// rimuove un igorno
  Future<void> remove(String key) async {
    await _dbInstance
        .child(key) //prendi il giorno che stiamo cercando
        .remove() // rimuovilo
        .onError((error, stackTrace) => null);
  }

  /// aggiunge un nuovo giorno con dei nuovi orari
  Future<void> save(String key, OpeningHoursList hours) async {
    Map<String, dynamic> value = hours.toJson();

    _dbInstance
        .child(key) //entra nella subdirectory del giorno

        .set(value)
        .onError((error, stackTrace) => log("$error}")); //aggiungi gli orari
  }

  Future<void> saveAll(BusinessHours hours) async {
    log("[DEBUG] HoursRepository --> saving aall...");
    for (String day in hours.days) {
      log("[DEBUG] HoursRepository -> saving $day");
      Map<String, dynamic> value = hours.getHoursFromkey(day).toJson();
      await _dbInstance
          .child(day)
          .set(value)
          .onError((error, stackTrace) => log(error.toString()));
    }
  }
}
