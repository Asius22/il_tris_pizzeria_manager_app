import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:il_tris_manager/blocs/translator_bloc.dart';
import 'package:pizzeria_model_package/blocs/product/product_bloc.dart';
import 'package:pizzeria_model_package/model/product.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';

enum _LangStatus { idle, checking, downloading, installed, error }

class NewLinguaForm extends StatefulWidget {
  const NewLinguaForm({super.key, required this.products});
  final List<Product> products;

  @override
  State<NewLinguaForm> createState() => NewLinguaFormState();
}

class NewLinguaFormState extends State<NewLinguaForm> {
  late final TextEditingController controller;

  // Stato per ogni lingua (key = bcpCode, es: "en")
  final Map<String, _LangStatus> _status = {};

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();

    // Pre-inizializza lo stato: se già presente nelle tue lingue, segna "installed"
    // (opzionale, ma utile per UI reattiva)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lingue = BlocProvider.of<ProductBloc>(context)
          .lingue; // lista di bcpCode già presenti
      for (final l in TranslateLanguage.values) {
        final code = l.bcpCode;
        _status.putIfAbsent(
            code,
            () => lingue.contains(code)
                ? _LangStatus.installed
                : _LangStatus.idle);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final lingue = BlocProvider.of<ProductBloc>(context).lingue;

    return BlocBuilder<TranslatorBloc, TranslatorBlocState>(
        builder: (context, state) {
      if (state is TranslatorBlocLoading) {
        return Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 32,
            children: [
              LinearProgressIndicator(
                value: state.progress / 100,
              ),
              Text(
                '${state.progress.toStringAsFixed(2)} %',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              )
            ],
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize:
                    MainAxisSize.min, // <-- evita conflitto con lo scroll
                children: [
                  const SizedBox(height: 8),
                  ...TranslateLanguage.values.map((lingua) {
                    final code = lingua.bcpCode;
                    final state = _status[code] ?? _LangStatus.idle;

                    // bottone disabilitato se già installata
                    final bool isInstalled =
                        state == _LangStatus.installed || lingue.contains(code);
                    final bool isBusy = state == _LangStatus.checking ||
                        state == _LangStatus.downloading;

                    Widget child;
                    if (state == _LangStatus.checking) {
                      child = _RowStatus(
                          label: '${lingua.name} ($code) • Controllo modello…',
                          busy: true);
                    } else if (state == _LangStatus.downloading) {
                      child = _RowStatus(
                          label: '${lingua.name} ($code) • Download in corso…',
                          busy: true);
                    } else if (state == _LangStatus.installed) {
                      child = _RowStatus(
                          label: '${lingua.name} ($code) • Installato',
                          icon: Icons.check_circle);
                    } else if (state == _LangStatus.error) {
                      child = _RowStatus(
                          label: '${lingua.name} ($code) • Errore',
                          icon: Icons.error_outline);
                    } else {
                      child = Text('${lingua.name} ($code)');
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: OutlinedButton(
                        onPressed: (!isBusy)
                            ? () => (!isInstalled)
                                ? _aggiungiLingua(code, lingua)
                                : _ritraduci(code, lingua)
                            : null,
                        child: child,
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      }
    });
  }

  Future<void> _aggiungiLingua(String bcpCode, TranslateLanguage lingua) async {
    // NB: non usi più il controller.text qui; lo lascio se ti serve altrove
    setState(() => _status[bcpCode] = _LangStatus.checking);

    final manager = OnDeviceTranslatorModelManager();

    try {
      final isDownloaded = await manager.isModelDownloaded(bcpCode);

      if (!isDownloaded) {
        // Mostra "download in corso..."
        setState(() => _status[bcpCode] = _LangStatus.downloading);

        await manager.downloadModel(bcpCode);

        // completato
        setState(() => _status[bcpCode] = _LangStatus.installed);

        toastification.show(
          title: const Text('Modello scaricato!'),
          style: ToastificationStyle.flat,
          autoCloseDuration: const Duration(seconds: 4),
          type: ToastificationType.success,
        );
      } else {
        // già presente
        setState(() => _status[bcpCode] = _LangStatus.installed);
        toastification.show(
          title: const Text('Modello già presente'),
          style: ToastificationStyle.flat,
          autoCloseDuration: const Duration(seconds: 3),
          type: ToastificationType.info,
        );
      }

      final translator = OnDeviceTranslator(
        sourceLanguage: TranslateLanguage.italian,
        targetLanguage: lingua,
      );

      if (mounted)
      // Avvia la traduzione via bloc
      {
        BlocProvider.of<TranslatorBloc>(context).add(
          TranslateProductsEvent(widget.products, bcpCode, translator),
        );
      }
    } catch (e, st) {
      log('Download modello $bcpCode fallito: $e\n$st');
      setState(() => _status[bcpCode] = _LangStatus.error);

      toastification.show(
        title: const Text('Errore nel download del modello'),
        style: ToastificationStyle.flat,
        autoCloseDuration: const Duration(seconds: 5),
        type: ToastificationType.error,
      );
    }
  }

  void _ritraduci(String bcpCode, TranslateLanguage lingua) {
    final translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.italian,
      targetLanguage: lingua,
    );

    if (mounted) {
      BlocProvider.of<TranslatorBloc>(context).add(
        TranslateProductsEvent(widget.products, bcpCode, translator),
      );
    }
  }
}

class _RowStatus extends StatelessWidget {
  const _RowStatus({required this.label, this.busy = false, this.icon});
  final String label;
  final bool busy;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, overflow: TextOverflow.ellipsis)),
        if (busy)
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        if (icon != null) ...[
          const SizedBox(width: 8),
          Icon(icon, size: 18),
        ],
      ],
    );
  }
}
