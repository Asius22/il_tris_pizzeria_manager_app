import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:il_tris_manager/components/hero_widget.dart';
import 'package:il_tris_manager/components/image_components/image_details_body.dart';
import 'package:il_tris_manager/components/util_info.dart';

class ImageDetailsPage extends StatelessWidget {
  const ImageDetailsPage(
      {super.key, required this.heroTag, required this.rawData});
  final Uint8List rawData;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeroWidget(
              heroTag: heroTag,
              child: Padding(
                padding: primaryPadding,
                child: ClipRRect(
                  borderRadius: imageRectRadius,
                  child: Image.memory(
                    rawData,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ImageDetailsBody(
                heroTag: heroTag,
              ),
            )
          ],
        ),
      ),
    );
  }
}
