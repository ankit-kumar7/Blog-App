import 'package:blog_app/widget/user_image_update.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class UserData extends StatefulWidget {

  @override
  _UserDataState createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {

  bool spiner = false;

  void userImage(File _userImage)async
  {
    try{

      setState(() {
        spiner = true;
      });
      String userId =  FirebaseAuth.instance.currentUser.uid;

      final userImageRef = FirebaseStorage.instance.ref().child('user_image').child(userId+Timestamp.now().toString()+'jpg');

      await userImageRef.putFile(_userImage);

      final url = await userImageRef.getDownloadURL();

      // ignore: deprecated_member_use
      await Firestore.instance.collection('users').doc(userId).update({
        'userImage':url,
      });
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Profile picture updated successfully"),),);
      setState(() {
        spiner = false;
      });
    }catch (e)
    {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // ignore: deprecated_member_use
      future: Firestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).get(),
      builder: (context,snapShot){
        final userData = snapShot.data;
        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40),
              child: Center(
                child: userData == null ? CircularProgressIndicator(): spiner ? CircularProgressIndicator() :
                CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(userData['userImage'],
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*0.30,
              left: MediaQuery.of(context).size.height*0.30,
              child: UserImageUpdate(userImage),
            ),
          ],
        );
      },
    );
  }
}
