import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:il_tris_manager/bloc/image_bloc.dart';
import 'package:il_tris_manager/components/image_components/future_image_widget.dart';
import 'package:il_tris_manager/pages/waiting_page.dart';
import 'package:image_picker/image_picker.dart';

class ImagePage extends StatelessWidget {
  const ImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<ImageBloc, ImageState>(
        builder: (context, state) {
          if (state is ImageInitialized) {
            final data = state.rawDataMap;
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
            BlocProvider.of<ImageBloc>(context).add(ImageInitEvent());
            return const WaitingPage();
          }
        },
      ),
    );
  }

  _pickImage(BuildContext context) async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File f = File(pickedFile.path);

/* ELIMINARE QUESTO COMMENTO ED IMPLEMENTARE L'INSERIMENTO DI UNA NUOVA IMMAGINE
      String name = await showDialog<String>(
              context: context, builder: (context) => ImageRenameAlert()) ??
          "";
      final image = FireImage(key: name, file: f);
*/
    }
  }
}
