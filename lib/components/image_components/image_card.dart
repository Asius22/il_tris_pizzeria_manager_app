import 'dart:io';

import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({super.key, required this.image});
  final File image;
  static const _paddingValue = EdgeInsets.all(2.0);
  static const _borderRadius = BorderRadius.all(Radius.circular(12.0));
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _paddingValue,
      child: Card(
        child: ClipRRect(
          borderRadius: _borderRadius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                image,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  color: Colors.grey.withAlpha(100),
                  child: Padding(
                    padding: _paddingValue,
                    child: Text(
                      image.path.substring(image.path.lastIndexOf("/") + 1),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      maxLines: null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
