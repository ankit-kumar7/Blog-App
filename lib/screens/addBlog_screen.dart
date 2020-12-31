import 'dart:io';
import 'package:blog_app/widget/addBlog_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class AddBlogScreen extends StatefulWidget {
  @override
  _AddBlogScreenState createState() => _AddBlogScreenState();
}

class _AddBlogScreenState extends State<AddBlogScreen> {
  File _selectImage ;
  String _description;
  final _formKey = GlobalKey<FormState>();
  bool spiner = false;

  void _imagePicker() async
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
    });
  }

  bool descriptionValidator()
  {
    if(_formKey.currentState.validate())
      {
        _formKey.currentState.save();
        return true;
      }
    else
      return false;
  }

  void _storeDataToDatabase()async
  {
    if(descriptionValidator())
    {
      FocusScope.of(context).unfocus();
      setState(() {
        spiner = true;
      });
      AddBlogDatabase obj = AddBlogDatabase(context:context,description: _description, image: _selectImage);
      await obj.postDetails();
      setState(() {
        spiner = false;
      });
     Navigator.of(context).pushReplacementNamed('/bottomNavigation');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>Navigator.of(context).pushReplacementNamed('/bottomNavigation'),
      child: _selectImage ==  null ? Center(
        child: FlatButton.icon(
          label: Text("Click to add an image"),
          icon: Icon(Icons.camera_alt_outlined),
          onPressed:_imagePicker,
        ),) :
      spiner ? Center(child: CircularProgressIndicator(
        backgroundColor: Colors.white10.withOpacity(0.25),
      ),)
          : SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Image.file(_selectImage,
                  height: MediaQuery.of(context).size.height*0.4,
                  width: MediaQuery.of(context).size.width),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.05,
            ),
            Container(
              width: double.infinity,
              child: Form(
                key: _formKey,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Description",
                  ),
                  maxLines:null,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value){
                    if(value.isEmpty)
                      return "Description can't be empty.";
                    else
                      return null;
                  },
                  onSaved: (value){
                    _description = value;
                  },
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.1,
            ),
            RaisedButton(
              shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Theme.of(context).primaryColor,
              child: Text("Add Blog",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),),
              onPressed: _storeDataToDatabase,
            ),
          ],
        ),
      ),
    );
  }
}
