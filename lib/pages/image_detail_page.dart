import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:il_tris_manager/bloc/image_bloc.dart';
import 'package:il_tris_manager/components/hero_widget.dart';
import 'package:il_tris_manager/components/util_info.dart';
import 'package:image_picker/image_picker.dart';

class ImageDetailsPage extends StatefulWidget {
  const ImageDetailsPage(
      {super.key, required this.heroTag, required this.rawData});
  final Uint8List rawData;
  final String heroTag;

  @override
  State<ImageDetailsPage> createState() => _ImageDetailsPageState();
}

class _ImageDetailsPageState extends State<ImageDetailsPage> {
  late bool _editMode;
  late Uint8List? _rawData;

  @override
  void initState() {
    _editMode = false;
    _rawData = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: Column(
              children: [
                HeroWidget(
                  heroTag: widget.heroTag,
                  child: Padding(
                    padding: primaryPadding,
                    child: ClipRRect(
                      borderRadius: imageRectRadius,
                      child: Image.memory(
                        (_rawData != null) ? _rawData! : widget.rawData,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.heroTag,
                        style: textTheme.titleLarge,
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
                                  onTap: () => _editMode
                                      ? _onConfirmClicked()
                                      : _onEditClicked(),
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
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onDeleteClicked() {
    BlocProvider.of<ImageBloc>(context)
        .add(DeleteImageEvent(key: widget.heroTag));
    setState(() {
      _editMode = false;
    });
    Navigator.of(context).pop();
  }

  _onEditClicked() async {
    _pickImage(context)
        .then((value) => setState(() {
              _editMode = true;
              _rawData = value;
            }))
        .onError((error, stackTrace) => null);
  }

  _onConfirmClicked() {
    String key, directory;
    directory = widget.heroTag.substring(0, widget.heroTag.indexOf("/"));
    key = (widget.heroTag
        .substring(widget.heroTag.indexOf("/") + 1, widget.heroTag.length));
    setState(() {
      _editMode = !_editMode;
      BlocProvider.of<ImageBloc>(context).add(
          UpdateImageEvent(image: _rawData!, directory: directory, key: key));
    });

    Navigator.pop(context);
  }

  Future<Uint8List> _pickImage(BuildContext context) async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return await pickedFile.readAsBytes();
    }

    return await Future<Uint8List>.error(Null);
  }
}
