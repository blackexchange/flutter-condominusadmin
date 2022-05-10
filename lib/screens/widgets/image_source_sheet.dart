import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  final Function(File?) onImageSelected;

  ImageSourceSheet({required this.onImageSelected});

  void imageSelected(PickedFile? image) async {
    final crop = ImageCropper();
    if (image != null) {
      File? cropped = await crop.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0));
      onImageSelected(cropped);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        backgroundColor: Colors.blueGrey,
        onClosing: () {},
        builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                      child: Icon(
                        Icons.camera_alt,
                      ),
                      onPressed: () async {
                        PickedFile? image = await ImagePicker.platform
                            .pickImage(source: ImageSource.camera);
                        imageSelected(image);
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                      child: Icon(Icons.image),
                      onPressed: () async {
                        PickedFile? image = await ImagePicker.platform
                            .pickImage(source: ImageSource.gallery);
                        imageSelected(image);
                      }),
                )
              ],
            ));
  }
}
