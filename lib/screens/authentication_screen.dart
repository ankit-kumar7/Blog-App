import 'package:blog_app/widget/auth_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:io';


class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {

  var _isLoading = false;


  void userValue(
      var _loginState,
      String _userEmail,
      String _userName,
      String _userPassword,
  )async
  {
    setState(() {
      _isLoading = true;
    });
    try{
      UserCredential _authResult;
      if(_loginState) {
        _authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _userEmail, password: _userPassword);
      }
      else
        {
          _authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email:_userEmail , password: _userPassword);
          // ignore: deprecated_member_use
          Firestore.instance.collection('users').doc(_authResult.user.uid).setData({
            'userEmail':_userEmail,
            'userName':_userName,
            'userImage':'https://www.winhelponline.com/blog/wp-content/uploads/2017/12/user.png',
          });
        }
      Alert(
        context: context,
        type: AlertType.success,
        title: _loginState?"Login":"Sign Up",
        desc: _loginState? "Login Successfully." : "Create Account Successfully.",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: (){
              setState(() {
                _isLoading = false;
              });
              Navigator.of(context).pushReplacementNamed('/bottomNavigation');
            },
            width: 120,
          )
        ],
      ).show();
    }on FirebaseAuthException catch  (e) {
      final String wrongUserEmailPassword = "There is no user record corresponding to this identifier. The user may have been deleted.";
      Alert(
        context: context,
        type: AlertType.error,
        title: _loginState?"Login":"Sign Up",
        desc: _loginState? (wrongUserEmailPassword == e.message ? "User doesn't exist . Create new account" : "Wrong Password" )
            : "Already have an account",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: (){
              Navigator.of(context).pop();
              setState(() {
                _isLoading = false;
              });
              Navigator.of(context).pushReplacementNamed('/authenticationScreen');
            },
            width: 120,
          )
        ],
      ).show();
    }
    setState(() {
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    final _objectHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop:()=>exit(0),
      child: Scaffold(
        body: _isLoading ? Center(child: CircularProgressIndicator()):SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top:_objectHeight*0.1),
                child: Column(
                  children: [
                    Image.asset('assets/logo.png',
                    height: _objectHeight*0.2,),
                    Image.asset('assets/sublogo.png'),
                  ],
                ),
              ),
              AuthForm(userValue),
            ],
          ),
        ),
      ),
    );
  }
}
