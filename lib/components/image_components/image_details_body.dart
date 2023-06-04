import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:il_tris_manager/components/util_info.dart';
import 'package:image_picker/image_picker.dart';

class ImageDetailsBody extends StatefulWidget {
  const ImageDetailsBody({super.key, required this.heroTag});
  final String heroTag;

  @override
  State<ImageDetailsBody> createState() => _ImageDetailsBodyState();
}

class _ImageDetailsBodyState extends State<ImageDetailsBody> {
  bool _editMode = false;
  bool _imagePicked = false;
  late Uint8List _rawData;
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.heroTag,
          style: textTheme.titleLarge,
        ),
        if (_imagePicked)
          Image.memory(
            _rawData,
            // width: 180,
            // height: 180,
            cacheHeight: 180,
            cacheWidth: 180,
            fit: BoxFit.fill,
          ),
        const Expanded(child: SizedBox()),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: imageRectRadius,
                color: colorScheme.tertiaryContainer),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.arrow_back,
                      color: colorScheme.onTertiaryContainer,
                    ),
                  ),
                  InkWell(
                    onTap: _onDeleteClicked,
                    child: Icon(
                      Icons.delete,
                      color: colorScheme.onTertiaryContainer,
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        _editMode ? _onConfirmClicked() : _onEditClicked(),
                    child: Icon(
                      _editMode ? Icons.check : Icons.edit,
                      color: colorScheme.onTertiaryContainer,
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  _onDeleteClicked() {
    setState(() {
      _editMode = false;
      _imagePicked = false;
    });
  }

  _onEditClicked() async {
    _pickImage(context)
        .then((value) => setState(() {
              _editMode = true;
              _imagePicked = true;
              _rawData = value;
            }))
        .onError((error, stackTrace) => null);
  }

  _onConfirmClicked() {
    setState(() => _editMode = !_editMode);
  }

  Future<Uint8List> _pickImage(BuildContext context) async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return await pickedFile.readAsBytes();
/* ELIMINARE QUESTO COMMENTO ED IMPLEMENTARE L'INSERIMENTO DI UNA NUOVA IMMAGINE
      String name = await showDialog<String>(
              context: context, builder: (context) => ImageRenameAlert()) ??
          "";
      final image = FireImage(key: name, file: f);
*/
    }

    return await Future<Uint8List>.error(Null);
  }
}
