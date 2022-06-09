import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MediaPicker extends StatefulWidget {
  const MediaPicker({Key? key}) : super(key: key);

  @override
  _MediaPickerState createState() => _MediaPickerState();
}

class _MediaPickerState extends State<MediaPicker> {
  late File _image;

  Future<File> pickImage(bool x) async {
    XFile? tempImage;
    if (x) {
      tempImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    } else {
      tempImage = await ImagePicker().pickImage(source: ImageSource.camera);
    }
    return (await ImageCropper.cropImage(
      sourcePath: tempImage!.path,
      maxWidth: 1080,
      maxHeight: 1080,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      androidUiSettings: const AndroidUiSettings(
        toolbarTitle: 'Cropper',
        showCropGrid: false,
        toolbarColor: Colors.blueGrey,
        activeControlsWidgetColor: Colors.blueGrey,
        statusBarColor: Colors.white,
        toolbarWidgetColor: Colors.white,
      ),
    ))!;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      titlePadding: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      title: Container(
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.blueGrey),
        child: const Text(
          'Upload From:',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 3, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      content: SizedBox(
        width: 100,
        height: 125,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                IconButton(
                    onPressed: () async {
                      _image = await pickImage(true);
                      Navigator.pop(context, _image);
                    },
                    iconSize: 75,
                    splashColor: Colors.white,
                    icon: const Icon(
                      Icons.folder,
                      color: Colors.blueGrey,
                    )),
                const Text('Gallery')
              ],
            ),
            Column(
              children: [
                IconButton(
                    onPressed: () async {
                      _image = await pickImage(false);
                      Navigator.pop(context, _image);
                    },
                    iconSize: 75,
                    splashColor: Colors.white,
                    icon: const Icon(
                      Icons.camera,
                      color: Colors.blueGrey,
                    )),
                const Text('Camera')
              ],
            )
          ],
        ),
      ),
    );
  }
}
