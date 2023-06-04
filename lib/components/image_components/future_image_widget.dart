import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:il_tris_manager/components/hero_widget.dart';
import 'package:il_tris_manager/pages/image_detail_page.dart';
import '../util_info.dart';

///questo widget riceve un rawData e lo trasforma nell'immagine che poi dovrà mostrare
///finchè la conversione non è pronta mostra un placeholder
class FutureImageWidget extends StatelessWidget {
  const FutureImageWidget(
      {super.key, required this.rawData, required this.imageKey});
  final Uint8List rawData;
  final String imageKey;
  static const _padding = EdgeInsets.all(4.0);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding,
      child: ClipRRect(
        //crea i bordi arrotondati per l'immagine
        borderRadius: imageRectRadius,
        child: HeroWidget(
          //gestisce la transizione verso la pagina di dettaglio
          heroTag: imageKey,
          child: InkWell(
            // gesticce il click
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => // apri la pagina di dettaglio
                    ImageDetailsPage(heroTag: imageKey, rawData: rawData),
              ),
            ),
            child: Image.memory(
              // carica il raw data
              rawData,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
