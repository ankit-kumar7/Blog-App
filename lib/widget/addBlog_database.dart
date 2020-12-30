import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';



class AddBlogDatabase {
  AddBlogDatabase({@required this.context,@required this.description, @required this.image});

  final String description;
  final File image;
  final BuildContext context;

  Future<void> postDetails()async
  {
    DateTime now = DateTime.now();
    String date =  DateFormat.yMMMMd('en_US').format(now);
    String time = DateFormat.jm().format(now);

    // Add the data in cloud store with user id
    try{
      String userId =  FirebaseAuth.instance.currentUser.uid;

      final userImageRef = FirebaseStorage.instance.ref().child('blog_image').child(userId+Timestamp.now().toString()+'.jpg');

      await userImageRef.putFile(image);

      final url = await userImageRef.getDownloadURL();

      // ignore: deprecated_member_use
      await Firestore.instance.collection('blog').add({
        'userId':userId,
        'description' : description,
        'imageUrl' : url,
        'time':time,
        'date':date,
        'createdAt':Timestamp.now(),
      });
    }catch(error)
    {
      print(error);
    }
  }
}
