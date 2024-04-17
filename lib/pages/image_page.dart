import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizzeria_model_package/blocs/image/image_bloc.dart';

import 'package:il_tris_manager/components/image_components/future_image_widget.dart';
import 'package:il_tris_manager/components/image_components/image_name_alert.dart';
import 'package:pizzeria_model_package/fire_images.dart';
import 'package:il_tris_manager/pages/waiting_page.dart';
import 'package:image_picker/image_picker.dart';

class ImagePage extends StatelessWidget {
  const ImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<ImageBloc, ImageState>(
        builder: (context, state) {
          if (state is ImageInitialized || state is ImageUpdatedState) {
            final data = (state is ImageInitialized)
                ? state.rawDataMap
                : (state as ImageUpdatedState).rawDataMap;
            final keys = data.keys.toList();

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: data.length + 1,
              itemBuilder: (context, index) => index == 0
                  ? InkWell(
                      onTap: () => _pickImage(context),
                      child: const Card(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.library_add),
                              Text("Add Image")
                            ]),
                      ),
                    )
                  : FutureImageWidget(
                      imageKey: keys[index - 1],
                      rawData: data[keys[index - 1]]!,
                    ),
            );
          } else {
            return const WaitingPage();
          }
        },
      ),
    );
  }

  _pickImage(BuildContext context) async {
    await ImagePicker().pickImage(source: ImageSource.gallery).then(
      (value) async {
        if (value != null) {
          File f = File(value.path);
          await showDialog(
              context: context, builder: (context) => ImageRenameAlert()).then(
            (value) async {
              final image = FireImage(key: value ?? "", file: f);
              await showDialog(
                context: context,
                builder: (context) => ImageRenameAlert(
                  text: "Directory: ",
                ),
              ).then((value) {
                BlocProvider.of<ImageBloc>(context).add(
                    SaveImageEvent(image: image.copyWith(directory: value)));
              });
            },
          );
        }
      },
    );
  }
}
