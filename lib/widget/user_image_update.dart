import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImageUpdate extends StatefulWidget {

  UserImageUpdate(this.userImage);

  final void Function(File userImage) userImage;

  @override
  _UserImageUpdateState createState() => _UserImageUpdateState();
}

class _UserImageUpdateState extends State<UserImageUpdate> {

  File _selectImage;
  bool spiner = false;

  void getUserImage ()async
  {
    final _pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
    File _croppedImage = await ImageCropper.cropImage(
      sourcePath: _pickedImage.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ]
          : [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio5x3,
        CropAspectRatioPreset.ratio5x4,
        CropAspectRatioPreset.ratio7x5,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    );

    setState(() {
      _selectImage = File(_croppedImage.path);
      spiner = true;
    });
    widget.userImage(_selectImage);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(Icons.add_a_photo_outlined),
        iconSize: 35,
        color: Colors.pink,
        onPressed: getUserImage,
    );
  }
}
