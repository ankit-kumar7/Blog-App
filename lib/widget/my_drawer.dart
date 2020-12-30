import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class MyDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser.uid;
    return FutureBuilder(
      // ignore: deprecated_member_use
      future: Firestore.instance.collection('users').doc(userId).get(),
      builder: (context, snapshot) {
        var userData = snapshot.data;
        return Drawer(
              child:ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName:userData==null ?CircularProgressIndicator():Text(userData['userName'],
                    style: TextStyle(
                      fontSize: 30,
                    ),),
                    accountEmail: userData==null ?CircularProgressIndicator():Text(userData['userEmail'],
                    style: TextStyle(
                      fontSize: 15
                    ),),
                    currentAccountPicture:userData==null ?CircularProgressIndicator(): CircleAvatar(
                      backgroundImage: NetworkImage(userData['userImage']),
                      backgroundColor: Colors.white,
                      radius: 40,
                    ),
                  ),
                  ListTile(
                    title: Text("Home",
                    style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ),),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: ()
                    {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed('/bottomNavigation');
                    },
                  ),
                  ListTile(
                    title: Text("LogOut",
                      style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),),
                    trailing: Icon(Icons.exit_to_app_outlined),
                    onTap: ()async
                    {
                      await FirebaseAuth.instance.signOut();
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("You are logout"),));
                      exit(0);
                    },
                  ),
                ],
              ),
        );
      }
    );
  }
}
