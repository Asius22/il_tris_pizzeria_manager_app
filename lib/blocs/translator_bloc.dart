import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:pizzeria_model_package/model/product.dart';
import 'package:pizzeria_model_package/repository/product_repository.dart';

part 'translator_event.dart';
part 'translator_state.dart';

// Bloc
class TranslatorBloc extends Bloc<TranslatorBlocEvent, TranslatorBlocState> {
  final ProductRepository repository;
  TranslatorBloc({required this.repository}) : super(TranslatorBlocInitial()) {
    on<InitializeTranslatorEvent>(
      (event, emit) async {
        emit(TranslatorBlocInitialized());
      },
    );

    on<TranslateAllProductEvent>(
      (event, emit) async {
        emit(const TranslatorBlocLoading(0));

        const from = TranslateLanguage.italian;
        final Map<String, OnDeviceTranslator> translators = {};
        int productsTranslated = 0, productsLenght = event.prodotti.length;
        double progress = 0;
        for (String lingua in event.lingue) {
          if (lingua != 'it' && lingua != 'en') {
            translators[lingua] = OnDeviceTranslator(
              sourceLanguage: from,
              targetLanguage: TranslateLanguage.values.firstWhere(
                (element) => element.bcpCode == lingua,
              ),
            );
          }
        }

        for (Product p in event.prodotti) {
          String text = p.descrizioni['it'] ?? '';
          if (text.isEmpty) {
            text = p.nome;
          } else if (text.isNotEmpty && text.toLowerCase() == 'x2') {
            text = '${p.nome} (per due persone)';
          }
          for (String l in translators.keys) {
            p.descrizioni[l] = await translators[l]!.translateText(text);
          }
          productsTranslated++;
          progress = (productsTranslated / productsLenght * 100);
          repository.update(p, p.nome);
          emit(TranslatorBlocLoading(progress));
        }
      },
    );
    on<TranslateNewProductEvent>(
      (event, emit) async {
        emit(const TranslatorBlocLoading(0));

        const from = TranslateLanguage.italian;
        final Map<String, OnDeviceTranslator> translators = {};
        for (String lingua in event.lingue) {
          if (lingua != 'it') {
            translators[lingua] = OnDeviceTranslator(
              sourceLanguage: from,
              targetLanguage: TranslateLanguage.values.firstWhere(
                (element) => element.bcpCode == lingua,
              ),
            );
          }
        }

        final Product p = event.prodotti;
        String text = p.descrizioni['it'] ?? '';
        if (text.isEmpty) {
          text = p.nome;
        } else if (text.isNotEmpty && text.toLowerCase() == 'x2') {
          text = '${p.nome} (per due persone)';
        }
        for (String l in translators.keys) {
          p.descrizioni[l] = await translators[l]!.translateText(text);
        }

        repository.save(p);
      },
    );

    on<TranslateProductsEvent>(
      (event, emit) async {
        emit(const TranslatorBlocLoading(0));
        final deviceTranslator = event.deviceTranslator;
        final int productsLenght = event.products.length;
        int productsTranslated = 0;
        double progress = 0;
        for (Product p in event.products) {
          String text = p.descrizioni['it'] ?? '';
          if (text.isEmpty) {
            text = p.nome;
            log(text);
          } else if (text.isNotEmpty && text.toLowerCase() == 'x2') {
            text = '${p.nome} (per due persone)';
          }
          p.descrizioni[event.targetLanguage] =
              await deviceTranslator.translateText(text);
          productsTranslated++;
          progress = (productsTranslated / productsLenght * 100);
          repository.update(p, p.nome);
          emit(TranslatorBlocLoading(progress));
        }
        emit(TranslatorBlocInitialized());
      },
    );
  }
}
